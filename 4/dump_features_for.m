function [ ] = dump_features_for( folder, output_file )
%DUMP_FEATURES_FOR Dumps features for every picture in the folder 
% to the given output file. The correct label is prepended in the beginning.
% Features are computed using the function compute_features(img)

    METHOD = 1;
    files = dir([folder '*.png']);
    % A sampling rate of n means every n-th image is used.
    sampling_rate = 1;
    results = {length(files)/sampling_rate};
    parfor file_number=1:length(files)/sampling_rate
        %file = files(file_number*sampling_rate);
        file = files(file_number);
        [~, filename] = fileparts(file.name);
        
        % file name convention example: 
        %   'img'    'lbl0'    '1'    'num'
        split_filename = strsplit(filename, '-');

        lbl = split_filename(2);
        lbl_number = lbl{1}(end);
        features = compute_features(imread([folder, file.name]), METHOD);
        label = sprintf('%s,', lbl_number);
        
        features_string = sprintf('%f,', features(1:end-1));
        last_feature_string = sprintf('%f', features(end));
        results{file_number} = [label, features_string, last_feature_string];
    end

    for i=1:numel(results)
         fprintf(output_file, [results{i} '\n']);
    end
end

