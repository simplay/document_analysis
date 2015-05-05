matlab_file = "preprocessing.m"
command = "java -jar -Xmx512m nn.jar -a SIGMOID -f 784 -n 100 -0 10 -l 0.001 -e 10 mnist.train.txt mnist.test.txt mnist.train.output.txt mnist.test.output.txt"
run_matlab = "matlab -nodisplay -nosplash -nodesktop -r \"run('${PWD}/#{matlab_file}'); quit\""
system(run_matlab)
system(command)
