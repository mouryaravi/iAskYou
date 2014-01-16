Router.map ()->
  @route 'newGroup',
    path: '/newGroup'

  @route 'userGroups',
    path: '/groups'
    waitOn: ()->
      Meteor.subscribe 'userGroups'

  @route 'userGroupPage',
    path: '/group/:_id'
    data: ()->
      UserGroups.findOne this.params._id
    waitOn: ()->
      Meteor.subscribe 'userTasks'

  Router.before requireLogin,
    only: ['newGroup', 'userGroups', 'userGroupPage']

