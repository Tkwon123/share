Move!
=====

A handy tool for DC Capital Bikeshare commuters to get a bike when needed (at least adjust your schedule so you can!) 

Inspired by the fundamental issues commuting with a communal shared service including:
  - Massive, unidirectional bike migrations during hours of peak usage
  - Core group of DC Bikeshare subscribers relying on a limited # of bikes at local docking stations at specific times in the day
  - Messy and ineffiecient "manual" restocking of bikes via van payloads
  
This tool hopes to minimize the penalty of finding empty bike locations by maximizing awareness of a rapidily depleting resources.


Methods
=====

Parse Capital Bikeshare [XML live feed] (https://www.capitalbikeshare.com/data/stations/bikeStations.xml) via nokogiri, and store the data on sqlite3 database. Schedule script to conduct snapshots at regular intervals and run analytics against the dataset to identify 1) peak hours of usage 2) timing of countdown 3) and other eventual procedures (see below)

Currently a WIP! Would ultimately like to:
  + Have it running on a webapp of some sort to collect data all the time
  + Hook this up to some kind of mobile/messaging API to send warnings for low bikes
