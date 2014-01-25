@UserGroups = new Meteor.Collection 'userGroups',
  schema: new SimpleSchema {

    title:
      type: String
      label: 'Title of Group'
      max: 200

    description:
      type: String
      label: 'Description'
      max: 1024
      optional: true

    type:
      type: String
      label: 'Group Type'
      max: 20


    createdBy:
      type: String
      label: 'Group Owner'
      denyUpdate: true
      autoValue: ()->
        if @isInsert then Meteor.userId()
        else if @isUpsert then {$setOnInsert: Meteor.userId()}

    members:
      type: [String]
      label: 'Group Members'
      optional: true

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
        if @isInsert then new Date()
      optional: true

  }

Meteor.methods
  newGroup: (newGroupParams)->
    user = Meteor.user()
    unless user
      throw new Meteor.Error 401, 'Please login before creating a group'
    unless newGroupParams.title
      throw new Meteor.Error 422, 'Please fill in group title'

    group = _.extend _.pick(newGroupParams, 'title', 'description', 'members', 'type'),
      createdBy: user._id

    console.log 'creating group', group
    groupId = UserGroups.insert group
