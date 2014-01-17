Router.map ()->
  @route 'newGroup',
    path: '/newGroup'
    loginRequired: 'entrySignIn'

  @route 'userGroups',
    path: '/groups'
    waitOn: ()->
      Meteor.subscribe 'userGroups'
    loginRequired: 'entrySignIn'

  @route 'userGroupPage',
    path: '/group/:_id'
    data: ()->
      UserGroups.findOne this.params._id
    waitOn: ()->
      Meteor.subscribe 'userTasks'
    loginRequired: 'entrySignIn'

