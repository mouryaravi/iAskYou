Router.map () ->
  @route 'userTasksList', 
    path: '/'
    loginRequired: 'entrySignIn'

  @route 'userTaskPage',
    path: '/task/:_id'
    data: ()->
      UserTasks.findOne this.params._id
    loginRequired: 'entrySignIn'

  @route 'newTask',
    path: '/newTask'
    waitOn: ()->
      [
        Meteor.subscribe 'userGroups'
      ]
    loginRequired: 'entrySignIn'

  @route 'userCreatedTaskItem',
    path: '/task/:id'
    data: ()->
      UserTasks.findOne this.params._id
    loginRequired: 'entrySignIn'

