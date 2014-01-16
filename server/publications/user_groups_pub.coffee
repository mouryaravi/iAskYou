Meteor.publish 'userGroups', ()->
  UserGroups.find({owner: this.userId})