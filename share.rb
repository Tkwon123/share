require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'sqlite3'
require 'data_mapper'
require 'timers'
#Create a nokogiri object to hold complete dataset
@doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))



#missing the remove date; not sure how to strip empty fields

if File.file?('share.sqlite')
    puts "Database already exists. Proceeding..."
  else
    puts "Looks like you need a place to store data. Let me build that for you!"
    DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/share.sqlite")
    class Stations  
      include DataMapper::Resource
      property :id, Serial
      property :created, DateTime
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
  #Preparing data migrations

  #Wrapping up the database
  DataMapper.finalize
  Stations.auto_migrate!
  puts "All done! Lets start grabbing data..."
end



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
      :latestUpdateTime => @readydata[13],
      :created => Time.now
     ).save
    puts "New row inserted!"
    puts "You have #{@db.execute("select count(*) from Stations").join()} records in the database."
  end
  @db = SQLite3::Database.open 'share.sqlite'
end



#Some helper functions functions to test data retrieval 
@db = SQLite3::Database.open 'share.sqlite'
@check = @db.execute ("select * from Stations")

beam 'Belmont'
timers = Timers::Group.new
timers.every(60) { beam 'Belmont' }
loop { timers.wait }
