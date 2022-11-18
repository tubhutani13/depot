# This file contains channel code related to Ruby backend
class ProductsChannel < ApplicationCable::Channel
  def subscribed
    # Start streaming from named broadcasting pubsub queue
    # Possible for channel to support multiple streams
    stream_from "products"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
