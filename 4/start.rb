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

matlab_file = "preprocessing.m"
command = "java -jar -Xmx512m nn.jar -a SIGMOID -f 784 -n 100 -o 10 -l 0.001 -e 10 mnist.train.txt mnist.test.txt mnist.train.output.txt mnist.test.output.txt"
run_matlab = "matlab -nodisplay -nosplash -nodesktop -r \"run('${PWD}/#{matlab_file}'); quit\""
system(run_matlab) if user_args[:preprocess] == 1
system(command)
