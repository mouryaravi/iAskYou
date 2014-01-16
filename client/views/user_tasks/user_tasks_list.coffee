Template.userTasksList.helpers
  tasks: ()->
    UserTasks.find {assignedTo: Meteor.userId()}, {sort: {createdAt: -1}}
