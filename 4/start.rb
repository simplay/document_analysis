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
number_neurons = [5, 10, 50, 100, 200, 500, 784, 1000]
number_epochs = [5, 10, 50, 100]
learning_rates = [0.0001, 0.001, 0.01, 0.1]
training_samples = [20, 100, 1000, 2000, 5000, 10000] #TODO adapt tran.txt file

parameters_list = [number_neurons, number_epochs, learning_rates]
parameters_list = parameters_list.first.product(*parameters_list[1..-1])

parameters_list.each do |parameters|
  nn = parameters[0]
  e = parameters[1]
  lr = parameters[2]
  puts "Parameters: nn=#{nn} e=#{e} lr=#{lr}"
  command = "java -jar -Xmx512m nn.jar -a SIGMOID -f #{feature_size} -n #{nn} -o 10 -l #{lr} -e #{e} mnist.train.txt mnist.test.txt mnist.train.output.txt mnist.test.output.txt"
  system(command)
end

# Train neuronal network.
#command = "java -jar -Xmx512m nn.jar -a SIGMOID -f #{feature_size} -n 100 -o 10 -l 0.001 -e 10 mnist.train.txt mnist.test.txt mnist.train.output.txt mnist.test.output.txt"
#system(command)
