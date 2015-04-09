bw_smooth = ~im2bw(smoothness);
[labeled, num] = bwlabel(bw_smooth);
imshow(labeled);
imshow(labeled == 1);

[labeled_rows, num_rows] = bwlabel(imresize(line_img, 0.2));

%% Compute convex hull manually
f = fopen('test.txt', 'w');
for i = 1:num_rows
    current_row = labeled_rows == i & labeled;
    if sum(current_row(:)) < 100
        continue;
    end
    [convex_hull, x_convex, y_convex] = convex_hull_bw(current_row);
    output_vector = reshape([x_convex; y_convex], 1, []);
    if length(output_vector) < 2
        imshow(convex_hull);
        continue;
    end
    fprintf(f, '%d,', i, output_vector(1:end-1));
    fprintf(f, '%d', i, output_vector(end));
    fprintf(f, '\n');
end
fclose(f);
%% vis
[own_convex, x_convex, y_convex] = convex_hull_bw(current_row);
vis = own_convex;
vis(:,:,2) = current_row;
vis(:,:,3) = bwconvhull(current_row);
imshow(vis);
hold on
plot(x_convex, y_convex, 'g');
