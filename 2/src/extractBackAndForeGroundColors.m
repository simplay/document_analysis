function [ fcolors, bcolors, colors ] = extractBackAndForeGroundColors( img, fmask, bmask )
%EXTRACTBACKANDFOREGROUNDCOLORS separates fore-and background of a given
%image using a foreground and background masl
%   @param img image to separate of resolution (m x n x 3)
%   @param fmask boolean matrix separating foreground from the given img.
%   @param bmask boolean matrix separating background from the given img.
%   @return fcolors pixels from image that belong to the foreground.
%   @return bcolors pixels from image that belong to the background.
%   @return colors all colors of given image as a  3 x (#pixels) array.
    
    % get all pixel colors in a 3 x (#pixels) array
    colors = reshape(shiftdim(img,2),3,size(img,1)*size(img,2));
    
    % get all pixel coordinates in a 2 x (#pixels) array
    x = zeros(size(img,1), size(img,2), 2);
    [x(:,:,1), x(:,:,2)] = meshgrid(1:size(img, 2), 1:size(img, 1));
    x = reshape(shiftdim(x, 2), 2, size(img, 1)*size(img, 2));
    
    % get the foreground and the background masks in a 1 x (#pixels) array.
    fmask = reshape(fmask, 1, size(img,1)*size(img,2));
    bmask = reshape(bmask, 1, size(img,1)*size(img,2));
    
    % get the indices of the foreground and the background pixels.
    [~, ~, findicess] = intersect(x', (x.*[fmask; fmask])', 'rows');
    [~, ~, bindicess] = intersect(x', (x.*[bmask; bmask])', 'rows');

    % extract only labeled foreground and background pixels
    fcolors = colors(:,findicess);
    bcolors = colors(:,bindicess);
    
end

