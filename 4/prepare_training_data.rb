class PrepareTraningData
  # @param filename [String] trainingdata file name.
  def initialize(filename, samples)
    file = File.open(filename)
    file_line_count = file.lines.count
    take_idx_multiple = (file_line_count / samples).to_i
    training_data_filename = "mnist.train.#{take_idx_multiple}.txt"
    out_file = File.new(training_data_filename, "w")
    file.lines.select.with_index do |line, line_idx|
      if (line_idx % take_idx_multiple == 0)
        out_file.puts(line)
      end
    end
    file.close
    out_file.close
  end
end
