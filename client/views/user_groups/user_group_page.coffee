todayDate = moment(moment().format('YYYY-MM-DD')).valueOf()
tomorrowDate = moment(moment().add('days', 1).format('YYYY-MM-DD')).valueOf()

dueTodayFilter =  {dueBy: {'$gte': todayDate, '$lt': tomorrowDate}}

groupTasksFilter = (grpId, status)->
  assignedToGroup: grpId
  createdBy: Meteor.userId()
  status: status

Template.userGroupPage.helpers

  groupTasks: ()->
    groupId = @_id
    status = Session.get('tasksSelectedCategory') || 'Open'
    filter =
      assignedToGroup: groupId
      createdBy: Meteor.userId()

    if status == 'DueToday'
      status = 'Open'
      filter.dueBy = dueTodayFilter.dueBy

    filter.status = status

    console.log 'filter, ', filter
    UserTasks.find filter

  openTasksCount: ()->
    UserTasks.find(groupTasksFilter(@_id, 'Open')).count()
  finishedTasksCount: ()->
    UserTasks.find(groupTasksFilter(@_id, 'Finished')).count()
  openTasksDueToday: ()->
    filter = groupTasksFilter(@_id, 'Open')
    filter.dueBy = dueTodayFilter.dueBy
    UserTasks.find(filter).count()


  tasksHeading: ()->
    cat = Session.get('tasksSelectedCategory') || 'Open'
    if cat == 'Open' then 'Due Tasks in Group'
    else if cat == 'Finished' then 'Finished Tasks'
    else if cat == 'DueToday' then 'Tasks Due Today'


Template.userGroupPage.events
  'click .openTasks': (event)->
    event.preventDefault()
    Session.set('tasksSelectedCategory', 'Open')

  'click .finishedTasks': (event)->
    event.preventDefault()
    Session.set('tasksSelectedCategory', 'Finished')

  'click .openTasksDueToday': (event)->
    event.preventDefault()
    Session.set('tasksSelectedCategory', 'DueToday')
