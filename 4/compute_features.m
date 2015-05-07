function [ features ] = compute_features( img )
%COMPUTE_FEATURES Computes a feature vector for the given image.
    grayscale_img = rgb2gray(img);
    %[w, h] = size(grayscale_img);
    w = 28;
    range = (w * 255)/2;
    features_scaled = [sum(grayscale_img) sum(grayscale_img, 2)'];
    % Normalize to range [-1, 1]
    % Normalization is the same for sum along rows and columns, since
    % images are all square.
    features = (features_scaled - range) / range ;
end

