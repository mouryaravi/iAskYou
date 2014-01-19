Template.userTaskItem.helpers
  isAssignedToMe: ()->
    this.assignedTo == Meteor.userId() and this.createdBy != Meteor.userId()

  createdByUser: ()->
    Meteor.users.findOne this.createdBy


  dueByText: ()->
    moment(this.dueBy).fromNow()

Template.userTaskItem.events
  'click .finished-task': (event)->
    event.preventDefault()
    Meteor.call 'finishTask', {@_id}, (err, resp)->
      if err then Errors.throw(err.reason)
