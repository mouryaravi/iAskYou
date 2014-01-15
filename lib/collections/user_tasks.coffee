@UserTasks = new Meteor.Collection 'userTasks'

Meteor.methods
  newTask: (newTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless newTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless newTaskParams.username
      throw new Meteor.Error 422, 'Please fill in username'

    task = _.extend _.pick(newTaskParams, 'title', 'description', 'username'),
      postedBy: user.profile.name,
      createdAt: new Date().getTime()

    taskId = UserTasks.insert task
