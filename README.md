# deluge-slack-bot

In development, not ready to use.

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

Insert you token into the script (line 5). You can add a bot here: [https://my.slack.com/services/new/bot](https://my.slack.com/services/new/bot) and get the token there.

## Run the bot directly with coffeescript
	npm install coffee-script
	npm install slack-client
	npm install chokidar
	node_modules/coffee-script/bin/coffee deluge.coffee 

## Run the bot with nodejs
	npm install coffee-script
	npm install slack-client
	npm install chokidar
	node_modules/coffee-script/bin/coffee -c deluge.coffee 
	node deluge.js

# Todo
* Create a install script.
* Allow users to add torrent to deluge (via link).
* Add an option to show when download starts.
* Add an option to check torrent status.
* Get token from another file not in this repo.
