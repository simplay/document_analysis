% This is a quite verbose script that does shape recognition and dumps lots
% of debugging data to the console and opens various windows.

clc
clear all;
close all;

% Demo mode
verbose = true;
files = {{'Shapes_Border_Medium_Validation', '' }};

% Batch compute mode
verbose = false;
files = {{'Shapes0', '', '_gaussian_noise'}, {'Shapes1', '', 'N1'}, ...
    {'Shapes2', '', 'N2A', 'N2B'}, {'Shapes_Border_Easy_Validation', '' }, ...
    {'Shapes_Border_Medium_Validation', '' }, ...
    {'Shapes_Border_Heavy_Validation', '' }, ...
    {'Shapes_Noise_Easy_Validation', '' }, ...
    {'Shapes_Noise_Medium_Validation', '' }, ...
    {'Shapes_Noise_Heavy_Validation', '' }, ...
    {'Shapes_Clean_Validation', '' }};

%% Test files
files = {{'Shapes_Border_Medium_Test', '' }, ...
    {'Shapes_Border_Heavy_Test', '' }, ...
    {'Shapes_Noise_Easy_Test', '' }, ...
    {'Shapes_Noise_Medium_Test', '' }, ...
    {'Shapes_Noise_Heavy_Test', '' }, ...
    {'Shapes_Clean_Test', '' }};

%files = {{'Shapes_Noise_Heavy_Test', '' }};
verbose = true;
%% Start with given settings
for filenum = 1:numel(files)
    cell = files{filenum};
    filename = char(cell{1});
    for i = 2:length(cell)
        suffix = char(cell{i});
        fprintf(['Doing ', filename, suffix, '\n']);
        [ img, img_preprocessed, responses, failures, targets, outputs, hits ] = classifyShapes(filename, suffix, verbose);
        if verbose
            runEvaluation(img, img_preprocessed, responses, failures, targets, outputs, hits , filename, suffix);
        end
    end
end