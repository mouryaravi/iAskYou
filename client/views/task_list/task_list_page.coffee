todayDate = moment(moment().format('YYYY-MM-DD')).valueOf()
tomorrowDate = moment(moment().add('days', 1).format('YYYY-MM-DD')).valueOf()

dueTodayFilter =  {dueBy: {'$gte': todayDate, '$lt': tomorrowDate}}

Template.taskListPage.helpers

  tasks: ()->
    taskListId = @_id
    UserTasks.find({
      'taskList': taskListId
      'createdBy': Meteor.userId()
    })


  openTasksCount: ()->
    UserTasks.find({taskList: @_id, status: 'Open'}).count()
  finishedTasksCount: ()->
    UserTasks.find({taskList: @_id, status: 'Finished'}).count()
  openTasksDueToday: ()->
    UserTasks.find(taskList: @_id, status: 'Finished', dueTodayFilter).count()
