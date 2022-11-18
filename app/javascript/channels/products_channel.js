import consumer from "channels/consumer"

// name in create function mentions the channel to connect to
consumer.subscriptions.create("ProductsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // data is received passed down the channel
    // finding store element to only update Store part of layout
    const storeElement = document.querySelector("main.store");
    if (storeElement) {
      // html key exist because of ruby hash, data sent in 'html' key through channel
      storeElement.innerHTML = data.html
    }
  }
});
