Meteor.publish 'reminders', ()->
  Reminders.find({userId: this.userId})