class OrderMailer < ApplicationMailer
  # Setting default value for Mailer
  default from: ADMIN_EMAIL

  def received(order)
    @order = order
    order.line_items.each do |line_item|
      product = line_item.product
      product_images = product.images.to_a

      attachments.inline["#{product.title}_1"] = product_images.shift
      product_images.each do |image|
        attachments["#{product.title}_#{image.filename}"] = image
      end
    end
    I18n.with_locale(User.languages[@order.user.language]) do
      mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
    end
  end

  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order shipped'
  end
end
