# README

Weather App using purely free APIs from OpenWeather.  You don't need to pay a dime to tell the weather.

Named after John Dalton.

Provides a 'Current' weather output and 5-day forecast using 3-hour bins.

All that is needed from the user is a valid address.  If your address is ambigious then you may end up with results for an unexpected location.  The full address used is displayed at the top of the result.

Each search caches the results for the Postal Code of the address used.  This cache lasts for 30 minutes.

The input address is geocoded (and reverse geocoded) using the Photon API (https://photon.komoot.io/) via the Geocoder gem.

### Ruby version

3.3.0 tested

### System dependencies

* Install Ruby: `ruby-install` is my preferred method, but not required.
* Install Bundler: `gem install bundler` should work once you have Ruby installed.
* Install SQLite3: `sudo apt install sqlite3` on Debian/Ubuntu
* Install Node: Since NVM is the default suggested by Node.js, I used that.  Any install of Version 20.11.1 should work.

### Setup App

From within the top level directory of this repo:

```
bundle
corepack enable
yarn

bin/rails db:migrate
bin/rails db:setup
```

Since this uses the OpenWeatherMap API you will need a key for that.  Example provided below.

### Run

`API_KEY="7e475559f84362711dada9890e161b6c" bin/dev`

Will spin up your Rails server and build assets for you.  API Key for OpenWeather, this is a free one on my personal account, please use responsibly.

Navigate to `localhost:3000` in a browser.

### Models

#### Forecast
  * address_id:
    - Foreign Key representing Address record for this Forecast.
  * dt:
    - Timestamp provided by OpenWeather for when request was processed.
  * weather_description:
    - A word or phrase that describes the overall weather, ie cloudy.
  * temp:
    - Temperature in Fahrenheit.
  * feels_like:
    - The human experienced temperature in Fahrenheit.
  * temp_max:
    - High temperature in Fahrenheit.
  * temp_min:
    - Low temperature in Fahrenheit.
  * humidity:
    - Humidity in percentage.
  * pressure:
    - Atmospheric pressure in hPa.
  * raw_forecast:
    - A JSON blob of the raw response from the OpenWeather 5-day/3-hour forecast.

Due to limitations of the free API endpoints in the OpenWeather Client Gem I stored the forecast in a raw JSON blob.

To help with clarity the fields that are parsed out of this JSON mirror the attributes given above.

#### Address
  * raw_address:
    - String as entered for weather lookup, used to keep track of unique searches.
  * latitude:
    - Latitude from Geocoder call on raw_address.
  * longitude:
    - Longitude from Geocoder call on raw_address.
  * street:
    - Street as determined by reverse geocode of latitude and longitude.
  * housenumber:
    - House Number as determined by reverse geocode of latitude and longitude.
  * locality:
    - Locality as determined by reverse geocode of latitude and longitude.
  * district:
    - District as determined by reverse geocode of latitude and longitude.
  * city:
    - City as determined by reverse geocode of latitude and longitude.
  * state:
    - Statee as determined by reverse geocode of latitude and longitude.
  * country:
    - Country as determined by reverse geocode of latitude and longitude.
  * postcode:
    - Postal Code as determined by reverse geocode of latitude and longitude.
  * name:
    - A special name of address if determined by reverse geocode of latitude and longitude.

Both models have Rails' basic Timestamps as well.

### Left to Do

The first thing to do if this was to become a production application would be to get the API Key hidden and encrypted using a secrets store external to the repo.
This wasn't done to save time but plain text secrets in the repo is not something that you want to deploy to production of course.

I would really like the results to be styled more.  Obviously a plain text response is not very exciting, but the functionality came first.

I think some better error handling would be next, I added some basic handling but there are some cases that definitely are untested/unhandled.

In the process of building out better error handling I think the tests could be fleshed out also.

I would also like to revisit the handling of the 5-day forecast.  It would be great to break down the JSON blob into objects that align everything so we can reuse more of the presentation logic.
