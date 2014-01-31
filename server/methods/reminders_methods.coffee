getEmailHtml = (task)->
  descHtml = '<h3>' + task.title + '</h3>'
  descHtml += '<p>' + task.description + '</p>'
  descHtml += '<br /><br />'
  descHtml += "Click <a href='/task/" + task._id + "'>Here</a>"


getEmailText = (task)->
  descText = "Title: " + task.title
  descText += '\n\nDescription: ' + task.description
  descText += '\n\nClick here: /task/' + task._id


Meteor.methods
  sendEmailReminderForTask: (task)->

    console.log @

    currentLoggedInUser = Meteor.user()
    unless currentLoggedInUser
      throw new Meteor.Error 401, 'Please login before sending email'

    toUsers = []
    if task.assignedToGroup
      taskGroup = UserGroups.findOne(
        {_id: task.assignedToGroup}, {fields: {members: 1}})
      membersToFinish = _.difference taskGroup.members, task.finishedGroupMembers
      console.log 'sending email to...', membersToFinish, ' for task, ', task.title
      _.each membersToFinish, (member)->
        user = Meteor.users.findOne member
        toUsers.push user.services.google.email

    else if task.assignedToUser
      user = Meteor.users.findOne task.assignedToUser
      toUsers.push user.services.google.email

    _.each toUsers, (toUser)->
      Email.send
        from: currentLoggedInUser.services.google.email
        to: toUser
        replyTo: currentLoggedInUser.services.google.email
        subject: 'Reminder for: ' + task.title
        text: getEmailText task
        html: getEmailHtml task


