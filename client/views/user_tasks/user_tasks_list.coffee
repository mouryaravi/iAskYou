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

  myTasksSelectedCategory: ()->
    Session.get('myTasksSelectedCategory') || 'Open'

  tasksCreatedByMe: ()->
    UserTasks.find {$and : [createdByMeFilter, notAssignedToMeFilter, {status: Session.get('othersTasksSelectedCategory')||'Open'} ]}, {sort: {createdAt: -1}}

  othersActiveTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Open'}]} ).count()
  othersFinishedTasksCount: ()->
    UserTasks.find( {$and : [createdByMeFilter, notAssignedToMeFilter, {status: 'Finished'}]} ).count()

  othersTasksSelectedCategory: ()->
    Session.get('othersTasksSelectedCategory') || 'Open'


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