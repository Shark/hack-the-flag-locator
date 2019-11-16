// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

  App.cable.subscriptions.create({ channel: "WaitForMacChannel" }, {
    received(url) {
      let btn = document.querySelector('#join_game_button')

      if(btn) {
        btn.removeAttribute('disabled')
        btn.setAttribute('class', 'btn btn-primary')
        btn.addEventListener('click', function () {
          location.href = url
        })
      }
    }
  })
}).call(this);
