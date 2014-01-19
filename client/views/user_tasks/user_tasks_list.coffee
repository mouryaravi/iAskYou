assignedToMeFilter = assignedTo: Meteor.userId()
createdByMeFilter = createdBy: Meteor.userId()
notAssignedToMeFilter = {assignedTo: {$nin: [Meteor.userId()]}}

Template.userTasksList.helpers
  tasksAssignedToMe: ()->
    filter = {$and : [assignedToMeFilter, {status: Session.get('myTasksSelectedCategory')||'Open'}]}
    sortFilter = {sort: {createdAt: -1}}
    UserTasks.find filter, sortFilter


  myActiveTasksCount: ()->
    UserTasks.find( {$and : [assignedToMeFilter, {status: 'Open'}]} ).count()
  myFinishedTasksCount: ()->
    UserTasks.find( {$and : [assignedToMeFilter, {status: 'Finished'}]} ).count()

  myTasksHeading: ()->
    cat = Session.get('myTasksSelectedCategory') || 'Open'
    if cat == 'Open' then 'You still need to finish'
    else if cat == 'Finished' then 'You finished'


  tasksCreatedByMe: ()->
    UserTasks.find {$and : [createdByMeFilter, notAssignedToMeFilter, {status: Session.get('othersTasksSelectedCategory')||'Open'} ]}, {sort: {createdAt: -1}}

  othersActiveTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Open'}]} ).count()
  othersFinishedTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Finished'}]} ).count()

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

  'click .othersActiveTasks': (event)->
    event.preventDefault()
    Session.set('othersTasksSelectedCategory', 'Open')

  'click .othersFinishedTasks': (event)->
    event.preventDefault()
    Session.set('othersTasksSelectedCategory', 'Finished')