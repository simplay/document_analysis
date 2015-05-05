function [ gt_strings, gt_filenames ] = load_gt_strings(words_directory, gt_file, is_line)
%LOAD_GT_STRINGS Returns a cell array with the gt strings corresponding to
%the images found in the words directory. 
    % Retrieve gt string for every image in our database (.txt contains many
    % more).
    scanned = textscan(gt_file, '%s %s');
    word_files = dir([words_directory '/*.png']);
    gt_strings = {length(word_files)};
    gt_filenames = {length(word_files)};
    scanned_idx = 1;
    for i = 1:length(word_files)
        [~, name] = fileparts(word_files(i).name);
        while ~strcmp(scanned{1}{scanned_idx}, name)
            scanned_idx = scanned_idx + 1;
        end
        if is_line
            gt = strsplit(scanned{2}{scanned_idx}, '|');
        else
            gt = scanned{2}{scanned_idx};
        end
        gt_strings{i} = gt;
        gt_filenames{i} = name;
    end
end

