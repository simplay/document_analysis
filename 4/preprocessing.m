function []=preprocessing(method)

disp(['running method ', num2str(method)]);
train_folder = 'input/images/train/';
test_folder = 'input/images/test/';

train_output = fopen(['mnist_',num2str(method),'.train.txt'], 'w');
test_output = fopen(['mnist_',num2str(method),'.test.txt'], 'w');
disp('Start Preprocessing...');
tic
dump_features_for(train_folder, train_output, method);
dump_features_for(test_folder, test_output, method);
toc
disp('Finished Preprocessing..');
fclose(train_output);
fclose(test_output);
end