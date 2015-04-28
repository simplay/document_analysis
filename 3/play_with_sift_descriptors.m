set_name = 'ParzivalDB';
directory = ['Input/data-week2/', set_name, '/lines'];
%directory = ['Input/data-week2/', set_name, '/keywords'];

files = dir([directory, '/*.png']);
filename = files(3).name;
img = single(~imread([directory, '/', filename]))*255;
[w, h] = size(img);
binSize = 20;
magnif = 20;
img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
%[~, descriptors] = vl_dsift(img_smooth, 'size', binSize, 'step', 10);
%[f, d] = vl_sift(img_smooth, 'levels', 4, 'Magnif', 5, 'windowsize', 10, 'verbose');
descriptors_for_each_x_pos = 4;
x_pos = repmat(5:10:h, descriptors_for_each_x_pos, 1);
% Flatten, such that each x position is repeated twice sequentially.
x_pos = x_pos(:)'; 
y_pos = 40:10:70;
scale = repmat(20, 1, descriptors_for_each_x_pos); 
angle = repmat(0, 1, descriptors_for_each_x_pos); 
frames = [x_pos; repmat([y_pos; scale; angle;], 1, ...
    size(x_pos, 2)/descriptors_for_each_x_pos)]; 
[f, d] = vl_sift(img_smooth, 'frames', frames);
%[f, d] = vl_dsift(img_smooth, 'size', binSize, 'step', 20);

%% Show sampled points
imshow(img_smooth);
perm = randperm(size(f,2)) ;
sel = perm(:) ;
h1 = vl_plotframe(f(:,sel)) ;
h2 = vl_plotframe(f(:,sel)) ;
set(h1,'color','k','linewidth',3) ;
set(h2,'color','y','linewidth',2) ;

%% Overlay Descriptors
h3 = vl_plotsiftdescriptor(d(:,sel),f(:,sel)) ;
set(h3,'color','g') ;
