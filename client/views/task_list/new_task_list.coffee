Template.newTaskList.events

  'click .addNewTaskForm': (event)->
    event.preventDefault()

    taskItem = $('.newTaskList ul li:first').clone()
    taskItem
      .find('input[name=title]').val('')
      .find('textarea[name=description]').val('')
      .find('input[name=dueBy]').val('') #doesnt work

    $('.newTaskList ul').append(taskItem)
    taskItem.find('.datepicker').datepicker({
      format: 'mm/dd/yyyy'
      autoclose: true
      todayHighlight: true
    })

Template.newTaskList.events
  'click .submitTasks': (event)->
    event.preventDefault()

    tasks = []
    title = $('input[name=taskListTitle]').val()

    $('.newTaskList ul li').each (idx)->
      eachLi = $(@)
      taskItem =
        assignedTo: eachLi.find('[name=assignedTo]').val(),
        title: eachLi.find('[name=title]').val(),
        description: eachLi.find('[name=description]').val()
        dueBy: eachLi.find('[name=dueBy]').val()

      if taskItem.dueBy
        taskItem.dueBy = moment(moment(taskItem.dueBy).format('YYYY-MM-DD')).add('hours', 23).add('minutes', 59).valueOf()

      console.log taskItem
      tasks.push taskItem

    Meteor.call 'newTaskList', title, tasks, (err, result)->
      if err
        throw new Errors.throw(err.reason)
      else
        Router.go 'userTasksList'


Template.newTaskList.helpers
  connections: ()->
    Meteor.users.find({})

  groups: ()->
    UserGroups.find({})


Template.newTaskList.rendered = ()->
  $('.datepicker').datepicker({
    format: 'mm/dd/yyyy'
    autoclose: true
    todayHighlight: true
  })