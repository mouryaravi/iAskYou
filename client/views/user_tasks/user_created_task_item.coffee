Template.userCreatedTaskItem.helpers
  assignedToUser: ()->
    Meteor.users.findOne @assignedToUser


Template.userCreatedTaskItem.events
  'click .taskReminder': (event)->
    Reminders.insert
      taskId: @_id
      remindedBy: Meteor.userId()
      userId: @assignedToUser
