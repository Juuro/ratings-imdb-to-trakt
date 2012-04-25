#!/usr/bin/ruby
#Encoding: UTF-8

require 'pp'
require 'curb-fu'
require 'json'
require 'csv'

TRAKT_APIKEY = ARGV[0]
TRAKT_USERNAME = ARGV[1]
TRAKT_PASSWORD = ARGV[2]
IMDB_ID = ARGV[3]

watchlist_imdb = CurbFu.get('http://www.imdb.com/list/export?list_id=ratings&author_id='+IMDB_ID)

watchlist = CSV.parse(watchlist_imdb.body)

movies = Hash.new

watchlist.each do |line|
	movie = Hash.new
	movie['imdb_id'] = line[1]
	#movie['title'] = line[5]
	movie['year'] = line[11]
	movie['rating'] = line[8]
	movies[movie['imdb_id']] = movie.to_hash
end

#debug
#pp movies

header = Hash.new
header['username'] = TRAKT_USERNAME
header['password'] = TRAKT_PASSWORD
header['movies'] = movies

response = CurbFu.post('http://api.trakt.tv/rate/movies/ec27e70bb0578395e1e0527cb44124f4', JSON[header])

pp JSON.parse(response.body)