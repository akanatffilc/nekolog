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
    $('#issue_types').empty()
    console.log($(@).val())
    $.ajax '/issue_types/' + $(@).val(),
      type: 'GET',
      dataType: 'json',
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (data, status, xhr) ->
        for t in data.issue_types
          $('#issue_types').append('<input type="checkbox" class="issue_type" value="' + t.attributes.id + '">' + t.attributes.name)

  $(document).on 'click', '.issue_type', ->
    issueTypeIds = []
    $('.issue_type:checked').each ->
      issueTypeIds.push($(@).val())

    $('#issues').empty()
    $.ajax '/issues',
      type: 'GET'
      dataType: 'json',
      data: {"projectId[]": $('#projects').val(), "issueTypeId[]": issueTypeIds},
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (data, status, xhr) ->
        for i in data.issues
          $('#issues').append('<li>' + i.attributes.summary + '</li>')
