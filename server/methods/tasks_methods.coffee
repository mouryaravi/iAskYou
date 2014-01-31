scheduleReminderForTask = (task)->
  if task.reminder and task.reminder != 'None'

    console.log 'reminder for', task
    cron = new ReminderCron
      cronTime: '*/5 * * * * *'
      onComplete: null
      timeZone: null
      start: false

    boundFunction = Meteor.bindEnvironment(
      ()->
        task = UserTasks.findOne task._id
        addReminderToTask task, cron
      (e)->
        throw e
    )
    cron.addCallback boundFunction

    cron.start()


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

    task = _.extend _.pick(newTaskParams, 'title', 'description', 'assignedTo', 'taskList', 'reminder'),
      createdBy: Meteor.userId()
      dueBy: if newTaskParams.dueBy then moment(newTaskParams.dueBy).valueOf() else null

    populateAssignee newTaskParams, task

    console.log 'Got new task params...', task
    taskId = UserTasks.insert task

    task._id = taskId
    scheduleReminderForTask task

    taskId


  finishTask: (finishTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'

    task = UserTasks.findOne finishTaskParams._id
    unless task
      throw new Meteor.Error 401, 'Task not found'

    grp = null
    if task.assignedToGroup
      grp = UserGroups.findOne task.assignedToGroup, {fields: {members: 1, title: 1}}

      console.log 'grp: ', grp

      unless _.contains grp.members, user._id
        throw new Meteor.Error 403, "You are not member of group: " + grp.title
    else unless task.assignedToUser == user._id
      throw new Meteor.Error 403, "Can not finish other's tasks"

    console.log 'finishing task', task.title, ", by ", user._id

    if task.assignedToGroup
      UserTasks.update {_id: finishTaskParams._id}, {$addToSet: {finishedGroupMembers: user._id}}
    else
      UserTasks.update {_id: finishTaskParams._id}, {$set: {status: 'Finished', finishedBy: user._id}}

    if task.assignedToGroup
      task = UserTasks.findOne task._id
      if task.finishedGroupMembers.length >= grp.members.length
        UserTasks.update {_id: finishTaskParams._id}, {$set: {status: 'Finished'}}

    Reminders.update {
      taskId: finishTaskParams._id
      userId: user._id
    },
    {
      $set: {read: true}
    },
    {
      multi: true
    }



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


    task = _.extend _.pick(editTaskParams, 'title', 'description', 'assignedTo', 'reminder'),
      dueBy: moment(editTaskParams.dueBy).valueOf()

    populateAssignee editTaskParams, task
    UserTasks.update oldTask._id, {$set: task}
    oldTask._id