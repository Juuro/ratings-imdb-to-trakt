This script imports [IMDb](http://www.imdb.com) ratings to [trakt.tv](http://trakt.tv).

##Requirements:
[Ruby](http://www.ruby-doc.org) with the following gems:
* pp
* [curb-fu](http://rubygems.org/gems/curb-fu)
* [json](http://rubygems.org/gems/json)
* csv

You need accounts at IMDb and trakt.tv, of course.

##Usage:
	ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id

##Usage as cron:
Crontab doesn't load your environment files by default. So you have to load it first.

	source /path/to/your/environment/files; ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id

You can find you environment files by running:

	rvm env --path -- ruby-version[@gemset-name]

Assuming the the project ruby@gmeset is 1.9.2-p290@projectX then calling:

	rvm env --path -- 1.9.2-p290@projectX

will return:

	/Users/juuro/.rvm/environments/ruby-1.9.2-p290

So your command for cron would be:

	source /Users/juuro/.rvm/environments/ruby-1.9.2-p290; ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id