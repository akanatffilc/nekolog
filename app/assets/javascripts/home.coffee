# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $.ajax '/projects',
    type: 'GET'
    dataType: 'json',
    error: (xhr, status, error) ->
      console.error(status, error)
    success: (data, status, xhr) ->
      for p in data.projects
        $('#projects').append('<li>' + p.attributes.name + '</li>')
