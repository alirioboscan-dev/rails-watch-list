# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require "open-uri"
require "json"

puts "Cleaning database..."
Bookmark.destroy_all
List.destroy_all
Movie.destroy_all

puts "Fetching movies from TMDB..."

(1..10).each do |page|
  url = "https://tmdb.lewagon.com/movie/top_rated?page=#{page}"
  data = JSON.parse(URI.open(url).read)

  data["results"].each do |movie|
    next if movie["poster_path"].nil?
    next if movie["overview"].blank?

    Movie.create(
      title:      movie["title"],
      overview:   movie["overview"],
      poster_url: "https://image.tmdb.org/t/p/original#{movie['poster_path']}",
      rating:     movie["vote_average"].round(1)
    )
  end

  puts "Page #{page} done — #{Movie.count} movies so far..."
end

puts "Done! #{Movie.count} movies created."
