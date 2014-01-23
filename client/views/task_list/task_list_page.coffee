Template.taskListPage.helpers

  tasks: ()->
    taskListId = @_id
    UserTasks.find({
      'taskList': taskListId
      'createdBy': Meteor.userId()
    })