require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'sqlite3'
require 'data_mapper'

#Create a nokogiri object to hold complete dataset
@doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))

#Uncomment next line if we need to start from scratch
#File.delete('share.sqlite') if File.exists?'share.sqlite'

#Preparing data migrations
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/share.sqlite")

#missing the remove date; not sure how to strip empty fields
class Stations	
  include DataMapper::Resource
  property :id, Serial
  property :sid, Integer
  property :name, String
  property :terminalname, String
  property :lastCommWithServer, String
  property :lat, Float
  property :long, Float
  property :installed, Boolean
  property :locked, Boolean
  property :installdate, Integer
  property :temporary, Boolean
  property :public, Boolean
  property :nbBikes, Integer
  property :nbEmptyDocks, Integer
  property :latestUpdateTime, Integer
end

#Wrapping up the database
DataMapper.finalize
Stations.auto_migrate!

#Function to look up bike dock by name that accepts a string argument. Storing everything in the stations variable for now
def look(search)
	@stations = @doc.xpath("//station[contains(name,'#{search}')]")
  if @stations.blank? 
    puts "Doesnt look like anything was in there. Try again."
  else
    puts "All loaded up!"
  end
end

#Take the "Look" method output and format into a useable array
def import(stations)
  @readydata = stations.css('station').map{|row| row.to_s.gsub(/(\n  )?<.*?>/,",").gsub(/,{2,}/,",").gsub(/,{2,}/,",").gsub(/^,|,$/,"").gsub(/\n/,"")}[1].split(",")
  puts "Data is ready to be inserted!"
end

#Unpackaging the array into the sqlite database. 
def create(row)
    puts 'Adding row...'
    Stations.create(
      :sid => row[0],
      :name => row[1],
      :terminalname => row[2],
      :lastCommWithServer => row[3],
      :lat => row[4],
      :long => row[5],
      :installed => row[6],
      :locked => row[7],
      :installdate => row[8],
      :temporary => row[9],
      :public => row[10],
      :nbBikes => row[11],
      :nbEmptyDocks => row[12],
      :latestUpdateTime => row[13]
     ).save
  # end
end

 
def beam(station)
  @doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))
  @stations = @doc.xpath("//station[contains(name,'#{station}')]")
  if @stations.blank? 
    puts "Doesnt look like anything was in there. Try again."
  else
    @readydata = @stations.css('station').map{|row| row.to_s.gsub(/(\n  )?<.*?>/,",").gsub(/,{2,}/,",").gsub(/,{2,}/,",").gsub(/^,|,$/,"").gsub(/\n/,"")}[1].split(",")
    puts "Everything is formatted nicely. Adding row..."
    Stations.create(
      :sid => @readydata[0],
      :name => @readydata[1],
      :terminalname => @readydata[2],
      :lastCommWithServer => @readydata[3],
      :lat => @readydata[4],
      :long => @readydata[5],
      :installed => @readydata[6],
      :locked => @readydata[7],
      :installdate => @readydata[8],
      :temporary => @readydata[9],
      :public => @readydata[10],
      :nbBikes => @readydata[11],
      :nbEmptyDocks => @readydata[12],
      :latestUpdateTime => @readydata[13]
     ).save
    puts "Complete!"
    @db = SQLite3::Database.open 'share.sqlite'
    @check
  end
end



#Some functions to retrieve data
@db = SQLite3::Database.open 'share.sqlite'
@check = @db.execute ("select * from Stations")

=begin
#Test functions

  :sid => @stations[0],
  :name => @stations[1],
  :terminalname => @stations[2],
  :lastCommWithServer => @stations[3],
  :lat => @stations[4],
  :long => @stations[5],
  :installed => @stations[6],
  :locked => @stations[7],
  :installdate => @stations[8],
  :temporary => @stations[9],
  :public => @stations[10],
  :nbBikes => @stations[11],
  :nbEmptyDocks => @stations[12],
  :latestUpdateTime => @stations[13]
   )

@inserttest = Stations.create(
  :sid => "272",
  :name => "14th &amp; Belmont St NW",
  :terminalname => "31119",
  :lastCommWithServer => "1413562785753",
  :lat => "38.921074",
  :long => "-77.031887",
  :installed =>  "true",
  :locked =>  "false", 
  :installdate =>  "1380719160000",
  :temporary =>  "false", 
  :public =>  "true",
  :nbBikes =>   "0",
  :nbEmptyDocks =>  "14",
  :latestUpdateTime =>  "1413562543066"
   )
=end