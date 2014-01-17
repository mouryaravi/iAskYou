Template.newTask.events
  'submit form': (event) ->
    event.preventDefault()

    task =
      assignedTo: $(event.target).find('[name=assignedTo]').val(),
      title: $(event.target).find('[name=title]').val(),
      description: $(event.target).find('[name=description]').val()

    Meteor.call 'newTask', task, (err, id)->
      if err
        alert err.reason
    Router.go 'userTasksList'


Template.newTask.helpers
  connections: ()->
    Meteor.users.find({})

  groups: ()->
    UserGroups.find({})


Template.newTask.rendered = ()->
  $('.datetimepicker').datetimepicker()
