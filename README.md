# deluge-slack-bot

Semi-ready for release, you'll only need to use this version of the nodejs [deluge project](https://github.com/hannespetur/deluge) instead of the npm one.

## Install
### npm

	$ npm install deluge-slack-bot
	$ cd node_modules/deluge-slack-bot/

### Github
Clone the repo

	$ git clone https://github.com/hannespetur/deluge-slack-bot.git
	$ cd deluge-slack-bot
	$ npm install

nodejs

	$ sudo apt-get install nodejs

Due to a conflict with another package called "node" on Ubuntu systems you may need to run the following commands afterwards to make sure node will refer to nodejs

	$ cd /usr/local/bin; sudo ln -s /usr/bin/nodejs node

## Usage 
### NodeJS
Insert your token into a token.txt file (in same directory the index file is in) or into the script. You can create a slack bot here: [https://my.slack.com/services/new/bot](https://my.slack.com/services/new/bot) and after the creating the bot you will get the token. If you have coffee in your path you can run the bot using

	$ node index.js

### Coffeescript
If you installed from Github you'll have the coffeescript files instead of NodeJS files. You can run the script using:

	$ node_modules/coffee-script/bin/coffee index.coffee

or simply

	$ coffee index.coffee

if you have "coffee" globally installed.

## Slack
The bot can be on any channel you invite him to. He can currently only add torrents, let you know when a torrent was added (from any source), and let you know when a torrent completes. To add torrents you can use the "deluge add" command, e.g.

	deluge add http://www.some-website.com/id/name.torrent

The bot will get the torrent file (using cookies if you defined some), and add the torrent into the deluge web ui.

## Notes
* Make sure deluge web ui can have write access on dlAdded.log and dlComplete.log. 
* If you need to use cookies (e.g. to download torrents from private trackers), add a cookies.json using the format:
```
{
	"http://example.org/": "uid=1234;pass=xxxx;",
	"http://www.example.org/": "uid=1234;pass=xxxx;",
	"https://www.awesome-site.com/": "h_sl=aaaa;h_sp=bbbb;h_su=cccc;"
}
```
	

# License
(MIT license)