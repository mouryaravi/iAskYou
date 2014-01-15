Router.map () ->
  @route 'userTasksList', 
    path: '/'

  @route 'userTaskPage',
    path: '/task/:_id'
    data: ()->
      UserTasks.findOne this.params._id

  @route 'newTask',
    path: '/newTask'


  requireLogin = ()->
    unless Meteor.user()
      if Meteor.loggingIn()
        @render @loadingTemplate
      else
        @render 'accessDenied'
      @stop()

  Router.before requireLogin,
    only: ['newTask', 'userTasksList', 'userTaskPage']
