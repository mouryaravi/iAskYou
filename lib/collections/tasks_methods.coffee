populateAssignee = (params, task)->
  assignee =  params.assignedTo.replace /.*:/, ''
  isUser = /user:/.test params.assignedTo
  isGroup = /group:/.test params.assignedTo

  if isUser
    task.assignedToUser = assignee
  else
    task.assignedToGroup = assignee


Meteor.methods
  newTask: (newTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless newTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless newTaskParams.assignedTo
      throw new Meteor.Error 422, 'Please fill in assignee'

    task = _.extend _.pick(newTaskParams, 'title', 'description', 'assignedTo', 'taskList'),
      createdBy: Meteor.userId()
      dueBy: moment(newTaskParams.dueBy).valueOf()

    populateAssignee newTaskParams, task

    console.log 'Got new task params...', task
    UserTasks.insert task


  finishTask: (finishTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'

    task = UserTasks.findOne finishTaskParams._id
    unless task
      throw new Meteor.Error 401, 'Task not found'

    unless task.assignedToUser == user._id
      throw new Meteor.Error 403, "Can not finish other's tasks"

    console.log 'finishing task', task.title, ", by ", user._id

    if task.assignedToGroup
      UserTasks.update {_id: finishTaskParams._id}, {$push: {finishedGroupMembers: user._id}}
    else
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


    task = _.extend _.pick(editTaskParams, 'title', 'description', 'assignedTo'),
      dueBy: moment(editTaskParams.dueBy).valueOf()

    populateAssignee editTaskParams, task
    UserTasks.update oldTask._id, {$set: task}
    oldTask._id