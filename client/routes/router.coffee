Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ()->
    Meteor.subscribe 'userTasks'
