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

existingRatings = open('http://api.trakt.tv/user/ratings/movies.json/'+TRAKT_APIKEY+'/'+TRAKT_USERNAME+'/all').read
existingRatings = JSON.parse(existingRatings)

watchlist_imdb = CurbFu.get('http://www.imdb.com/list/export?list_id=ratings&author_id='+IMDB_ID)
watchlist = CSV.parse(watchlist_imdb.body)

movies = Hash.new

#rate
watchlist.each do |line|
	movie = Hash.new
	movie['imdb_id'] = line[1]	
	#movie['title'] = line[5]
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
	if watchlist_imdb.body.include?(thisMovie['imdb_id']) == false
		
		movie = Hash.new
		movie['imdb_id'] = thisMovie['imdb_id']
		movie['rating'] = 0
		
		movies[movie['imdb_id']] = movie.to_hash
	end
end

#debug
#pp movies

header = Hash.new
header['username'] = TRAKT_USERNAME
header['password'] = TRAKT_PASSWORD
header['movies'] = movies

response = CurbFu.post('http://api.trakt.tv/rate/movies/'+TRAKT_APIKEY, JSON[header])

pp JSON.parse(response.body)