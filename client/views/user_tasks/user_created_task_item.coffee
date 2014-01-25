Template.userCreatedTaskItem.helpers
  assignedToUser: ()->
    if @assignedToUser
      Meteor.users.findOne @assignedToUser

  assignedToGroup: ()->
    if @assignedToGroup
      UserGroups.findOne @assignedToGroup

  dueByText: ()->
    moment(@dueBy).fromNow()

  finishedMembersCount: ()->
    if @assignedToGroup
      task = UserTasks.findOne assignedToGroup: @assignedToGroup, {fields: {finishedGroupMembers: 1}}
      if task and task.finishedGroupMembers then task.finishedGroupMembers.length else 0

  totalMembersCount: ()->
    if @assignedToGroup
      grp = UserGroups.findOne _id: @assignedToGroup, {fields: {members: 1}}
      if grp then grp.members.length || 0

  ownThisGroupTask: ()->
    if @assignedToGroup
      grp = UserGroups.findOne _id: @assignedToGroup, {fields: {createdBy: 1}}
      console.log 'group - ', grp
      if grp then grp.createdBy == Meteor.userId()

Template.userCreatedTaskItem.events
  'click .taskReminder': (event)->
    reminders = []
    reminderTemplate =
      taskId: @_id
      remindedBy: Meteor.userId()
      userId: @assignedToUser

    if @assignedToGroup
      taskGroup = UserGroups.findOne(
        {_id: @assignedToGroup}, {fields: {members: 1}})
      _.each taskGroup.members, (member)->
        reminders.push _.extend _.pick(reminderTemplate, 'taskId', 'remindedBy'),
          userId: member
    else if @assignedToUser
      reminders.push reminderTemplate

    _.each reminders, (reminder)->
      console.log 'Inserting reminder', reminder
      Reminders.insert reminder
