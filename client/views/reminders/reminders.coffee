Template.reminders.helpers
  remindersCount: ()->
    Reminders.find(
      userId: Meteor.userId()
      read: false
    ).count()

  reminders: ()->
    Reminders.find
      userId: Meteor.userId()
      read: false


Template.reminder.events
  'click li': (event)->
    Reminders.update this._id, {$set: {read: true}}


Template.reminder.helpers
  reminderTaskPath: ()->
    Router.routes['userTaskPage'].path({_id: this.taskId})

  remindedByUser: ()->
    Meteor.users.findOne({_id: this.remindedBy}).profile.name

  taskTitle: ()->
    UserTasks.findOne({_id: this.taskId}).title