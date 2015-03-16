% This is a quite verbose script that does shape recognition and dumps lots
% of debugging data to the console and opens various windows.

clc
clear all;
close all;

filename = 'Shapes2';
suffix = 'N2B';


filename = 'Shapes0';
suffix = '';
[ img, img_preprocessed, responses, failures, targets, outputs, hits ] = classifyShapes( filename, suffix);
runEvaluation(img, img_preprocessed, responses, failures, targets, outputs, hits , filename, suffix);
