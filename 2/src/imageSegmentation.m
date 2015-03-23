function imageSegmentation( img )
%IMAGESEGMENTATION Summary of this function goes here
%   @param img


% get fore-and background separating masks.
[fmask, bmask] = selectionForeAndBackground(img);
%%
FM = mat2Img(fmask(:,:), fmask(:,:), fmask(:,:));
BM = mat2Img(bmask(:,:), bmask(:,:), bmask(:,:));

title = 'Foreground (left) and background mask(right)';
labels = {'Foreground Mask' 'Background Mask'};
imgs = zeros(size(fmask,1), size(fmask,2), 3, 2);

imgs(:,:,:,1) = FM(:,:,:);
imgs(:,:,:,2) = BM(:,:,:);

showImgSeries(title, imgs, labels);
clc

% extract fore-and background colors from masked selection
[fcolors, bcolors, colors] = extractBackAndForeGroundColors(img, fmask, bmask);

% Fit a Gaussian mixture distribution (gmm) to data: foreground an background
componentCount = 2;
gmmForeground = fitgmdist(fcolors', componentCount);
gmmBackground = fitgmdist(bcolors', componentCount);
    
figure('name', 'Mean Foreground Colors');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    foregroundMeanColor = reshape(gmmForeground.mu(k,:,:),1,1,3);
    imshow(imresize(foregroundMeanColor, [150,150]));
end
    
figure('name', 'Mean Background Colors');
for k = 1:componentCount,
    subplot(1,componentCount, k);
    backgroundMeanColor = reshape(gmmBackground.mu(k,:,:),1,1,3);
    imshow(imresize(backgroundMeanColor, [150,150]));
end

% Calculate probability density functions
foregroundPDF = pdf(gmmForeground, colors');
backgroundPDF = pdf(gmmBackground, colors');

figure('name', 'Probability pixel belongs to foreground (brigther means higher probability)');
density = reshape(foregroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);

figure('name', 'Probability pixel belongs to background (brigther means higher probability)');
density = reshape(backgroundPDF, size(img,1), size(img,2));
density = mat2normalied(density);
imshow(density);

% Task 2.3
% 1 x N vector specifies the initial labels of each of the N nodes in the
% graph. Initially, it is supposed to be equal zero. 
% N is the number of pixels in the image.
class = zeros(size(img,1)*size(img,2), 1);

% A CxN matrix specifying the potentials (data term) for each of the C
% possible classes at each of the N nodes.
unary = computeClassPotentials(fmask, bmask, foregroundPDF, backgroundPDF);

% A NxN sparse matrix sparse matrix specifiying the graph structure and
% cost for each link between nodes in the graph.
pairwise = computeGraphSmoothness(img, colors);

% A CxC matrix specifiying the label cost for the labels of each adjacent
% node in the graph.
labelcost = [0,1; 1,0];

% A 0-1 flag which determines if the swapof expansion method is used to
% solve the minimization. 0 == swap, 1 == expansion.
expansion = 0;

% [LABELS ENERGY ENERGYAFTER] = GCMex(CLASS, UNARY, PAIRWISE, LABELCOST,EXPANSION)
[labels, ~, ~] = GCMex(class, single(unary), pairwise, single(labelcost), expansion);


% Compute smoothness of each pixel: 1 x N array
smoothnessEachPixel = sum(pairwise);

% make a full matrix and reshape to image resolution
smoothness = reshape(full(smoothnessEachPixel), size(img,1), size(img,2));
smoothness = mat2normalied(smoothness);
figure('name', 'smoothness term');
imshow(smoothness);

% Visualize min cut, i.e. image segmenation.
backgroundLabels = reshape(labels, size(img, 1), size(img, 2));
backgroundLabels = repmat(backgroundLabels, 1, 1, 3);
foregroundLabels = 1-backgroundLabels;

figure('name', 'Foreground (left) and Background (right)');
subplot(1,2, 1);
imshow(img .* foregroundLabels);

subplot(1,2, 2);
imshow(img .* backgroundLabels);

end

