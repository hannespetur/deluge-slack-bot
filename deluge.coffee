Slack = require 'slack-client'
fs = require 'fs'
chokidar = require 'chokidar'

token = '<Your token here>' # Add a bot at https://my.slack.com/services/new/bot and copy the token here.
autoReconnect = true
autoMark = true

slack = new Slack(token, autoReconnect, autoMark)

slack.on 'open', ->
  channels = []
  groups = []
  unreads = slack.getUnreadCount()

  # Get all the channels that bot is a member of
  channels = (channel for id, channel of slack.channels when channel.is_member)

  # Get all groups that are open and not archived 
  groups = (group.name for id, group of slack.groups when group.is_open and not group.is_archived)

  console.log "Welcome to Slack. You are @#{slack.self.name} of #{slack.team.name}"
  console.log 'As well as: ' + groups.join(', ')

  messages = if unreads is 1 then 'message' else 'messages'

  console.log "You have #{unreads} unread #{messages}"

  watcher = chokidar.watch('deluge.log',
  ignored: /[\/\\]\./
  persistent: true)

  log = console.log.bind(console)
  watcher.on('add', (path) ->
    log 'File', path, 'has been added'
    return
  ).on('change', (path) ->
    log 'File', path, 'has been changed'
    fs.readFile './deluge.log', 'utf-8', (err, data) ->
      if err
        throw err
      console.log 'The file now has:', data
      for channel in channels
        channel.send "Torrent: "+data+" has successfully been downloaded on Deluge and after an automatic Plex rescan it will be available on the Plex server!"
      return
    return
  ).on('unlink', (path) ->
    log 'File', path, 'has been removed'
    return
  ).on('addDir', (path) ->
    log 'Directory', path, 'has been added'
    return
  ).on('unlinkDir', (path) ->
    log 'Directory', path, 'has been removed'
    return
  ).on('error', (error) ->
    log 'Error happened', error
    return
  ).on('ready', ->
    log 'Initial scan complete. Ready for changes.'
    return
  ).on 'raw', (event, path, details) ->
    log 'Raw event info:', event, path, details
    return


#slack.on 'message', (message) ->
#  channel = slack.getChannelGroupOrDMByID(message.channel)
#  console.log "Message:", message.channel
#  user = slack.getUserByID(message.user)
#  response = ''
#
#  {type, ts, text} = message
#
#  channelName = if channel?.is_channel then '#' else ''
#  channelName = channelName + if channel then channel.name else 'UNKNOWN_CHANNEL'
#
#  userName = if user?.name? then "@#{user.name}" else "UNKNOWN_USER"
#
#  console.log """
#    Received: #{type} #{channelName} #{userName} #{ts} "#{text}"
#  """
#
#  # Respond to messages with the reverse of the text received.
#  if type is 'message' and text? and channel?
#    response = text.split('').reverse().join('')
#    channel.send response
#    console.log """
#      @#{slack.self.name} responded with "#{response}"
#    """
#  else
#    #this one should probably be impossible, since we're in slack.on 'message' 
#    typeError = if type isnt 'message' then "unexpected type #{type}." else null
#    #Can happen on delete/edit/a few other events
#    textError = if not text? then 'text was undefined.' else null
#    #In theory some events could happen with no channel
#    channelError = if not channel? then 'channel was undefined.' else null
#
#    #Space delimited string of my errors
#    errors = [typeError, textError, channelError].filter((element) -> element isnt null).join ' '
#
#    console.log """
#      @#{slack.self.name} could not respond. #{errors}
#    """


slack.on 'error', (error) ->
  console.error "Error: #{error}"


slack.login()

