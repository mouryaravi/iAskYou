Template.userTaskPage.helpers
  createdByUser: ()->
    Meteor.users.findOne @createdBy

  assignedToUser: ()->
    Meteor.users.findOne @assignedToUser

  dueByText: ()->
    moment(@dueBy).fromNow()

  createdByText: ()->
    moment(@createdAt).fromNow()

  taskCreatedByMe: ()->
    @createdBy == Meteor.userId()
