#!/usr/bin/env ruby

require 'optparse'

user_args = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage example: ruby start.rb -p 1 to run with Matlab preprocessing"
opt.separator ""
  opt.on("-p", "--preprocess g", Integer, "Preprocessing mode: Runs preprocessing if 1 otherwise not.") do |preprocess|
    user_args[:preprocess] = preprocess
  end
end

begin
  opt_parser.parse!
rescue OptionParser::MissingArgument
  puts "Incorrect input argument(s) passed\n"
  puts opt_parser.help
  exit
end

# Run preprocessing.
matlab_file = "preprocessing.m"
run_matlab = "matlab -nodisplay -nosplash -nodesktop -r \"run('${PWD}/#{matlab_file}'); quit\""
system(run_matlab) if user_args[:preprocess] == 1

# Determine number of features retrieved in preprocessing.
begin
    file = File.open("mnist.train.txt", "r")
    line = file.gets
    feature_size = line.split(',').count-1
    file.close
rescue
    raise 'Somethings wrong with input file, try to run with argument -p 1 to generate features'
end
system(command)
