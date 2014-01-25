Meteor.publish 'userTasks', ()->
  UserTasks.find({$or: [{assignedToUser: this.userId}, {createdBy: this.userId}]})