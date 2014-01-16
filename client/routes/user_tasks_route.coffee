Router.map () ->
  @route 'userTasksList', 
    path: '/'
    waitOn: ()->
      Meteor.subscribe 'userTasks'

  @route 'userTaskPage',
    path: '/task/:_id'
    data: ()->
      UserTasks.findOne this.params._id
    waitOn: ()->
      Meteor.subscribe 'userTasks'

  @route 'newTask',
    path: '/newTask'
    waitOn: ()->
      [
        Meteor.subscribe 'userTasks'
        Meteor.subscribe 'userGroups'
        Meteor.subscribe 'users'
      ]


  Router.before requireLogin,
    only: ['newTask', 'userTasksList', 'userTaskPage']
