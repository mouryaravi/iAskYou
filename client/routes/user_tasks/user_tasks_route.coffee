Router.map () ->
  @route 'userTasksList', 
    path: '/'
    waitOn: ()->
      [
        Meteor.subscribe 'userTasks'
        Meteor.subscribe 'users'
      ]
    loginRequired: 'entrySignIn'

  @route 'userTaskPage',
    path: '/task/:_id'
    data: ()->
      UserTasks.findOne this.params._id
    waitOn: ()->
      [
        Meteor.subscribe 'userTasks'
        Meteor.subscribe 'users'
      ]
    loginRequired: 'entrySignIn'

  @route 'newTask',
    path: '/newTask'
    waitOn: ()->
      [
        Meteor.subscribe 'userTasks'
        Meteor.subscribe 'userGroups'
        Meteor.subscribe 'users'
      ]
    loginRequired: 'entrySignIn'

  @route 'userCreatedTaskItem',
    path: '/task/:id'
    data: ()->
      UserTasks.findOne this.params._id
    waitOn: ()->
      [
        Meteor.subscribe 'userTasks'
        Meteor.subscribe 'users'
      ]
    loginRequired: 'entrySignIn'

