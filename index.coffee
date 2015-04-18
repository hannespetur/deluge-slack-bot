chokidar = require 'chokidar'
fs = require 'fs'
deluge = require('deluge')('http://localhost:8112/json', 'deluge')
Slack = require 'slack-client'
path = require 'path'

# deluge.connect()
cookieFile = 'cookies.json'
cookies = {}
if fs.existsSync path.join(__dirname,cookieFile)
  cookies = JSON.parse(fs.readFileSync(path.join(__dirname,cookieFile)));
  deluge.setCookies(cookies, (err, result) -> 
    if err
      console.error err;
      return;
    )
else
  console.log "No "+cookieFile+" found! Using no cookies."

console.log "Using cookies:", cookies

tokenFile = path.join(__dirname,'token.txt')

token_fun = ->
  if fs.existsSync tokenFile
    token = fs.readFileSync tokenFile, 'utf-8', (err, token) ->
      if err
        console.error err;
        return;
      return token
    console.log "Using token from file:", token.replace(/\n$/, '')
    return token.replace(/\n$/, '')
  else
    # Add a bot at https://my.slack.com/services/new/bot and copy the token here or in a token.txt file.
    token = "<<Insert token here or in token.txt>>"
    console.log "Using token from script:", token
    return token

autoReconnect = true
autoMark = true
slack = new Slack(token_fun(), autoReconnect, autoMark)

slack.on 'open', ->
  channels = []
  groups = []
  unreads = slack.getUnreadCount()

  # Get all the channels that bot is a member of
  channels = (channel for id, channel of slack.channels when channel.is_member)

  # Get all groups that are open and not archived 
  groups = (group.name for id, group of slack.groups when group.is_open and not group.is_archived)

  # Log some information
  console.log "Welcome to Slack. You are @#{slack.self.name} of #{slack.team.name}"
  console.log 'As well as: ' + groups.join(', ')
  messages = if unreads is 1 then 'message' else 'messages'
  console.log "You have #{unreads} unread #{messages}"

  watcher_complete = chokidar.watch(path.join(__dirname,'watchme','dlComplete.log'),
    ignored: /[\/\\]\./
    persistent: true
    usePolling: true
    interval: 5000)

  watcher_complete.on('change', (fpath) ->
    console.log 'File', fpath, 'has been changed'
    fs.readFile fpath, 'utf-8', (err, data) ->
      if err
        throw err
      console.log 'The file now has:', data
      for channel in channels
        channel.send "Download complete: "+data.replace(/\n$/, '')
      return
    return
  )

  watch_added = chokidar.watch(path.join(__dirname,'watchme','dlAdded.log'),
    ignored: /[\/\\]\./
    persistent: true
    usePolling: true
    interval: 5000)

  watch_added.on('change', (fpath) ->
    console.log 'File', fpath, 'has been changed'
    fs.readFile fpath, 'utf-8', (err, data) ->
      if err
        throw err
      console.log 'The file now has:', data
      for channel in channels
        channel.send "New download: "+data.replace(/\n$/, '')
      return
    return
  )

slack.on 'message', (message) ->
  channel = slack.getChannelGroupOrDMByID(message.channel)
  user = slack.getUserByID(message.user)
  response = ''

  {type, ts, text} = message

  channelName = if channel?.is_channel then '#' else ''
  channelName = channelName + if channel then channel.name else 'UNKNOWN_CHANNEL'

  userName = if user?.name? then "@#{user.name}" else "UNKNOWN_USER"

  console.log """
    Received: #{type} #{channelName} #{userName} #{ts} "#{text}"
  """

  # Respond to messages with the reverse of the text received.
  if type is 'message' and text? and channel?
    String::startsWith ?= (s) -> @slice(0, s.length) == s
    String::endsWith   ?= (s) -> s == '' or @slice(-s.length) == s

    cmd_add = 'deluge add '

    if text.startsWith(cmd_add)
      url = text.split('')[cmd_add.length..-1].join('')
      if text.startsWith(cmd_add+'magnet:')
        console.log "Adding torrent with a magnet link: '"+url+"'"
      else if text.startsWith(cmd_add+'<http:')
        url = url[1..-2]
        console.log "Adding torrent with a http link: '"+url+"'"

      deluge.add(url,'~/delugeDownloads/', (error,result) -> 
        if error
          console.error error
          channel.send "Torrent with link: '"+url+"' could not be added!"
      )

slack.on 'error', (error) ->
  console.error "Error: #{error}"

slack.login()
