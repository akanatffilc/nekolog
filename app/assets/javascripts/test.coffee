$ ->
  $.ajax '/projects',
    type: 'GET'
    dataType: 'json',
    error: (xhr, status, error) ->
      console.error(status, error)
    success: (data, status, xhr) ->
      for p in data.projects
        $('#projects_for_issues').append('<option value="' + p.attributes.id + '">' + p.attributes.name + '</option>')

  calculate_pos = ($item) ->
    idx = $('.issue').index($item)
    prev = Math.max(0, idx - 1)
    next = Math.min($('.issue').length, idx + 1)
    if idx == prev
      prev_pos = 0.0
    else
      prev_pos = parseFloat($('.issue').eq(prev).data('pos'))
    if idx == next
      next_pos = 65535.0
    else
      next_pos = parseFloat($('.issue').eq(next).data('pos'))

    return (next_pos + prev_pos) / 2

  update_item = (item) ->
    console.log($(item).data('id'), $(item).data('pos'))

    id = $(item).data('id')
    pos = calculate_pos($(item))

    console.log(id + '=' + pos)

    p = $('#projects_for_issues').val()
    b = $(item).parent().attr('id').substring(6)
    $.ajax '/issues/' + id,
      type: 'PUT'
      dataType: 'json',
      data: {"project_id": p, "board_id": b, "position": pos},
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (xhr, status, data) ->
        console.log(status, data)
        $(item).attr('data-pos', pos)

  init_backlog_issues = () ->
    $('#issues').empty()
    $.ajax '/issues',
      type: 'GET'
      dataType: 'json',
      data: {"projectId": $('#projects_for_issues').val(), "type": "issues"}
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (data, status, xhr) ->
        console.log(status, data)
        $('#issues').empty()
        for issue in data.issues
          li = '<li id="issue_' + issue.id + '" class="issue" data-id="' + issue.id + '" data-pos="' + issue.position + '">' + issue.summary + '</li>'
          $('#issues').append(li)

  types = {1: "todo", 2: "doing", 3: "done"}

  init_nekolog_issues = (i) ->
    $('#board_' + i).empty()
    p = $('#projects_for_issues').val()
    b = i
    $.ajax '/issues',
      type: 'GET'
      dataType: 'json',
      data: {"projectId": p, "statusId": [b], "type": types[i]}
      error: (xhr, status, error) ->
        console.error(status, error)
      success: (data, status, xhr) ->
        console.log(status, data)
        for issue in data.issues
          li = '<li id="issue_' + issue.id + '" class="issue" data-id="' + issue.id + '" data-pos="' + issue.position + '">' + issue.summary + '</li>'
          $('#board_' + i).append(li)


  $('#projects_for_issues').change ->
    if '' == $(@).val()
      return

    init_backlog_issues()
    for i in [1,2,3]
      init_nekolog_issues(i)

  $(".sortable").sortable({connectWith: '.sortable'})
  $(".sortable").disableSelection()
  $(".sortable").sortable {
    update: (ev, ui) ->
      update_item(ui.item)
  }
