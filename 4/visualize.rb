require 'gruff'
require 'rmagick'
g = Gruff::Line.new
g.y_axis_label = 'Accuracy'
g.x_axis_label = '#Neurons'
g.labels = { 0 => '5', 1 => '10', 2 => '50', 3 => '100', 4 => '200', 5 => '500', 6 => '784', 7 => '1000', 8 => '2*784' }
nr_epochs = 100
#learning_rates = %w(0.1 0.01 0.001 0.0001)
lr = 0.1
g.title = "Training set size impact \n #epochs=#{nr_epochs}, learning rate=#{lr}"

tds = %w(1 6 12 30 60 600 3000)
tds.each do |td|
  evaluation_files = Dir["output/a_*_l_#{lr}_e_#{nr_epochs}_td_#{td}.txt"]
  results = []
  evaluation_files.sort_by! { |ele| ele.split('n_').last.split('_').first.to_i }
  puts evaluation_files.join(', ')
  evaluation_files.each do |filename|
    File.open(filename) do |file|
      file.each_line do |line|
        row = line.split(/\s/)
        if row[0] == 'accuracy:'
          results << row[1].to_f
        end
      end
    end
  end
  puts results.join(',')
  label = (60000 / td.to_i).to_s
  g.data label, results
end
file_path = 'output/evaluation'
g.write("#{file_path}/training_set_size_e_#{nr_epochs}_lr_#{lr}.png")
