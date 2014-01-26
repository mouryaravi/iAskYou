Template.userTaskItem.helpers
  isAssignedToMe: ()->
    @assignedToUser == Meteor.userId() and @createdBy != Meteor.userId()

  createdByUser: ()->
    Meteor.users.findOne @createdBy

  dueByText: ()->
    moment(@dueBy).fromNow()

  taskGroup: ()->
    if @assignedToGroup
      UserGroups.findOne @assignedToGroup, {fields: {title: 1}}

  isFinished: ()->
    if @assignedToGroup
      _.contains @finishedGroupMembers, Meteor.userId()
    else
      @status == 'Finished'

Template.userTaskItem.events
  'click .finished-task': (event)->
    event.preventDefault()
    Meteor.call 'finishTask', {@_id}, (err, resp)->
      if err then Errors.throw(err.reason)
