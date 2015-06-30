# Description:
#   Advanced Natural Language Reminder
#
# Configuration:
#   HUBOT_REMIND_KEY
#
# Commands:
#   hubot remind (me) <note> - Creates a new reminder using <note>
#   hubot remind cancel - Cancels the reminder operation
#
# Author:
#   MrSaints
#
# Notes:
#   "tomorrow" doesn't work between 12-4AM because
#   the developer of `chrono-node` lives in a strange planet

chrono = require "chrono-node"
moment = require "moment"

HUBOT_REMIND_KEY = process.env.HUBOT_REMIND_KEY or "_remind"

class Reminder
    constructor: (@callback) ->
        @pending = []

    addPending: (user, message) ->
        reminder = @getPending user
        return [false, reminder] if reminder isnt false
        payload = [user, message]
        @pending.push payload
        [true, payload]

    cancelPending: (user) ->
        if reminder = @getPending user
            console.debug "hubot-remind-advanced: Reminder cancelled."
            @pending.splice @pending.indexOf(reminder), 1
            return true
        false

    getPending: (user) ->
        for reminder, index in @pending
            return reminder if reminder[0].id is user.id
        false

    complete: (user, executionDate) ->
        if reminder = @getPending user
            console.debug "hubot-remind-advanced: Reminder created."
            @addCron reminder[0], reminder[1], executionDate
            @pending.splice @pending.indexOf(reminder), 1
            return [reminder[0], reminder[1], executionDate]
        false

    addCron: (user, message, executionDate) ->
        console.debug "hubot-remind-advanced: Adding cron job."
        setTimeout =>
            @callback user, message
        , moment(executionDate).diff()


module.exports = (robot) ->
    BrainReminders = ->
        robot.brain.data[HUBOT_REMIND_KEY] or= []

    Reminder = new Reminder (user, message, executionDate) ->
        message = "Reminder for #{user.name}: #{message}"
        robot.send user, message
        old = [user, message, executionDate]
        BrainReminders().splice BrainReminders().indexOf old, 1

    robot.respond /remind cancel/i, (res) ->
        if Reminder.cancelPending res.message.user
            res.reply "Your reminder operation has been cancelled."
        else
            res.reply "You have no reminders pending creation."
        res.message.done = true

    robot.respond /remind( me)? (.+)/i, (res) ->
        [status, reminder] = Reminder.addPending res.message.user, res.match[2]
        if status isnt false
            res.reply "When should I remind you?"
        else
            res.reply "You have a reminder pending creation. When should I remind you \"#{reminder[1]}\" ?"
        res.message.done = true

    robot.hear /(.+)/i, (res) ->
        return unless Reminder.pending.length isnt 0

        chronoDate = chrono.parse res.match[1]
        return unless chronoDate.length isnt 0 # Should probably handle this?

        executionDate = chronoDate[0].start.date()
        if reminder = Reminder.complete res.message.user, executionDate
            humanized = moment(executionDate).fromNow()
            res.reply "Reminder added. I'll remind you #{humanized}."

            BrainReminders().push reminder
            robot.brain.save()

    robot.brain.on "loaded", ->
        robot.logger.info "hubot-remind-advanced: Loading reminders from brain."
        for reminder, index in BrainReminders()
            Reminder.addCron reminder[0], reminder[1], reminder[2]