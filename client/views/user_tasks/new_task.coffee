Template.newTask.events
  'submit form': (event) ->
    event.preventDefault()

    task =
      assignedTo: $(event.target).find('[name=assignedTo]').val(),
      title: $(event.target).find('[name=title]').val(),
      description: $(event.target).find('[name=description]').val()
      dueBy: $(event.target).find('[name=dueBy]').val()

    task.dueBy = moment(new Date(task.dueBy)).valueOf()
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


Template.newTask.rendered = ()->
  $('.datepicker').datepicker({
    format: 'mm/dd/yyyy'
    autoclose: true
    todayHighlight: true
  })
