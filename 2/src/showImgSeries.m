function showImgSeries(figureTitle, imgs, labels)
%SHOWIMGSERIES Display Subfigure series of a series of images with labels.
%   @param figrueTitle string
%   @param imgs a (m x n x 3 x k) tensor storing 
%          k (m x n) color images (i.e. they have 3 color channels).
%          assumption: all images have same dimensionality.
%   @param labels a cell-grid storing k subfigure label titles (strings).
    figure('Position', [100, 100, 1024, 800], ...
           'name', figureTitle)
       
    % display subfigures using provided data.   
    for k=1:size(imgs,4),
        g = subplot(1,size(imgs,4), k);
        subimage(imgs(:,:,:,k))
        fig_title = char(labels(k));
        xlabelHandler = get(g,'XLabel');
        set( xlabelHandler, 'String', fig_title); 
        set(gca,'xtick',[],'ytick',[]); 
    end

end

