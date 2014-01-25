@Reminders = new Meteor.Collection 'reminders',
  schema: new SimpleSchema {

    text:
      type: String
      label: 'Reminder Title'
      max: 200
      optional: true

    read:
      type: Boolean
      label: 'Is this reminder read?'
      autoValue: ()->
        if @isInsert then false

    taskId:
      type: String
      label: 'Task related to reminder'
      max: 200

    userId:
      type: String
      label: 'Whom to remind'
      max: 200
      denyUpdate: true

    remindedBy:
      type: String
      label: 'The user to remind'
      denyUpdate: true
      max: 200
      autoValue: ()->
        if @isInsert then this.userId
        else if @isUpsert then {$setOnInsert: this.userId}

    createdAt:
      type: Date
      label: 'Created Time'
      denyUpdate: true
      autoValue: ()->
        if @isInsert then new Date()
        else if @isUpsert then {$setOnInsert: new Date()}
        else this.unset()

    lastUpdatedAt:
      type: Date
      label: 'Last Updated Time'
      autoValue: ()->
        if @isUpdate then new Date()
        else if @isInsert then new Date()
      optional: true
  }
