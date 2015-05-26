function [ features ] = compute_features(img, method)
%COMPUTE_FEATURES Computes a feature vector for the given image.
% All features are normalized to the range [-1, 1], as needed by the
% neuronal network.
%At the time of writing, the following methods are available:
%   2: Dump profiles over rows/columns (black-ness of row/column)
%   1: Dump pixel values directly
    grayscale_img = rgb2gray(img);
    %[w, h] = size(grayscale_img);
    
    w = 28;
    if method == 2
        range = (w * 255)/2;
        features_scaled = [sum(grayscale_img) sum(grayscale_img, 2)'];
        % Normalize to range [-1, 1]
        % Normalization is the same for sum along rows and columns, since
        % images are all square.
        features = (features_scaled - range) / range ;
    elseif method == 1
        % Bring to range [0, 1] with double precision.
        d_grayscale_img = im2double(grayscale_img);
        % Flatten and bring to range [-1, 1].
        features = d_grayscale_img(:)*2 - 1;
    elseif method == 3
        grayscale_img = imresize(grayscale_img, 0.5);
        d_grayscale_img = im2double(grayscale_img);
        features = d_grayscale_img(:)*2 - 1;  
    elseif method == 4
        grayscale_img = imresize(grayscale_img, 0.25);
        d_grayscale_img = im2double(grayscale_img);
        features = d_grayscale_img(:)*2 - 1;
    end
end

