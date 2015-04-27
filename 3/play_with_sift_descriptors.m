set_name = 'ParzivalDB';
words_directory = ['Input/data-week2/', set_name, '/lines'];

files = dir([words_directory, '/*.png']);
filename = files(1).name;
img = single(~imread([words_directory, '/', filename]))*255;
binSize = 20;
magnif = 20;
img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
%[~, descriptors] = vl_dsift(img_smooth, 'size', binSize, 'step', 10);
%[f, d] = vl_sift(img_smooth, 'levels', 4, 'Magnif', 5, 'windowsize', 10, 'verbose');
[f, d] = vl_dsift(img_smooth, 'size', binSize, 'step', 20);

%% Show sampled points
imshow(img_smooth);
perm = randperm(size(f,2)) ;
sel = perm(:) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

%% Overlay Descriptors
%h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
%set(h3,'color','g') ;
