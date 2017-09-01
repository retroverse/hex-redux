module.exports = ->
  post = (title, msg, c='error')->
    h = "
    <div class='notification'>
      <div class='content #{c}'>
        #{
          #title
          if title
            "<h1 class='notification-title'>#{title}</h1>"
          else
            ""
        }
        #{
          #Message
          if msg
            "<p>#{msg}</p>"
          else
            ""
        }
      </div>
    </div>
    "

    h = $(h)
    $('.notifications').prepend(h)
    h.css("opacity", "0.4")
      .transition({ opacity: "1"}, 300)

    #Move All others
    for noti in this.state.notifications
      noti.css("top", 100).transition({
        duration: 300,
        "top": 0
      })


    return this.state.notifications.push(h) - 1

  pop = (id)->
    n = this.state.notifications[id]
    n.remove()
    this.state.notifications.splice(id, 1)

    #Move All others
    for noti, i in this.state.notifications when i < id
      noti.css("top", -100).transition({
        duration: 300,
        "top": 0
      })

  return {
    state: {
      notifications: []
    },
    post,
    pop
  }
