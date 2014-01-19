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
    optional: true

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

  finishedBy:
    type: String
    label: 'Finshed By'
    optional: true

  dueBy:
    type: Date
    label: 'Due by'
    optional: true

  status:
    type: String
    label: 'Task status'
    max: 32
    autoValue: ()->
      if @isInsert then 'Open'
      else if @isUpsert then {$setOnInsert: 'Open'}

  createdAt:
    type: Date
    label: 'Created Time'
    denyUpdate: true
    autoValue: ()->
      if @isInsert then new Date()
      else if @isUpsert then {$setOnInsert: new Date()}
      else this.unset()

  updatedAt:
    type: Date
    label: 'Last Updated Time'
    autoValue: ()->
      if @isUpdate then new Date()
      else if @isInsert then new Date()
    optional: true
  }


@Reminders.allow
  update: ()->
    true
  insert: ()->
    true