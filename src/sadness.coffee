# Description:
#   Days since the last time someone posted depressing shit in chat.
#
# Dependencies:
#   "moment": "2.0.x"
#
# Commands:
#   hubot sadness - See how long it's been since we've had depressing shit
#   hubot sadness reset - Reset the clock; someone posted something depressing.
#
# Author:
#   jonursenbach

moment = require 'moment'

getClock = (robot) ->
  last_sad = moment(robot.brain.data.sadness_counter);
  now = moment();

  days = now.diff(last_sad, 'days')
  hours = now.diff(last_sad, 'hours')
  minutes = now.diff(last_sad, 'minutes')
  seconds = now.diff(last_sad, 'seconds')

  if days == 0
    if hours == 0
      if minutes == 0
        card = seconds + ' second'
        if seconds > 1
          card += 's'
      else
        card = minutes + ' minute'
        if minutes > 1
          card += 's'
    else
      card = hours + ' hour'
      if hours > 1
        card += 's'
  else
    card = days + ' day'
    if days > 1
      card += 's'

  return card

module.exports = (robot) ->
  robot.brain.on 'loaded', =>
    robot.brain.data.sadness_counter ||= new Date().getTime()

  robot.respond /sadness( .*)?/i, (msg) ->
    if msg.match[1] and msg.match[1].trim() == 'reset'
      previousClock = getClock robot
      robot.brain.data.sadness_counter = new Date().getTime()

      sigh = [
        'Great job, everyone.',
        'Who wants to live on this planet anymore?'
        'You should be ashamed of yourselves.',
        ':('
      ]

      response = 'We managed to go ' + previousClock + ' without an incident. ';
      response += msg.random sigh
    else
      clock = getClock robot
      response = 'It has been ' + clock + ' since someone posted depressing shit in chat.'

    msg.send response
