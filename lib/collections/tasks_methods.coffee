Meteor.methods
  newTask: (newTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless newTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless newTaskParams.assignedTo
      throw new Meteor.Error 422, 'Please fill in assignee'

    isUser = /user:/.test newTaskParams.assignedTo
    isGroup = /group:/.test newTaskParams.assignedTo

    task = _.extend _.pick(newTaskParams, 'title', 'description', 'assignedTo'),
      createdBy: Meteor.userId()
      dueBy: moment(newTaskParams.dueBy).valueOf()

    task.assignedTo = task.assignedTo.replace /.*:/, ''
    if isUser
      taskId = UserTasks.insert task
    else
      taskId = GroupTasks.insert task


  finishTask: (finishTaskParams)->
    console.log 'finishing task', finishTaskParams
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'

    task = UserTasks.find finishTaskParams._id
    unless task
      throw new Meteor.Error 401, 'Task not found'

    if task.assignedTo in [user._id]
      throw new Meteor.Error 403, "Can not finish other's tasks"

    UserTasks.update {_id: finishTaskParams._id}, {$set: {status: 'Finished', finishedBy: user._id}}