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

