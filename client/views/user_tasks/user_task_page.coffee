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