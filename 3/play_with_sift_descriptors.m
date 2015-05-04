set_name = 'ParzivalDB';
%directory = ['Input/data-week2/', set_name, '/lines'];
directory = ['Input/data-week2/', set_name, '/keywords'];

files = dir([directory, '/*.png']);
filename = files(4).name;
img = single(~imread([directory, '/', filename]))*255;
[w, h] = size(img);
binSize = 20;
magnif = 20;
img_smooth = vl_imsmooth(img, sqrt((binSize/magnif)^2 - .25));
%[~, descriptors] = vl_dsift(img_smooth, 'size', binSize, 'step', 10);
%[f, d] = vl_sift(img_smooth, 'levels', 4, 'Magnif', 5, 'windowsize', 10, 'verbose');
descriptors_per_x_pos = 4;
x_pos = repmat(5:10:h, descriptors_per_x_pos, 1);
% Flatten, such that each x position is repeated twice sequentially.
x_pos = x_pos(:)'; 
% 4 different positions
y_pos = repmat(40:15:85, 1, descriptors_per_x_pos/4);
scale = repmat(20, 1, descriptors_per_x_pos); 
% 5 different angles
%angle = repmat([-0.1 0.05, 0, 0.05, 0.1], 1, descriptors_per_x_pos/5); 
angle = repmat(0, 1, descriptors_per_x_pos);
frames = [x_pos; repmat([y_pos; scale; angle;], 1, ...
    size(x_pos, 2)/descriptors_per_x_pos)]; 
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


%% Visualization of grid points only
imshow(img_smooth);
hold on
scatter(f(1,:), f(2,:), 'r');
hold off