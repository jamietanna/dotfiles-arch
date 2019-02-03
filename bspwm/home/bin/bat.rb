#!/usr/bin/env ruby

def extract_xresources_field(colour_name)
  File.open("#{Dir.home}/.theme_colours.h") do |file|
    l = file.find do |line|
      line =~ /^#define #{colour_name}\w+/
    end
    '#' + l.split('#')[2].chomp
  end
end

DATA = `acpi -b`.freeze
remainder = DATA.match(/([0-9]{2}):([0-9]{2}):([0-9]{2})/)
percentage = DATA.match(/([0-9]+)%/)[0]

background = '-'
foreground = '-'

output = ''
charging_indicator = ''

if DATA.match?(/Discharging/)
  hours = remainder[0].to_i
  mins = remainder[1].to_i

  if percentage.to_i <= 30 ||
      hours == 0 && mins <= 30
    foreground = extract_xresources_field 'col_red'
  elsif percentage.to_i <= 10 ||
      hours == 0
    background = extract_xresources_field 'col_red'
    foreground = extract_xresources_field 'col_white'
  end

else
  charging_indicator = '+'
end

output = "%{B#{background}}" +
  "%{F#{foreground}}" +
  percentage +
  ' ' +
  charging_indicator +
  remainder[0] +
  '%{F-}%{B-}'

puts output
