#!/usr/bin/env ruby
#
# I'm an idiot and named a ton of my picture files as
# SourceName_CamelCaseDescription.ext
# and then I could never found any files while searching for them.
# This fixes my stupid.

require 'pry' if $DEBUG
require 'fileutils'

dir = ARGV[0]
regex = ARGV[1]

unless dir && regex
  puts "usage: #{File.basename(__FILE__)} <dir_to_search> <filename_selection_regex>"
  exit 1
end

def fix_file(file)
  src, *name = file.split('_')
  name = name.join(' ')
  name, ext = name.split('.')
  FileUtils.mv(file, "#{space_camel(src)} - #{space_camel(name)}.#{ext}")
end

def space_camel(str)
  fixed = ''
  str.each_char do |c|
    if !fixed.empty? && c.match(/[A-Z]/) && !fixed[-1].match(/[A-Z ]/)
      fixed << ' ' 
    end
    fixed << c
  end
  fixed
end

FileUtils.cd(dir)

Dir.foreach(dir) do |file|
  next unless file.match(regex)
  fix_file(file)
end
