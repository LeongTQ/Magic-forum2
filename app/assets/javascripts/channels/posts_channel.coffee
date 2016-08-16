postsChannelFunctions = () ->

  checkMe = (comment_id, username) ->
    unless $('meta[name=wizardwonka]').length > 0 || $("meta[user=#{username}]").length > 0 
      $(".comment[data-id=#{comment_id}] .control-panel").remove()
    $(".comment[data-id=#{comment_id}]").removeClass("hidden")

  if $('.comments.index').length > 0

    App.posts_channel = App.cable.subscriptions.create {
      channel: "PostsChannel"
    },
    connected: () ->
      console.log("loaded")

    disconnected: () ->

    received: (data) ->
      if $('.comments.index').data().id == data.post.id
        $('#comments').prepend(data.partial)
        checkMe(data.comment.id)

$(document).on 'turbolinks:load', postsChannelFunctions
