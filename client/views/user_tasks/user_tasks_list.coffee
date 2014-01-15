Template.userTasksList.helpers
  tasks: ()->
    UserTasks.find {}, {sort: {createdAt: -1}}
