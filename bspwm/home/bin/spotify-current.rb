#!/usr/bin/env ruby
require 'json'

status = `playerctl status --player=spotify 2>/dev/null`.chomp

icon = ''

icon = case status
       when 'Playing'
         ''
       when 'Paused'
         ''
       else
         ''
       end

puts "#{icon} #{`playerctl metadata xesam:albumArtist 2>/dev/null`.delete "\n"} - #{`playerctl metadata xesam:title 2>/dev/null`.delete "\n"}"
