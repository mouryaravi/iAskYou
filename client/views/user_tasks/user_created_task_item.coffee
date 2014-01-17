Template.userCreatedTaskItem.helpers
  assignedToUser: ()->
    Meteor.users.findOne this.assignedTo