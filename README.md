# Gips

Gips is a simple tool to generate GPX routes that mimic realistic user movement in the iOS simulator.

It is a known limitation that Simulator moves between waypoints at constant speed, ignoring timestamps defined in the GPX files.
Gips works around this by inserting interpolated points between two waypoints to match the required speed.

## Usage

You'll need ruby to use Gips. First, install dependencies by running

    bundle

then run gips:

    ./gips.rb --speed 25 input.gpx output.gpx

Then add the output.gpx to your Xcode project. For more info see http://blackpixel.com/blog/2013/05/simulating-locations-with-xcode.html

## Generating input GPX

To generate your own routes, you may find following sites useful:

* http://www.gpsvisualizer.com/convert_input (allows generation of GPX files from Google Maps route URLs)
* http://www.gmap-pedometer.com lets you make your own running/cycling routes and export to GPX via external bookmarklet

## Sample routes

Few generated routes for Austria can be found in `routes/`.

## License

Both code and sample routes are released under public domain.