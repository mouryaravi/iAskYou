if UserTasks.find().count() == 0
  UserTasks.insert
    task: 'Finish Reading Meteor'
    description: 'This framework looks great. Take a look at it.'
    url: 'http://meteor.com'
    postedBy: 'ravi'

  UserTasks.insert
    task: 'Finish Prototype of YouAskYouGet'
    description: 'We need to show a prototype of this by Monday. Please work on it'
    postedBy: 'ravi'

