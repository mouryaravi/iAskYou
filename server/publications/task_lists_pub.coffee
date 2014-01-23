Meteor.publish 'taskLists', ()->
  TaskLists.find()