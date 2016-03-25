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
        console.log(data.checked_types)
        for t in data.issue_types
          checkbox = '<input type="checkbox" class="issue_type" value="' + t.attributes.id + '"'
          if (-1 != data.checked_types.indexOf(t.attributes.id))
            checkbox += ' checked="checked"'
          checkbox += '>' + t.attributes.name
          checkbox += '<br>'
          $('#issue_types').append(checkbox)

  $('.projects-save').click ->
    console.log('clicked');
    neko.showMask();
    issueTypeIds = []
    $('.issue_type:checked').each ->
      issueTypeIds.push($(@).val())

    $('#issues').empty()
    $.ajax '/issue_types/' + $('#projects').val(),
      type: 'PUT'
      dataType: 'json',
      data: {"issueTypeId[]": issueTypeIds},
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (xhr, status, data) ->
        console.log(status, data)
        location.href = '/dashboard'

  $("#projects").change ->
    $(".inner-intro").animate
        left: '-=400'
        500

  $(".projects-back").click ->
    $(".inner-intro").animate
        left: '+=400'
        500
