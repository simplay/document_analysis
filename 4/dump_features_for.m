function [ ] = dump_features_for( folder, output_file )
%DUMP_FEATURES_FOR Dumps features for every picture in the folder 
% to the given output file. The correct label is prepended in the beginning.
% Features are computed using the function compute_features(img)

    train_files = dir([folder '*.png']);
    for file_number=1:length(train_files)
        file = train_files(file_number);
        [~, filename] = fileparts(file.name);
        
        % file name convention example: 
        %   'img'    'lbl0'    '1'    'num'
        split_filename = strsplit(filename, '-');

        lbl = split_filename(2);
        lbl_number = lbl{1}(end);
        features = compute_features(imread([folder, file.name]));
        fprintf(output_file, '%s,', lbl_number);
        
        fprintf(output_file, '%f,', features(1:end-1));
        fprintf(output_file, '%f', features(end));
        fprintf(output_file, '\n');
    end

end

