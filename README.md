share
=====

A handy tool for DC's biking commuters by monitoring's Capital Bikeshare locations. 

Inspired by a fundamental issues communitting with a communal shared service including:
  - Large, unidirectional bike migrations
  - Limited # of bikes at local docks
  - Inefficient restocking of dock locations
  
This tool hopes to minimize the penalty of finding empty bike locations by maximizing knowledge of a rapidily depleting resource. 

Methods: 
Parse an xml data feed via nokogiri, and store the data on sqlite3 database. 
