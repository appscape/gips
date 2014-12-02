# Gips

<img src="https://raw.github.com/appscape/gips/master/docs/action.gif" alt="Gips in action">

Gips is a simple tool for generating GPX routes that mimic realistic user movement in the iOS simulator.

It is a known limitation that simulator moves between waypoints at constant speed, ignoring timestamps defined in the GPX files.

Gips works around this by inserting interpolated points between two waypoints to match the required speed.

## Usage

You'll need ruby to use Gips. First, install dependencies by running

    bundle

then run gips and supply wanted speed in km/h as integer value:

    ./gips.rb --speed 20 input.gpx output.gpx

If your route is one-way only, you can generate the way back by using the `--reverse` option.

Then add the output.gpx to your Xcode project. For more info see http://blackpixel.com/blog/2013/05/simulating-locations-with-xcode.html

## Generating input GPX

To generate your own routes, you may find following sites useful:

* http://www.gpsvisualizer.com/convert_input (allows generation of GPX files from Google Maps route URLs)
* http://www.gmap-pedometer.com lets you make your own running/cycling routes and export to GPX via external bookmarklet

## Sample routes

Few generated routes for Austria can be found in `routes/`.

## License

Both code and sample routes are released under public domain.
