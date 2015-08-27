# hubot-remind-advanced

[![Build Status](https://travis-ci.org/ClaudeBot/hubot-remind-advanced.svg)](https://travis-ci.org/ClaudeBot/hubot-remind-advanced)
[![devDependency Status](https://david-dm.org/ClaudeBot/hubot-remind-advanced/dev-status.svg)](https://david-dm.org/ClaudeBot/hubot-remind-advanced#info=devDependencies)

A Hubot script for creating quick reminders through [natural language](https://github.com/wanasit/chrono).

See [`src/remind.coffee`](src/remind.coffee) for full documentation.


## Installation via NPM

1. Install the __hubot-remind-advanced__ module as a Hubot dependency by running:

    ```
    npm install --save hubot-remind-advanced
    ```

2. Enable the module by adding the __hubot-remind-advanced__ entry to your `external-scripts.json` file:

    ```json
    [
        "hubot-remind-advanced"
    ]
    ```

3. Run your bot and see below for available config / commands


## Configuration

Variable | Default | Description
--- | --- | ---
`HUBOT_REMIND_KEY` | _remind | The unique key used for persistence (storing/retrieving reminders from memory)


## Commands

Command | Listener ID | Description
--- | --- | ---
hubot remind [me] `note` | `remind.new` | Creates a new reminder using `note`
hubot remind cancel | `remind.cancel` | Cancels the reminder operation
hubot remind [me] now | `remind.list` | Returns all your reminders
hubot remind clear | `remind.clear` | Clears all your reminders


## Sample Interaction

```
user1>> hubot remind me to go to sleep
hubot>> user1: When should I remind you?
user1>> in 1 hour
hubot>> user1: Reminder added. I'll remind you in an hour.
hubot>> Reminder for user1: to go to sleep
```
