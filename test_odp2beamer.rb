#! /usr/bin/env ruby

require 'treetop'
require File.expand_path(File.dirname(__FILE__) + '/odp2beamer_nodes')

Treetop.load "odp2beamer"

if ARGV.length == 1
  puts "USAGE: #{__FILE__} [context.xml]"
  exit
end

parser = Odp2BeamerParser.new

filename = ARGV[0]
  
unless File.readable?(filename)
  puts "File '#{filename}' is not readable."
  exit
end

file   = File.open(filename, 'r')
buffer = file.readlines.join('')
result = parser.parse(buffer)

# Parse Results 
if result.nil?
  puts "Parse FAILURE => #{parser.failure_reason}"
else
  puts "Parse SUCCESS"
  puts result.value.strip
end


