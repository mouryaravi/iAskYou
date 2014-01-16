Meteor.publish 'userTasks', ()->
  UserTasks.find({$or: [{assignedTo: this.userId}, {createdBy: this.userId}]})