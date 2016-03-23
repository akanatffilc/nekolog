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
        $('#projects').append('<option value="' + p.attributes.id + '">' + p.attributes.name + '</option>')

  $('#projects').change ->
    console.log($(@).val())
    $.ajax '/issue_types/' + $(@).val(),
      type: 'GET',
      dataType: 'json',
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (data, status, xhr) ->
        for t in data.issue_types
          $('#issue_types').append('<input type="checkbox" value="' + t.id + '">' + t.attributes.name)

