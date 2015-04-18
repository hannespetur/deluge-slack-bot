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

	$ npm install

If you have coffee in your path then use

	$ coffee deluge.coffee

if you don't you can use

	$ node_modules/coffee-script/bin/coffee deluge.coffee

## Run the bot with nodejs

	$ npm install
	$ coffee -c deluge.coffee
	$ node deluge.js

or (if you don't have coffee in your path)

	$ node_modules/coffee-script/bin/coffee -c deluge.coffee
	$ node deluge.js

# Notes
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