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
      task = UserTasks.findOne @_id, {fields: {finishedGroupMembers: 1}}
      if task and task.finishedGroupMembers
        task.finishedGroupMembers.length || 0
      else
        0

  totalMembersCount: ()->
    if @assignedToGroup
      grp = UserGroups.findOne _id: @assignedToGroup, {fields: {members: 1}}
      if grp then grp.members.length || 0

  ownThisGroupTask: ()->
    if @assignedToGroup
      grp = UserGroups.findOne _id: @assignedToGroup, {fields: {createdBy: 1}}
      console.log 'group - ', grp
      if grp then grp.createdBy == Meteor.userId()

  isFinished: ()->
    @status == 'Finished'

Template.userCreatedTaskItem.events
  'click .taskReminder': (event)->
    addReminderToTask @
