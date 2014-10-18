require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'active_support'
require 'active_support/core_ext'
require 'sqlite3'
require 'data_mapper'

@doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))
#json = Hash.from_xml(@doc.to_xml).to_json


File.delete('share.sqlite') if File.exists?'share.sqlite'
DataMapper.setup(:default,"sqlite3://#{Dir.pwd}/share.sqlite")


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


#Unpackaging the array into the sqlite databaase
def create(row)#,lastCommWithServer,lat,long,installed,locked,installdate,removaldate,temporary,pub,nbBikes,nbEmptyDocks,latestUpdateTime)
 # station.each do |row|
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

#Looks up a particular bike location
def look(search)
	@stations = @doc.xpath("//station[contains(name,'#{search}')]")
	puts @stations
end

#node.to_xml.gsub(/<\/.*>/,"").gsub(/\</,"").gsub(/\/?>/,": =>")

DataMapper.finalize
Stations.auto_migrate!

#gsub(/\n?\s?<.*?>/, "|").gsub(/\n/, "")
#TABLE_NAME = "Bikes"
#FIELD_NAMES = [['id', 'NUMERIC'], ['name', 'STRING'], ['terminalName', 'STRING'], ['lastCommWithServer', 'STRING'], ['lat', 'VARCHAR'], ['long', 'VARCHAR'], ['installed', 'STRING'], ['locked', 'STRING'], ['installDate', 'INTEGER'],  ['removalDate','INTEGER'], ['temporary', 'BOOLEAN'], ['public', 'BOOLEAN'], ['nbBikes', 'INTEGER'], ['nbEmptyDocks', 'INTEGER'], ['latestUpdateTime', 'INTEGER']
#

#puts q
#
#@doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))

def import(stations)
#Take the "Look" method output and format into a useable array
  @stations = stations.css('station').map{|row| row.to_s.gsub(/(\n  )?<.*?>/,",").gsub(/,{2,}/,",").gsub(/,{2,}/,",").gsub(/^,|,$/,"").gsub(/\n/,"")}[1].split(",")
end

#@a.css('station').map{|row| row.to_s.gsub(/(\n  )?<.*?>/,",").gsub(/,{2,}/,",").gsub(/,{2,}/,",").gsub(/^,|,$/,"").gsub(/\n/,"")}[1].split(",")

create(import(look("Belmont")))


=begin
#Test functions
@db = SQLite3::Database.open 'share.sqlite'
@check = puts @db.execute ("select * from stations")
@insert = Stations.create(
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