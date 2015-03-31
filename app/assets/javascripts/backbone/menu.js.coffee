
class window.MenuView extends Backbone.View

  el: "#header"

  events:
    "click .more": "toggle"

  toggle: ->
    $('.sliding').toggleClass('revealed')

  initialize: ->

$(document).on 'page:change', ->
  menu_view = new MenuView()