myGroupIds = ()->
  grps = UserGroups.find(
    {members: Meteor.userId()}
    {fields: {_id: 1}}
  ).fetch()

  ids = []
  _.each grps, (grp)->
    ids.push grp._id
  ids

assignedToMeFilter = ()->
  $or: [
    {assignedToUser: Meteor.userId()}
    {assignedToGroup: {$in: myGroupIds()}}
  ]


assignedToMeFilterWithStatus = (status)->
  filter = assignedToMeFilter()
  filter.status = status
  filter

assignedToMeFinishedFilter = ()->
  $or: [
    {$and: [{assignedToUser: {$exists: true}}, {status: 'Finished'}]}
    {$and: [{assignedToGroup: {$exists: true}}, {finishedGroupMembers: Meteor.userId()}]}
  ]

tasksAssignedToMeFilter = (status)->
  status = status ||  Session.get('myTasksSelectedCategory') || 'Open'
  allFilters = assignedToMeFilter()
  allFilters.status = status

  if status == 'DueToday'
    allFilters.status = 'Open'
    allFilters.dueBy = dueTodayFilter.dueBy
  else if status == 'Finished'
    delete allFilters.status
    allFilters = assignedToMeFinishedFilter()

  allFilters

createdByMeFilter = createdBy: Meteor.userId()
notAssignedToMeFilter = {assignedToUser: {$nin: [Meteor.userId()]}}
todayDate = moment(moment().format('YYYY-MM-DD')).valueOf()
tomorrowDate = moment(moment().add('days', 1).format('YYYY-MM-DD')).valueOf()
dueTodayFilter =  {dueBy: {'$gte': todayDate, '$lt': tomorrowDate}}

Template.userTasksList.helpers

  tasksAssignedToMe: ()->
    sortFilter = {sort: {dueBy: 1}}
    UserTasks.find tasksAssignedToMeFilter(), sortFilter

  myActiveTasksCount: ()->
    UserTasks.find(tasksAssignedToMeFilter('Open')).count()
  myFinishedTasksCount: ()->
    UserTasks.find(tasksAssignedToMeFilter('Finished') ).count()

  myActiveTodaysTasksCount: ()->
    UserTasks.find( {$and : [tasksAssignedToMeFilter('Open'), dueTodayFilter]} ).count()

  myTasksHeading: ()->
    cat = Session.get('myTasksSelectedCategory') || 'Open'
    if cat == 'Open' then 'Due Tasks'
    else if cat == 'Finished' then 'Finished Tasks'
    else if cat == 'DueToday' then 'Tasks Due Today'


  tasksCreatedByMe: ()->
    status = Session.get('othersTasksSelectedCategory')||'Open'
    allFilters = [notAssignedToMeFilter, createdByMeFilter]
    if status == 'DueToday'
      status = 'Open'
      allFilters.push dueTodayFilter

    allFilters.push status: status
    filter = {$and : allFilters}
    sortFilter = {sort: {dueBy: 1}}
    UserTasks.find filter, sortFilter

  othersActiveTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Open'}]} ).count()
  othersFinishedTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Finished'}]} ).count()
  othersActiveTodaysTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Open'}, dueTodayFilter]} ).count()

  othersTasksHeading: ()->
    cat = Session.get('othersTasksSelectedCategory') || 'Open'
    if cat == 'Open' then 'You are still waiting for'
    else if cat == 'Finished' then 'Your peers finished'
    else if cat == 'DueToday' then 'Tasks Due Today'


Template.userTasksList.events
  'click .myActiveTasks': (event)->
    event.preventDefault()
    Session.set('myTasksSelectedCategory', 'Open')

  'click .myFinishedTasks': (event)->
    event.preventDefault()
    Session.set('myTasksSelectedCategory', 'Finished')

  'click .tasksDueToday': (event)->
    event.preventDefault()
    Session.set('myTasksSelectedCategory', 'DueToday')

  'click .othersActiveTasks': (event)->
    event.preventDefault()
    Session.set('othersTasksSelectedCategory', 'Open')

  'click .othersFinishedTasks': (event)->
    event.preventDefault()
    Session.set('othersTasksSelectedCategory', 'Finished')

  'click .othersTasksDueToday': (event)->
    event.preventDefault()
    Session.set('othersTasksSelectedCategory', 'DueToday')