require 'gruff'
require 'rmagick'
g = Gruff::Line.new
g.y_axis_label = 'Accuracy'
g.x_axis_label = '#Neurons'
g.labels = { 0 => '5', 1 => '10', 2 => '50', 3 => '100', 4 => '200' }
nr_epochs = 50
g.title = "Learning rate impact, #epochs=#{nr_epochs}"
learning_rates = %w(0.1 0.01 0.001 0.0001)

learning_rates.each do |lr|
  evaluation_files = Dir["a_*_l_#{lr}_e_#{nr_epochs}.txt"]
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
  g.data lr, results
end

g.write('learning_rates.png')
