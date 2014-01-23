Meteor.methods
  newTaskList: (title, newTaskListParams)->
    console.log 'new task list params', newTaskListParams, title
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless title
      throw new Meteor.Error 422, 'Please fill in task list title'

    taskList =
      title: title
      createdBy: Meteor.userId()

    taskListId = TaskLists.insert taskList
    _.each newTaskListParams, (newTaskParams)->
      newTaskParams['taskList'] = taskListId
      Meteor.call 'newTask', newTaskParams
