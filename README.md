# deluge-slack-bot

Semi-ready for release, you'll only need to use this version of the nodejs [deluge project](https://github.com/hannespetur/deluge) instead of the npm one.

## Preliminaries (Ubuntu)
Install git and clone the repo

	$ sudo apt-get install git
	$ git clone https://github.com/hannespetur/deluge-slack-bot.git

npm package manager

	$ sudo apt-get install npm

nodejs

	$ sudo apt-get install nodejs

Due to a conflict with another package called "node" you will need to run the following commands afterwards to make sure node will refer to nodejs

	$ cd /usr/local/bin; sudo ln -s /usr/bin/nodejs node

Insert you token into a token.txt file or into the script (line 14). You can create a slack bot here: [https://my.slack.com/services/new/bot](https://my.slack.com/services/new/bot) and after the creation you will get the token.

## Run the bot directly with coffeescript
	$ sudo npm install coffee-script
	$ sudo npm install slack-client
	$ sudo npm install chokidar
	$ sudo npm install deluge

If you have coffee in your path then use

	$ coffee deluge.coffee

if you don't you can use

	$ node_modules/coffee-script/bin/coffee deluge.coffee

## Run the bot with nodejs
	$ sudo npm install coffee-script
	$ sudo npm install slack-client
	$ sudo npm install chokidar
	$ coffee -c deluge.coffee
	$ node deluge.js

or (if you don't have coffee in your path)

	$ node_modules/coffee-script/bin/coffee -c deluge.coffee
	$ node deluge.js

# Todo
* Create a install script.

# Notes
Make sure deluge can have write access on dlAdded.log and dlComplete.log.