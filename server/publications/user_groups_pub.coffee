Meteor.publish 'userGroups', ()->
  UserGroups.find
    $or:
      [
        {createdBy: @userId}
        {members: @userId}
        {type: 'public'}
      ]