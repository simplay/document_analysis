require 'pry'
class PrepareTraningData
  # @param filename [String] trainingdata file name.
  def initialize(filename, samples)
    file = File.new(filename, 'r')
    file_line_count = file.each_line.count
    take_idx_multiple = (file_line_count / samples).to_i
    training_data_filename = "mnist.train.#{take_idx_multiple}.txt"
    collected_lines = []
    file = File.new(filename, 'r')
    file.lines.select.with_index do |line, line_idx|
      if (line_idx % take_idx_multiple == 0)
        collected_lines << line
      end
    end
    file.close

    out_file = File.new(training_data_filename, "w")
    collected_lines.each do |collected_line|
      out_file.puts(collected_line)
    end
    out_file.close
  end
end
