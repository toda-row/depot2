class CombineItemsInCart < ActiveRecord::Migration
	def up
		#カート内に1つの商品に対して、複数の品目があった場合は、1つの品目に置き換える。
		Cart.all.each do |cart|
			#カート内の各商品の数をカウントする
			sums = cart.line_items.group(:product_id).sum(:quantity)

			sums.each do |product_id, quantity|
				if quantity > 1
					#個別の品目を削除する
					cart.line_items.where(product_id: product_id).delete_all
					#一つの品目に置き換える
					cart.line_items.create(product_id: product_id, quantity: quantity)
				end
			end
		end
	end

	def down
		# 数量>1の品目を複数の品目に分割する
		Line_item.where("quantity>1").each do |line_item|
			#個別の品目を追加する
			line_item.quantity.times do
				Line.create cart_id: line_item.cart_id,
					product_id: line_item.product_id, quantity: 1
			end

			#　本の品目を削除する
			line_item.destroy
		end
	end
end