Template.userCreatedTaskItem.helpers
  assignedToUser: ()->
    if @assignedToUser
      Meteor.users.findOne @assignedToUser

  assignedToGroup: ()->
    if @assignedToGroup
      UserGroups.findOne @assignedToGroup


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
