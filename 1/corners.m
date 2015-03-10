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
% @param radius Integer window base radius (usually 1).
% @return rowIdxs array of row indices in image of maxima (corner)
% @return columnIdxs array of column indices in image of maxima (corner)
% @return response, the response of the corner detector on the given image.
function [rowIdxs, columnIdxs, response] = corners(img, sigma, lowerBound, radius)
    
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

    % neithborhood window size - common assumption twice radius recentered (+1).
	windowLength = (2*radius+1);
	
    % visit a windowLength^2 in R and find max in this neighborhood. 
    % replace set at each pixel location the found max. neighborhood value.
    % i.e. the nonmax supression
    localMaxima = ordfilt2(R, windowLength^2, ones(windowLength));
    
    % consider only max. values that are bigger than a given minimal
    % threshold boundary. I.e. count only real maxima. Find indices of
    % significant local maxima.
	[rowIdxs, columnIdxs] = find((R==localMaxima)&(R>lowerBound));   
end
	