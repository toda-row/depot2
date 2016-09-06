require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

#　あるユーザーがオンラインストアのインデックスページに訪れます。
#　ユーザーは商品を選択してカートに入れます。
#　その後ユーザーはチェックアウトフォームに入力してチェックアウトとします。
#　チェックアウトフォームを送信するとカートに追加された商品に対応する1つの品目とともにユーザー情報が含まれた注文が作成されます。

	test "buying a product" do
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)

		get "/"
		assert_response :success
		assert_template "index"


		xml_http_request :post, '/line_items', product_id: ruby_book.id
		assert_response :success

		cart = Cart.find(session[:cart_id])
		assert_equal 1, cart.line_items.size
		assert_equal ruby_book, cart.line_items[0].product

		get "/orders/new"
		assert_response :success
		assert_template "new"

		post_via_redirect "/orders",
			order: { name: "Dave Thomas",
					address: "123 The Street",
					email:  "yoshihiro.t.88@gmail.com",
					pay_type: "Check" }

		assert_response :success
		assert_template "index"
		cart = Cart.find(session[:cart_id])
		assert_equal 0, cart.line_items.size

		orders = Order.all
		assert_equal 1, orders.size
		order = orders[0]

		assert_equal "Dave Thomas", order.name
		assert_equal "123 The Street", order.address
		assert_equal "yoshihiro.t.88@gmail.com", order.email
		assert_equal "Check", order.pay_type

		assert_equal 1,order.line_items.size
		line_item = order.line_items[0]
		assert_equal ruby_book, line_item.product

		mail = ActionMailer::Base.deliveries.last
		assert_equal ["yoshihiro.t.88@gmail.com"], mail.to
		assert_equal 'Sum Ruby <cafe.commune20@gmail.com>', mail[:from].value
		assert_equal "Pragmatic Store Order Confirmation", mail.subject
	end
end
