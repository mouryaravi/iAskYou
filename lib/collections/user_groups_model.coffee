@UserGroups = new Meteor.Collection 'userGroups',
  schema: new SimpleSchema {

    name:
      type: String
      label: 'Name of Group'
      max: 200

    description:
      type: String
      label: 'Description'
      max: 1024

    owner:
      type: String
      label: 'Group Owner'
      denyUpdate: true
      autoValue: ()->
        if @isInsert then Meteor.userId()
        else if @isUpsert then {$setOnInsert: Meteor.userId()}

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
        if @isInsert then new Date()
      optional: true

  }

Meteor.methods
  newGroup: (newGroupParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating a group'
    unless newGroupParams.name
      throw new Meteor.Error 422, 'Please fill in group name'

    group = _.extend _.pick(newGroupParams, 'name', 'description')

    groupId = UserGroups.insert group
