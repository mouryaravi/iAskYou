Template.userCreatedTaskItem.helpers
  assignedToUser: ()->
    Meteor.users.findOne this.assignedTo


Template.userCreatedTaskItem.events
  'click .taskReminder': (event)->
    Reminders.insert
      taskId: this._id
      remindedBy: Meteor.userId()
      userId: this.assignedTo
