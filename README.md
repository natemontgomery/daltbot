# README

* Ruby version

3.3.0 tested

* System dependencies

Rails (and its dependencies) and Geocoder.  Just use `bundle` as usual (or `bundle install` if you like typing more).
SQLite3 was used for DB, will need a local install.
Uses the OpenWeatherMap API, need a key for that.

* Configuration

Add API key to ENV in some way.

* Thoughts as I go

Init Git repo and Rails
Add Geocoder since I know I need to work with addresses.  Using a raw address string is much more error prone than lat/lon queries generally, just getting ahead of the problem.
The point of the app is to show weather forecasts (going to call current a forecast too, seems like a reasonable semantic), so I start with a model for that as the basis of controller othe busines logic.
