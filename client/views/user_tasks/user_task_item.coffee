Template.userTaskItem.helpers
  isAssignedToMe: ()->
    this.assignedTo == Meteor.userId() and this.createdBy != Meteor.userId()

  createdByUser: ()->
    Meteor.users.findOne this.createdBy



Template.userTaskItem.events
  'click .finished-task': (event)->
    event.preventDefault()
    console.log 'finished task: ', @title
    Meteor.call 'finishTask', {@_id}, (err, resp)->
      if err then Errors.throw(err.reason)
