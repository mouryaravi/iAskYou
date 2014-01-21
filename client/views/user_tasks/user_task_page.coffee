Template.userTaskPage.helpers
  createdByUser: ()->
    Meteor.users.findOne this.createdBy

  assignedToUser: ()->
    Meteor.users.findOne this.assignedTo

  dueByText: ()->
    moment(this.dueBy).fromNow()

  createdByText: ()->
    moment(this.createdAt).fromNow()

  taskCreatedByMe: ()->
    this.createdBy == Meteor.userId()
