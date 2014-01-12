Router.map () ->
  @route 'userTasksList', 
    path: '/'

  @route 'userTaskPage',
    path: '/task/:_id'
    data: ()->
      UserTasks.findOne this.params._id
