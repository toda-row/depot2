atom_feed do |feed|
	feed.title "who bought #{@product.title}"

	latest_order = @product.orders.sort_by(&:updatesd_at).last
	feed.update( latest_order && latest_order.updatesd_at )

	@product_orders.each do |order|
		feed.entry(order) do |entry|
			entry.title "Order #{order.id}"
			entry.summary type: 'xhtml' do |xhtml|
				xhtml.p "Shipped to #{order.address}"

				xhtml.table do
					xhtml.tr do
						xhtml.th 'Product'
						xhtml.th 'Quantity'
						xhtml.th 'Total Price'
					end

					order.line_items.each do |item|
						xhtml.td do
							xhtml.td item.product.title
							xhtml.td item.quantity
							xhtml.td number_to_currency item.total_price
						end
					end

					xhtml.tr do
						xhtml.th 'total', colspan: 2
						xhtml.th number_to_currency \
							order.line_items.map($:total_price).sum
					end
				end

				xhtml.p "Paid by #{order.pay_type}"
			end
			entry.author do |author|
				entry.name order.name
				entry.email order.email
			end
		end
	end
end