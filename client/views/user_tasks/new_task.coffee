Template.newTask.events
  'submit form': (event) ->
    event.preventDefault()

    task = 
      username: $(event.target).find('[name=username]').val(),
      title: $(event.target).find('[name=title]').val(),
      description: $(event.target).find('[name=description]').val(),
      postedBy: Meteor.username

    Meteor.call 'newTask', task, (err, id)->
      if err
        alert err.reason
    Router.go 'userTasksList'
