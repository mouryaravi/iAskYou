Template.newGroup.events
  'submit form': (event) ->
    event.preventDefault()

    members = []

    group =
      title: $(event.target).find('[name=title]').val()
      description: $(event.target).find('[name=description]').val()
      type: $(event.target).find('input[type=radio]:checked').attr 'value'

    $('input[type=checkbox]:checked').each ()->
      members.push $(@).attr 'value'

    group.members = members

    console.log group

    Meteor.call 'newGroup', group, (err, id)->
      if (err)
        throw new Meteor.Error err.reason
      else
        Router.go 'userGroups'



Template.newGroup.helpers
  users: ()->
    Meteor.users.find()

