Template.newTask.events
  'submit form': (event) ->
    event.preventDefault()

    task =
      assignedTo: $(event.target).find('[name=assignedTo]').val(),
      title: $(event.target).find('[name=title]').val(),
      description: $(event.target).find('[name=description]').val()
      dueBy: $(event.target).find('[name=dueBy]').val()
      reminder: $(event.target).find('#reminder:selected').val()

    if task.dueBy
      task.dueBy = moment(moment(task.dueBy).format('YYYY-MM-DD')).add('hours', 23).add('minutes', 59).valueOf()
    console.log 'new task: ', task
    Meteor.call 'newTask', task, (err, id)->
      if err
        throw new Errors.throw(err.reason)
      else
        Router.go 'userTasksList'


Template.newTask.helpers
  connections: ()->
    Meteor.users.find({})

  groups: ()->
    UserGroups.find({})

  reminders: ()->
    [
      {_id: '5SECONDSBEFORE', value: '5 Seconds Before'}
      {_id: '5MINSBEFORE', value: '5 Minutes Before'}
      {_id: '1HOURBEFORE', value: '1 Hour Before'}
      {_id: '1DAYBEFORE', value: '1 Day Before'}
      {_id: 'EVERY5SECONDS', value: 'Every 5 Seconds'}
    ]


Template.newTask.rendered = ()->
  $('.datepicker').datepicker({
    format: 'mm/dd/yyyy'
    autoclose: true
    todayHighlight: true
  })
