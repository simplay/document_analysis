#!/usr/bin/env ruby

require 'optparse'
require 'parallel'
require_relative 'prepare_training_data.rb'
used_method = 1
user_args = {}
opt_parser = OptionParser.new do |opt|
  opt.banner = "Usage example: ruby start.rb -p 1 to run with Matlab preprocessing"
  opt.separator ""
  opt.on("-p", "--preprocess p", Integer, "Preprocessing mode: Runs preprocessing if 1 otherwise not.") do |preprocess|
    user_args[:preprocess] = preprocess
  end

  opt.on("-m", "--method m", Integer, "Use preprocessing method m: Either 1,2,3,4.") do |method|
    user_args[:method] = method
    used_method = method.to_i
  end
end

begin
  opt_parser.parse!
rescue OptionParser::MissingArgument
  puts "Incorrect input argument(s) passed\n"
  puts opt_parser.help
  exit
end

method = used_method
# Run preprocessing.
matlab_file = "preprocessing"
run_matlab = "matlab -nodisplay -nosplash -nodesktop -r \"run('${PWD}/#{matlab_file}(#{method})'); quit\""
system(run_matlab) if user_args[:preprocess] == 1

# Determine number of features retrieved in preprocessing.
begin
  file = File.open("mnist_#{method}.train.txt", "r")
  line = file.gets
  feature_size = line.split(',').count-1
  file.close
rescue
  raise 'Somethings wrong with input file, try to run with argument -p 1 to generate features'
end

training_samples = [20, 100, 1000, 2000, 5000, 10000]
training_samples.each do |samples|
  PrepareTraningData.new("mnist_#{method}.train.txt", samples)
end
number_neurons = [5, 10, 50, 100, 200, 500, 784, 1000, 2*784]
number_epochs = [100]
learning_rates = [0.0001, 0.001, 0.01, 0.1]
training_data_file_idxs = [6, 12, 30, 60, 600, 3000]
parameters_list = [number_neurons, number_epochs, learning_rates, training_data_file_idxs]
parameters_list = parameters_list.first.product(*parameters_list[1..-1])

# Train neuronal network.
Parallel.each(parameters_list) do |parameters|
  nn = parameters[0]
  e = parameters[1]
  lr = parameters[2]
  training_data_file_idx = parameters[3]
  filename = "a_SIGMOID_f_#{feature_size}_n_#{nn}_o_10_l_#{lr}_e_#{e}_td_#{training_data_file_idx}.txt"
  file_path_name = "output/#{filename}"
  unless File.exist?(file_path_name)
    puts "Running NN with parameters: nn=#{nn} e=#{e} lr=#{lr} training_data_file_idx=#{training_data_file_idx}"
    training_data_file_name = "input/training_data/mnist.train.#{training_data_file_idx}.txt"
    command = "java -jar -Xmx512m nn.jar -a SIGMOID -f #{feature_size} -n #{nn} -o 10 -l #{lr} -e #{e} #{training_data_file_name} mnist.test.txt mnist.train.output.txt mnist.test.output.txt > #{file_path_name}"
    system(command)
  else
    puts "Skipping file #{filename} - it already exists!"
  end
end

