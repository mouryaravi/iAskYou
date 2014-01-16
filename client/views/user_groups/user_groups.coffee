Template.userGroups.helpers
  groups: ()->
    UserGroups.find {}, {sort: {createdAt: -1}}
