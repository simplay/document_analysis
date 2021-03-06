% Harris Corner Detection Algorithm:
%   steps:
%   1. Compute Image gradients using a Sobel Kernel
%   2. Smooth results
%        Sx2 = g * Ix.^2
%        Sy2 = g * Iy.^2
%        Sxy = g * Ix.*Iy
%   3. H(x,y) = [Ix^2 Ix*Iy; Ix*Iy Iy^2]
%   R = det(H) - k tr^2(H)
%   threshold on value of R
%   Compute nonmax suppression
%
% implementation is based on theory from 
%   www.cse.psu.edu/~rcollins/CSE486/lecture06.pdf
%
% @param img given image we want to detect corner 100x100 in our case.
% @param sigma std usually equal 1.
% @param lowerBound float. a corner candidate must be bigger than this
% bound. Only significant maximal values should be identified as an corner.
% @param minBlobSizeFactor float in [0, 1]. Only maxima with a certain
% extension are valid as corners. This threshold is minBlobSizeFactor *
% mean(blobsize). To count all blobs as corners, set this to 0.
% @param radius Integer window base radius (usually 1).
% @return rowIdxs array of row indices in image of maxima (corner)
% @return columnIdxs array of column indices in image of maxima (corner)
% @return response, the response of the corner detector on the given image.
function [rowIdxs, columnIdxs, response] = corners(img, sigma, lowerBound, radius, minBlobSizeFactor)
    
    % sobel derivative kernel
    dx = [-1 0 1; -1 0 1; -1 0 1]; 
    dy = dx';
    
    % Image derivatives
    Ix = conv2(img, dx, 'same');    
    Iy = conv2(img, dy, 'same');    

    % Gaussian filter of size 6*sigma (since std +/- 3sigma ~99.99%)
    % fix(...) => round to nearest integer.
    g = fspecial('gaussian', max(1,fix(6*sigma)), sigma);
    
    % Smoothed squared image derivatives
    Sx2 = conv2(Ix.^2, g, 'same'); 
    Sy2 = conv2(Iy.^2, g, 'same');
    Sxy = conv2(Ix.*Iy, g, 'same');
    
    % found by testing.
    k=0.06;
    
    % response of detector: det(H) - k(trace(H)^2)
    response = (Sx2.*Sy2 - Sxy.^2) - k*(Sx2 + Sy2).^2;
    
    rowIdxs = [];
    
    % Alternative way for finding regional max that is more resistant
    % against 'double-peaks' by rejecting maximas that are only extending
    % over a small neighbourhood.
    d = strel('disk', 1);
    response2 = imdilate(response, d);
    [~, ~, size_components] = connectedComponents(im2bw(response2, lowerBound));
    minBlobSize = max(mean(size_components) * minBlobSizeFactor, 2);
    nr_big_components = sum(size_components > minBlobSize);
    
    % Make result compatible with old output.
    columnIdxs = zeros(1, nr_big_components);
end
	