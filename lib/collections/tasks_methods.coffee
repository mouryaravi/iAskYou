Meteor.methods
  newTask: (newTaskParams)->
    console.log 'Got new task params...', newTaskParams
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless newTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless newTaskParams.assignedTo
      throw new Meteor.Error 422, 'Please fill in assignee'

    isUser = /user:/.test newTaskParams.assignedTo
    isGroup = /group:/.test newTaskParams.assignedTo

    task = _.extend _.pick(newTaskParams, 'title', 'description', 'assignedTo', 'taskList'),
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


  editUserTask: (editTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'

    oldTask = UserTasks.findOne editTaskParams._id
    if oldTask.createdBy != user._id
      throw new Meteor.Error 403, 'You cant edit this task'
    unless editTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless editTaskParams.assignedTo
      throw new Meteor.Error 422, 'Please fill in assignee'

    isUser = /user:/.test editTaskParams.assignedTo
    isGroup = /group:/.test editTaskParams.assignedTo

    task = _.extend _.pick(editTaskParams, 'title', 'description', 'assignedTo'),
      dueBy: moment(editTaskParams.dueBy).valueOf()

    console.log 'Updated task: ', task
    task.assignedTo = task.assignedTo.replace /.*:/, ''
    if isUser
      taskId = UserTasks.update oldTask._id, {$set: task}
    else
      taskId = GroupTasks.update oldTask._id, {$set: task}
    oldTask._id