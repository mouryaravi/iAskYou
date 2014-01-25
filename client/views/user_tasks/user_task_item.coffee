Template.userTaskItem.helpers
  isAssignedToMe: ()->
    @assignedToUser == Meteor.userId() and @createdBy != Meteor.userId()

  createdByUser: ()->
    Meteor.users.findOne @createdBy


  dueByText: ()->
    moment(@dueBy).fromNow()

Template.userTaskItem.events
  'click .finished-task': (event)->
    event.preventDefault()
    Meteor.call 'finishTask', {@_id}, (err, resp)->
      if err then Errors.throw(err.reason)
