#!/usr/bin/env ruby

require 'rubygems'
require 'nokogiri'
require 'clamp'

require 'clamp'

XCODE_WAYPOINTS_PER_SECOND = 0.5

Clamp do
  option "--reverse", :flag, "After reaching destination, travel back to start"
  option "--speed", "KMH", "Speed in km/h (integer)", required: true do |s|
    Integer(s)
  end

  parameter "SRC.gpx", "Source GPX file", attribute_name: :infile
  parameter "DST.gpx", "Destination GPX file", attribute_name: :outfile

  def distance(a, b)
    rad_per_deg = Math::PI/180  # PI / 180
    rkm = 6371                  # Earth radius in kilometers
    rm = rkm * 1000             # Radius in meters

    dlon_rad = (b[1]-a[1]) * rad_per_deg  # Delta, converted to rad
    dlat_rad = (b[0]-a[0]) * rad_per_deg

    lat1_rad, lon1_rad = a.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = b.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    rm * c # Delta in meters
  end

  def execute
    mps = (0.277777777777778 * speed)

    doc = Nokogiri::XML(open(infile))
    previous = nil
    output = []

    points = doc.css('rtept,trkpt').map {|p| [p['lat'].to_f, p['lon'].to_f]}.uniq

    puts "Found #{points.count} route points in #{infile}."

    points.each do |p|
      coords = p
      if !previous
        output << coords
      else
        d = distance(coords, previous)
        parts = [(d * XCODE_WAYPOINTS_PER_SECOND / mps).to_i,1].max
        dlat = (coords[0]-previous[0])/parts.to_f
        dlon = (coords[1]-previous[1])/parts.to_f
        parts.times do |i|
          output << [previous[0] + dlat * (i+1), previous[1] + dlon * (i+1)]
        end
      end
      previous = coords
    end

    if reverse?
      puts "Reversed route."
      output.concat(output.reverse[1..-1])
    end

    File.open(outfile,'w') do |f|
      f.puts "<gpx>"
      output.each do |o|
       f.puts "<wpt lat=\"#{o[0]}\" lon=\"#{o[1]}\"></wpt>"
      end
      f.puts "</gpx>"
    end

    puts "Wrote #{output.count} points to #{outfile} to simulate speed of #{speed} km/h."
  end
end
