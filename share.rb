require 'nokogiri'
require 'open-uri'
require 'rubygems'
require 'sqlite3'
require 'active_support/core_ext'
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
	@a = @doc.xpath("//station[contains(name,'#{search}')]")
	puts @a
end

#node.to_xml.gsub(/<\/.*>/,"").gsub(/\</,"").gsub(/\/?>/,": =>")

DataMapper.finalize
DataMapper.auto_migrate!

#gsub(/\n?\s?<.*?>/, "|").gsub(/\n/, "")
#TABLE_NAME = "Bikes"
#FIELD_NAMES = [['id', 'NUMERIC'], ['name', 'STRING'], ['terminalName', 'STRING'], ['lastCommWithServer', 'STRING'], ['lat', 'VARCHAR'], ['long', 'VARCHAR'], ['installed', 'STRING'], ['locked', 'STRING'], ['installDate', 'INTEGER'],  ['removalDate','INTEGER'], ['temporary', 'BOOLEAN'], ['public', 'BOOLEAN'], ['nbBikes', 'INTEGER'], ['nbEmptyDocks', 'INTEGER'], ['latestUpdateTime', 'INTEGER']
#

#puts q
#
#@doc = Nokogiri::XML(open('https://www.capitalbikeshare.com/data/stations/bikeStations.xml'))
def import(stations)
  @stations = stations.css('station').map{|row| row.to_s.gsub(/(\n  )?<.*?>/,",").gsub(/,{2,}/,",").gsub(/^,|,$/,"'").gsub(/,/,"','").gsub(/\n'/,"")}
end


#Test functions
@db = SQLite3::Database.open 'share.sqlite'
@check = puts @db.execute ("select * from stations")
@arr = ['foo1','foo2','foo3']
@arr2 = ['poo1','poo2','poo3']
@arrc = [@arr,@arr2]

['135','Columbia Rd &amp; Belmont St NW','31113','1413128220691','38.920669','-77.04368','true','false','1321625100000','false','true','8','11','1413128220519']
