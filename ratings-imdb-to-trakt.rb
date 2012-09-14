#!/usr/bin/env ruby
#Encoding: UTF-8

require 'rubygems'
require 'pp'
require 'csv'
require 'curb-fu'
require 'json'
require 'open-uri'

TRAKT_APIKEY = ARGV[0]
TRAKT_USERNAME = ARGV[1]
TRAKT_PASSWORD = ARGV[2]
IMDB_ID = ARGV[3]
SOCIAL = ARGV[4]

existingRatings = open('http://api.trakt.tv/user/ratings/movies.json/'+TRAKT_APIKEY+'/'+TRAKT_USERNAME+'/all').read
existingRatings = JSON.parse(existingRatings)

watchlist_imdb = CurbFu.get('http://www.imdb.com/list/export?list_id=ratings&author_id='+IMDB_ID)
watchlist = CSV.parse(watchlist_imdb.body)
watchlist = watchlist.to_a[1..-1]

movies = Hash.new

#rate
watchlist.each do |line|
	movie = Hash.new
	movie['username'] = TRAKT_USERNAME
	movie['password'] = TRAKT_PASSWORD
	movie['imdb_id'] = line[1]	
	movie['title'] = line[5].unpack("U*").pack("U*")
	movie['year'] = line[11]
	movie['rating'] = line[8]

	movies[movie['imdb_id']] = movie.to_hash

	#rate only if the rating is different
	existingRatings.each do |thisMovie|
		if thisMovie['imdb_id'] == movie['imdb_id']
			if thisMovie['rating_advanced'] == movie['rating'].to_i
				movies.delete(thisMovie['imdb_id'])
			end
		end
	end
end

#unrate if no longer rated in IMDb
existingRatings.each do |thisMovie|
	if !thisMovie['imdb_id'].nil?
		if watchlist_imdb.body.include?(thisMovie['imdb_id']) == false		
			movie = Hash.new
			movie['username'] = TRAKT_USERNAME
			movie['password'] = TRAKT_PASSWORD
			movie['imdb_id'] = thisMovie['imdb_id']
			movie['title'] = thisMovie['title']
			movie['year'] = thisMovie['year']
			movie['rating'] = 0

			movies[movie['imdb_id']] = movie.to_hash
		end
	end
end

if SOCIAL == "nosocial"
	# uses http://trakt.tv/api-docs/rate-movies
	# without social updates
	# all movies together
	header = Hash.new
	header['username'] = TRAKT_USERNAME
	header['password'] = TRAKT_PASSWORD
	header['movies'] = movies

	response = CurbFu.post('http://api.trakt.tv/rate/movies/'+TRAKT_APIKEY, JSON[header])

	pp JSON.parse(response.body)
elsif
	# uses http://trakt.tv/api-docs/rate-movie to rate
	# with social updates
	# every movie separate
	movies.each_value do |thisMovie|
		pp thisMovie['imdb_id']
		pp thisMovie['title']
		response = CurbFu.post('http://api.trakt.tv/rate/movie/'+TRAKT_APIKEY, JSON[thisMovie])
		pp JSON.parse(response.body)
	end
end