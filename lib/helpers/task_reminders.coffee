getTotalReminderCount = (userId, taskId)->
  Reminders.find(
    taskId: taskId
    userId: userId
    read: false
  ).count()

@addReminderToTask = (task, cron)->
  console.log 'adding reminder to task...', task.title, 'status: ', task.status

  totalCount = 0
  if task.assignedToUser
    totalCount = getTotalReminderCount(task.assignedToUser, task._id)

  if task.status == 'Finished' or totalCount >= 5
    console.log 'Finishing task. No more reminders!, total: ', totalCount
    if cron
      cron.stop()
    return


  reminders = []
  reminderTemplate =
    taskId: task._id
    remindedBy: task.createdBy
    userId: task.assignedToUser

  if task.assignedToGroup
    taskGroup = UserGroups.findOne(
      {_id: task.assignedToGroup}, {fields: {members: 1}})
    membersToFinish = _.difference taskGroup.members, task.finishedGroupMembers
    console.log 'reminding...', membersToFinish
    _.each membersToFinish, (member)->
      reminders.push _.extend _.pick(reminderTemplate, 'taskId', 'remindedBy'),
        userId: member
  else if task.assignedToUser
    reminders.push reminderTemplate

  if reminders.length == 0
    console.log 'Finished task. Stopping reminders',
    if cron
      cron.stop()

  _.each reminders, (reminder)->
    totalCount = getTotalReminderCount reminder.userId, reminder.taskId
    if totalCount < 5
      Reminders.insert reminder
