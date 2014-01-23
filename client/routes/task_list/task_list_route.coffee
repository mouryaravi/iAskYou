Router.map () ->
  @route 'taskListPage',
    path: '/taskList/:_id'
    data: ()->
      TaskLists.findOne this.params._id
    loginRequired: 'entrySignIn'

  @route 'newTaskList',
    path: 'newTaskList'
    waitOn: ()->
      [
        Meteor.subscribe 'userGroups'
      ]
    loginRequired: 'entrySignIn'


  @route 'taskListEdit',
    path: '/taskList/:_id/edit'
    data: ()->
      TaskLists.findOne this.params._id
    loginRequired: 'entrySignIn'


  @route 'taskLists',
    path: '/taskLists'
    loginRequired: 'entrySignIn'