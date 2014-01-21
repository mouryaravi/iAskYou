Template.userTaskEdit.events
  'submit form': (event) ->
    event.preventDefault()

    task =
      assignedTo: $(event.target).find('[name=assignedTo]').val(),
      title: $(event.target).find('[name=title]').val(),
      description: $(event.target).find('[name=description]').val()
      dueBy: $(event.target).find('[name=dueBy]').val()
      _id: this._id

    task.dueBy = moment(moment(task.dueBy).format('YYYY-MM-DD')).add('hours', 23).add('minutes', 59).valueOf()
    Meteor.call 'editUserTask', task, (err, id)->
      if err
        throw new Errors.throw(err.reason)
      else
        Router.go 'userTasksList'


Template.userTaskEdit.helpers
  connections: ()->
    Meteor.users.find({})

  groups: ()->
    UserGroups.find({})

  dueByDate: ()->
    moment(this.dueBy).format('MM/DD/YYYY')


Template.userTaskEdit.rendered = ()->
  $('.datepicker').datepicker({
    format: 'mm/dd/yyyy'
    autoclose: true
    todayHighlight: true
  })
