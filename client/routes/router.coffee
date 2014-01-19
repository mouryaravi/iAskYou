Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ()->
    [
      Meteor.subscribe 'userTasks'
      Meteor.subscribe 'users'
      Meteor.subscribe 'reminders'
    ]
