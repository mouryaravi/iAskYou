Meteor.publish 'userTasks', ->
  UserTasks.find()