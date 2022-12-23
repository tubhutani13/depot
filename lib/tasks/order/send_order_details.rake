namespace :order do
    desc 'Sends all of the users a consolidated email of all his/her orders and items'
    task :send_order_details => :environment do
      Order.all.each do |order| 
        puts "Sending order details for user #{order.user.name} with ID #{order.user.id}."
        OrderMailer.received(order)
      end
      puts "Order details sent to all users."
    end
  end
