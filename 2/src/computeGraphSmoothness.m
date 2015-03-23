function [ pairwise ] = computeGraphSmoothness( img, colors )
% a P x P sparse matrix specifiying the graph structure and cost for each
% link between nodes in the graph. Stores the smoothness term in this
% matrix. For each pair of intersecting pixels, this matrix contains the
% penalty if the labels of the pixels do not agree. 
%
% CFO (COLUMN FIRST ORDER)
% For a given image, iterate over each of its column vectors from left to
% the right. I.e. Foreach column vector in the given image, iterate over each of
% the corresponding rows. If the last row has been processed, continue with
% the corresponding successor column vector in the image.
% @param img a color image of size (M x N x 3)
% @param colors all colors in the image - used in order to compute beta.
% @return pairwise: all penalities, in sparse matrix. Its full variant if of size M*N.
%         note that the column idx in the full matrix corresponds to a pixel
%         in the original image img in the column first order. A column
%         contains all the neighborhood penalty information. A particular
%         element in a column exhibits a value != zero, if it is a neighbor to
%         the column idx pixel. the value is the corresponding penalty value.

    % paramters for the penalty term
    beta = getBetaFromColorVar(colors);
    gamma = 20;

    % total number of rows
    M = size(img, 1);

    % total number of columns
    N = size(img, 2);

    % total number of pixels in image
    pixelCount = M*N;

    % a row index corresponds to one particular neighbor pixel to its parent
    rowIdxs = zeros(8*(M-2)*(N-2), 1);

     % a column index corresponds to one particular pixel in the rows-first-order.
    columnIdxs = zeros(8*(M-2)*(N-2), 1);

    % contains all penalty values.
    elementValues = zeros(8*(M-2)*(N-2), 1);

    % thus, we conclude: the k-th row is the k-th pixel in the image in the
    % column-first orders. All corresponding column indices - i.e. the whole
    % column-vector k, are the pixel indices of the k-th pixel's neighbors.

    % Index aggregation index - used for collecting indices.
    index = 0;

    % traverse the pixels in the image column-wise from top to bottom.
    % Note that we do not iterate over the boundary pixels in the image,
    % i.e. we are going to assume that the boundary has value zero.
    % this assumption is viable, since for usual image resultion,
    % the smoothness term won't have any effect anyhow. Splitting excatly at
    % the boundary pixels won't ever happen, since then, there is nothing to
    % split on the other side anyhow.
    % FOREACH PIXEL in the IMAGE 
    % COMPUTE the penalty to its neighbors.
    % Assume that the boundary pixels may be ignored.
    % Iterate column-wise.
    for n=2:(N-1)
        for m=2:(M-1)

            % current pixel value in iteration: visit its 1-Neighborhood.
            img_mn = img(m,n, :);

            % has top left neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m-1,n-1, M);
            dist2 = computeDist2(img_mn, img(m-1,n-1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has left neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m-1,n, M);
            dist2 = computeDist2(img_mn, img(m-1,n, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has bottom left neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m-1,n+1, M);
            dist2 = computeDist2(img_mn, img(m-1,n+1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has top neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m,n-1, M);
            dist2 = computeDist2(img_mn, img(m,n-1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has bottom neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m,n+1, M);
            dist2 = computeDist2(img_mn, img(m,n+1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has top right neighbor
            index = index+1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m+1,n-1, M);
            dist2 = computeDist2(img_mn, img(m+1,n-1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has right neighbor
            index = index + 1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m+1,n, M);
            dist2 = computeDist2(img_mn, img(m+1,n, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

            % has top bottom right neighbor
            index = index+1;
            columnIdxs(index) = pixelIdxRFO(m,n, M);
            rowIdxs(index) = pixelIdxRFO(m+1,n+1, M);
            dist2 = computeDist2(img_mn, img(m+1,n+1, :));
            elementValues(index) = penaltyTerm(beta, gamma, dist2);

        end
    end

    % create the sparse matrix pairwise
    pairwise = sparse(rowIdxs, columnIdxs, elementValues, pixelCount, pixelCount);

end


function pixelIDX = pixelIdxRFO(m,n, M)
% CFO = Column FIRST ORDER
% compute pixel index when iteration over image in the following order:
% fix a certain column, then iterate over each rows, i.e. process all
% elements of a column vector.
% @param m row idx of pixel in image
% @param n column idx of pixel in image
% @param M number of rows in image
% @return pixel index in CFO pixelvector.
    pixelIDX = m + M*(n-1);

end

function dist2 = computeDist2(a, b)
% @param a base pixel
% @param b neighbor pixel
% @return compute squared distances of two given pixels
    c = (a-b).^2;
    dist2 = sqrt(sum(c(:)));
end

function beta = getBetaFromColorVar(colors)
% @returns beta one half oth the color variance of the whole image
    avg = sum(colors,2)/size(colors,2);
    beta = sum(sum( (colors-repmat(avg,1,size(colors,2))).* ...
           (colors-repmat(avg,1,size(colors,2))) )) / size(colors,2);
    beta = 1/(2*beta);
end

function penalty = penaltyTerm(beta, gamma, distSqrd)
%   compute the penalty if the labels of the pixels do not agree.
%   @param beta penalty paramter real number. Hlaf of color variance over
%   whole image.
%   @param gamma penalty paramter real number balance contribution of the
%   data and smoothness term.
%   @param distSqrd ||c_p - c_q||^2 for color indices p and neighbor q.
%   @param penalty.
    penalty = gamma*exp(-beta*distSqrd);
end

