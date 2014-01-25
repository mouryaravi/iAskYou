@TaskLists = new Meteor.Collection 'tasklists',
  schema: new SimpleSchema {

    title:
      type: String
      label: 'TaskList Title'
      max: 200

    description:
      type: String
      label: 'TaskList Description'
      max: 2048
      optional: true

    createdBy:
      type: String
      label: 'TaskList Reporter'
      denyUpdate: true
      autoValue: ()->
        if @isInsert then this.userId
        else if @isUpsert then {$setOnInsert: this.userId}

    dueBy:
      type: Number
      label: 'Due by'
      optional: true

    status:
      type: String
      label: 'TaskList status'
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

    lastUpdatedAt:
      type: Date
      label: 'Last Updated Time'
      autoValue: ()->
        if @isUpdate then new Date()
        else if @isInsert then new Date()
      optional: true
  }
