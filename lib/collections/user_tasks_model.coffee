@UserTasks = new Meteor.Collection 'userTasks',
  schema: new SimpleSchema {

  title:
    type: String
    label: 'Task Title'
    max: 200

  description:
    type: String
    label: 'Task Description'
    max: 2048

  createdBy:
    type: String
    label: 'Task Reporter'
    denyUpdate: true
    autoValue: ()->
      if @isInsert then this.userId
      else if @isUpsert then {$setOnInsert: this.userId}

  assignedTo:
    type: String
    label: 'Assignee'
    max: 200

  createdAt:
    type: Date
    label: 'Created Time'
    denyUpdate: true
    autoValue: ()->
      if @isInsert then new Date()
      else if @isUpsert then {$setOnInsert: new Date()}
      else this.unset()
  isGroup:
    type: Boolean
    label: 'Is this task for group'

  isUser:
    type: Boolean
    label: "Is this task for user"

  updatedAt:
    type: Date
    label: 'Last Updated Time'
    autoValue: ()->
      if @isUpdate then new Date()
      else if @isInsert then new Date()
    optional: true
  }

Meteor.methods
  newTask: (newTaskParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating task'
    unless newTaskParams.title
      throw new Meteor.Error 422, 'Please fill in task title'
    unless newTaskParams.assignedTo
      throw new Meteor.Error 422, 'Please fill in assignee'


    task = _.extend _.pick(newTaskParams, 'title', 'description', 'assignedTo'),
      createdBy: Meteor.userId()
      isUser: /user:/.test newTaskParams.assignedTo
      isGroup: /group:/.test newTaskParams.assignedTo

    task.assignedTo = task.assignedTo.replace /.*:/, ''
    taskId = UserTasks.insert task
