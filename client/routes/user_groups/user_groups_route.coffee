Router.map ()->
  @route 'newGroup',
    path: '/newGroup'
    loginRequired: 'entrySignIn'

  @route 'userGroups',
    path: '/groups'
    loginRequired: 'entrySignIn'

  @route 'userGroupPage',
    path: '/group/:_id'
    data: ()->
      UserGroups.findOne @params._id
    loginRequired: 'entrySignIn'

