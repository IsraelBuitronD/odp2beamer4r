#! /usr/bin/env ruby

require 'treetop'

Treetop.load "mathml"

parser = MathMLParser.new

# Reading and parsing main 'content.xml'
test_cases = 
  [
   '<body>', 
   '<body >', 
   '< body>', 
   '<body> ',
   ' <body> ',
   '<body/>',
   '<body />',
   '</body>'
  ]

test_cases.each do |t|
  result = parser.parse(t)
  
  # Parse Results 
  if result.nil?
    puts "Case\t=> #{t}"
    puts "Parse FAILURE => #{parser.failure_reason}"
    exit
#   else
#     puts "Parse SUCCESS => #{result.inspect}"
  end
end
