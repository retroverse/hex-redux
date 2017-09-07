module.exports = ->
  post = (title, msg, c='message')->
    # Is this a duplicate?
    for noti in this.state.notifications
      if noti.title is title and noti.message is msg and noti.cl is c
        noti.incCount()
        return

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
        <div class='count'></div>
      </div>
    </div>
    "

    h = $(h)
    h.count = 1
    h.title = title
    h.message = msg
    h.cl = c
    h.incCount = (n)->
      @children().children().last().transition({
        duration: 300,
        'opacity': 1
      })
      .html('x' + @count += 1)
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
  clear = (filter)->
    change =
      if filter
        this.state.notifications.filter(
          (n) -> n.children().first().hasClass(filter)
        )
      else
        this.state.notifications

    for noti in change
      noti.transition({
        duration: 200,
        'opacity': 0
      })
      setTimeout((-> noti.remove()), 200)
    this.state.notifications =
      if filter
        this.state.notifications.filter(
          (n) -> not n.children().first().hasClass(filter)
        )
      else
        []

  return {
    state: {
      notifications: []
    },
    post,
    pop,
    clear
  }
