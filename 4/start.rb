#!/usr/bin/env ruby

require 'optparse'
require_relative 'prepare_training_data.rb'

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

training_samples = [20, 100, 1000, 2000, 5000, 10000]
training_samples.each do |samples|
  PrepareTraningData.new("mnist.train.txt", samples)
end
number_neurons = [5, 10, 50, 100, 200, 500, 784, 1000]
number_epochs = [5, 10, 50, 100]
learning_rates = [0.0001, 0.001, 0.01, 0.1]
training_data_file_idxs = [6, 12, 30, 60, 600, 3000]
parameters_list = [number_neurons, number_epochs, learning_rates, training_data_file_idxs]
parameters_list = parameters_list.first.product(*parameters_list[1..-1])

# Train neuronal network.
parameters_list.each do |parameters|
  nn = parameters[0]
  e = parameters[1]
  lr = parameters[2]
  training_data_file_idx = parameters[3]
  puts "Parameters: nn=#{nn} e=#{e} lr=#{lr} training_data_file_idx=#{training_data_file_idx}"
  filename = "a_SIGMOID_f_#{feature_size}_n_#{nn}_o_10_l_#{lr}_e_#{e}_td_#{training_data_file_idx}.txt"
  unless File.exist?(filename)
    command = "java -jar -Xmx512m nn.jar -a SIGMOID -f #{feature_size} -n #{nn} -o 10 -l #{lr} -e #{e} mnist.train.#{training_data_file_idx}.txt mnist.test.txt mnist.train.output.txt mnist.test.output.txt > #{filename}"
    system(command)
  else
    puts "Skipping file #{filename} - it already exists!"
  end
end

