Template.newGroup.events
  'submit form': (event) ->
    event.preventDefault()

    group =
      name: $(event.target).find('[name=name]').val(),
      description: $(event.target).find('[name=description]').val()

    Meteor.call 'newGroup', group, (err, id)->
      if err
        alert err.reason
    Router.go 'userGroups'
