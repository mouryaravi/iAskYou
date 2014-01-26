@addReminderToTask = (task, cron)->
  console.log 'adding reminder to task...', task.title, 'status: ', task.status
  if task.status == 'Finished'
    console.log 'Task Finished. No reminders!'
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

  _.each reminders, (reminder)->
    console.log 'Inserting reminder', reminder
    Reminders.insert reminder
