Router.configure
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: ()->
    [
      Meteor.subscribe 'userTasks'
      Meteor.subscribe 'userGroups'
      Meteor.subscribe 'users'
      Meteor.subscribe 'reminders'
      Meteor.subscribe 'taskLists'
    ]
