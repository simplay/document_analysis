train_folder = 'input/train/';
test_folder = 'input/test/';

train_output = fopen('mnist.train.txt', 'w');
test_output = fopen('mnist.test.txt', 'w');

tic
dump_features_for(train_folder, train_output);
dump_features_for(test_folder, test_output);
toc

fclose(train_output);
fclose(test_output);