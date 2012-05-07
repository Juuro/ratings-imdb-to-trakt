This script imports [IMDb](http://www.imdb.com) ratings to [trakt.tv](http://trakt.tv). It supports [advanced ratings](http://trakt.tv/api-docs/ratings).

If you unrate a movie on IMDb, the rating on trakt will be removed, too.

##Requirements:
[Ruby](http://www.ruby-doc.org) with the following gems:
* pp
* [curb-fu](http://rubygems.org/gems/curb-fu)
* [json](http://rubygems.org/gems/json)
* csv
* open-uri

You need accounts at IMDb and trakt.tv, of course.

You can grab your IMDb-ID from the URL if you visit [http://www.imdb.com/profile/lists](http://www.imdb.com/profile/lists), for example. It's the **ur00000000**-Part.
Your trakt API key is available at [http://trakt.tv/api-docs/authentication](http://trakt.tv/api-docs/authentication).
To hash your trakt password in SHA1 you can use this website: [http://jssha.sourceforge.net](http://jssha.sourceforge.net).

##Usage:
	ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id [nosocial]

If you use "nosocial" as fourth attribute, your ratings won't be send out as social updates to facebook, twitter, and tumblr. This is recommended for the initial ratings-import. The default setting is with social updates.

##Usage as cron:
[Cron](http://en.wikipedia.org/wiki/Cron) doesn't load your environment files by default. So you have to load it first.

	source /path/to/your/environment/files; ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id

You can find you environment files by running:

	rvm env --path -- ruby-version[@gemset-name]

Assuming the the project ruby@gmeset is 1.9.2-p290@projectX then calling:

	rvm env --path -- 1.9.2-p290@projectX

will return:

	/Users/juuro/.rvm/environments/ruby-1.9.2-p290

So your command for cron would be:

	source /Users/juuro/.rvm/environments/ruby-1.9.2-p290; ruby ratings-imdb-to-trakt.rb trakt-api-key trakt-username trakt-password-in-sha1 imdb-id