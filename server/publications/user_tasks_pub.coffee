Meteor.publish 'userTasks', ()->
  userGroups = UserGroups.find(
    $or:
      [
        {createdBy: @userId}
        {members: @userId}
        {type: 'public'}
      ]
  ).fetch()

  myGroupIds = []
  _.each userGroups, (grp)->
    myGroupIds.push grp._id

  UserTasks.find({$or: [{assignedToUser: @userId}, {assignedToGroup: {$in: myGroupIds}} , {createdBy: @userId}]})