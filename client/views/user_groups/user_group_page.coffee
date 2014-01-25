todayDate = moment(moment().format('YYYY-MM-DD')).valueOf()
tomorrowDate = moment(moment().add('days', 1).format('YYYY-MM-DD')).valueOf()

dueTodayFilter =  {dueBy: {'$gte': todayDate, '$lt': tomorrowDate}}

Template.userGroupPage.helpers

  groupTasks: ()->
    groupId = @_id
    UserTasks.find({
      'assignedToGroup': groupId
      'createdBy': Meteor.userId()
    })

  openTasksCount: ()->
    UserTasks.find({assignedToGroup: @_id, status: 'Open'}).count()
  finishedTasksCount: ()->
    UserTasks.find({assignedToGroup: @_id, status: 'Finished'}).count()
  openTasksDueToday: ()->
    UserTasks.find(assignedToGroup: @_id, status: 'Finished', dueTodayFilter).count()

