Template.userTaskPage.helpers
  createdByUser: ()->
    Meteor.users.findOne @createdBy

  assignedToUser: ()->
    if @assignedToUser
      Meteor.users.findOne @assignedToUser

  assignedToGroup: ()->
    if @assignedToGroup
      UserGroups.findOne @assignedToGroup

  dueByText: ()->
    moment(@dueBy).fromNow()

  createdByText: ()->
    moment(@createdAt).fromNow()

  taskCreatedByMe: ()->
    @createdBy == Meteor.userId()

  referencedInTaskList: ()->
    TaskLists.findOne @taskList, {fields: {title: 1}}

  ownThisGroup: ()->
    if @assignedToGroup
      grp = UserGroups.findOne _id: @assignedToGroup, {fields: {createdBy: 1}}
      if grp then grp.createdBy == Meteor.userId()
