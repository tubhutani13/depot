class OrderMailer < ApplicationMailer
  # Setting default value for Mailer
  default from: 'Sam ruby <depot@example.com>'

  def received(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order Confirmation'
  end

  def shipped(order)
    @order = order

    mail to: order.email, subject: 'Pragmatic Store Order shipped'
  end
end
