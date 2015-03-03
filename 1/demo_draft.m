%% Initializing stuff.
run('vlfeat-0.9.20/toolbox/vl_setup')
input_name = 'Input/Shapes0.png';
bw_shapes = im2bw(imread(input_name));

%% Detect corners using harris edge detector provided by vlfeat.
nr_corners = [];
shape_nr = 0;
for x=1:100:size(bw_shapes, 1)
    for y=1:100:size(bw_shapes, 2)
        shape_nr = shape_nr + 1;
        shape = bw_shapes(x:x+99, y:y+99);
        size_estimate = sum(shape(:));
        smoothed = vl_imsmooth(double(shape), 1);
        harris = vl_harris(smoothed, 1);        
        corner_idxs = vl_localmax(harris, 0.01, 2);
        %max_img = imregionalmax(imregionalmax(harris), 8);
        nr_corners = [nr_corners, length(corner_idxs)];
    end
end

%% Compile output. 
f = fopen([input_name, '.txt'], 'w');
i = 1;
for c = nr_corners
    fprintf(f, '%d: ', i);
    i = i + 1;
    switch c
        case 0
            fprintf(f, 'circle');
        case 3
            fprintf(f, 'triangle');
        case 4
            fprintf(f, 'square');
        % Could have maaaany corners XD
        case { 5, 6, 7, 8, 9, 10, 11, 12, 13, 14}
            fprintf(f, 'star');
        otherwise
            fprintf(f, 'OMG NO IDEA');
    end
    fprintf(f, '\n');
end
fclose(f);