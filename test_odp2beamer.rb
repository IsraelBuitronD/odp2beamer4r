#! /usr/bin/env ruby

require 'treetop'
require 'zip/zip'
require File.expand_path(File.dirname(__FILE__) + '/odp2beamer_nodes')

Treetop.load "odp2beamer"

unless ARGV.length == 1
  puts "USAGE: #{__FILE__} [odp_file]"
  exit
end

parser = Odp2BeamerParser.new
odp_filename = ARGV[0]
  
unless File.readable?(odp_filename)
  puts "File '#{odp_filename}' is not readable."
  exit
end

# Extracting main 'content.xml' file
content_xml = 'content.xml'
Zip::ZipFile.open(odp_filename) do |zipfile|
  content_file = zipfile.find_entry(content_xml)
  #content_file.extract { true }
end

# Reading and parsing main 'content.xml'
file   = File.open(content_xml, 'r')
buffer = file.readlines.join('')
file.close
result = parser.parse(buffer)

# Parse Results 
if result.nil?
  puts "Parse FAILURE => #{parser.failure_reason}"
  exit
end

# Create directory to put outputs
dir_base = File.basename(odp_filename, File.extname(odp_filename))
FileUtils.mkdir(dir_base) unless File.exist?(dir_base)

# Create Beamer Latex file
tex_output_filename = "#{File.dirname(__FILE__)}/#{dir_base}/#{dir_base}.tex"
tex_output = File.new(tex_output_filename, 'w+')
tex_output.puts(result.value.strip)
tex_output.close

# Deleting temporal files
#File.delete(content_xml)

