function [ gt_strings ] = load_gt_strings(set_name, words_directory)
%LOAD_GT_STRINGS Returns a cell array with the gt strings corresponding to
%the images found in the words directory. 
    gt_file = fopen(['Input/', set_name, '/', set_name '.txt'], 'r');
    % Retrieve gt string for every image in our database (.txt contains many
    % more).
    scanned = textscan(gt_file, '%s %s');
    word_files = dir([words_directory '/*.png']);
    gt_strings = {length(word_files)};
    scanned_idx = 1;
    for i = 1:length(word_files)
        [~, name] = fileparts(word_files(i).name);
        while ~strcmp(scanned{1}{scanned_idx}, name)
            scanned_idx = scanned_idx + 1;
        end
        gt_strings{i} = scanned{2}{scanned_idx};
    end
end

