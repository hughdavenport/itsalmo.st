#!/usr/bin/env ruby

require 'rubygems'
require 'bundler'
Bundler.require

name = ARGV.fetch(0, "currytime")
day = ARGV.fetch(1, "Thursday")

url = "http://itsalmo.st/itsalmost-prod/timer/#{name}"
expires = Chronic.parse("next #{day} 12:00").to_datetime.strftime("%Q")
now = DateTime.now.strftime("%Q")

agent = Mechanize.new

agent.get(url, {"_" => now}) do |page|
  result = JSON.parse(page.body)

  if result.empty?
    response = agent.post(url, {"name" => name, "expires" => expires})
    puts "Event on next #{day} at 12pm"
    puts "http://itsalmo.st/##{name}"
  else
    puts "\"#{name}\" is already taken"
  end
end
