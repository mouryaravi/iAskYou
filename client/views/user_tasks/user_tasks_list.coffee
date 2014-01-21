assignedToMeFilter = assignedTo: Meteor.userId()
createdByMeFilter = createdBy: Meteor.userId()
notAssignedToMeFilter = {assignedTo: {$nin: [Meteor.userId()]}}
todayDate = moment(moment().format('YYYY-MM-DD')).valueOf()
tomorrowDate = moment(moment().add('days', 1).format('YYYY-MM-DD')).valueOf()
dueTodayFilter =  {dueBy: {'$gte': todayDate, '$lt': tomorrowDate}}

Template.userTasksList.helpers
  tasksAssignedToMe: ()->
    status = Session.get('myTasksSelectedCategory')||'Open'
    allFilters = [assignedToMeFilter]
    if status == 'DueToday'
      status = 'Open'
      allFilters.push dueTodayFilter

    allFilters.push status: status
    filter = {$and : allFilters}
    sortFilter = {sort: {dueBy: 1}}
    UserTasks.find filter, sortFilter


  myActiveTasksCount: ()->
    UserTasks.find( {$and : [assignedToMeFilter, {status: 'Open'}]} ).count()
  myFinishedTasksCount: ()->
    UserTasks.find( {$and : [assignedToMeFilter, {status: 'Finished'}]} ).count()

  myActiveTodaysTasksCount: ()->
    UserTasks.find( {$and : [assignedToMeFilter, {status: 'Open'}, dueTodayFilter]} ).count()


  myTasksHeading: ()->
    cat = Session.get('myTasksSelectedCategory') || 'Open'
    if cat == 'Open' then 'Due Tasks'
    else if cat == 'Finished' then 'Finished Tasks'
    else if cat == 'DueToday' then 'Tasks Due Today'


  tasksCreatedByMe: ()->
    UserTasks.find {$and : [createdByMeFilter, notAssignedToMeFilter, {status: Session.get('othersTasksSelectedCategory')||'Open'} ]}, {sort: {createdAt: -1}}

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