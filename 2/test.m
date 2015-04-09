bw_smooth = ~im2bw(smoothness);
[labeled_font_components, num_font_components] = bwlabel(bw_smooth);

[labeled_rows, num_rows] = bwlabel(imresize(line_img, 0.2));
%% Compute convex hull manually
hulls = false(size(labeled_rows));
f = fopen('test.txt', 'w');
written_rows = 0;
for i = 1:num_rows
    current_row = labeled_rows == i;
    current_row_font_components = false(size(current_row));
    for j = 1:num_font_components
        jth_font_component = labeled_font_components == j;
        if sum(reshape(current_row & jth_font_component, 1, [])) > 5
            current_row_font_components = ...
                current_row_font_components | jth_font_component;
        end
    end
    if sum(current_row_font_components(:)) < 100
        continue;
    end
    [convex_hull, x_convex, y_convex] = ...
        convex_hull_bw(current_row_font_components);
    output_vector = reshape([x_convex; y_convex], 1, []);
    hulls = hulls | convex_hull;
    fprintf(f, '%d,', i, output_vector(1:end-1));
    fprintf(f, '%d', i, output_vector(end));
    fprintf(f, '\n');
    written_rows = written_rows + 1;
end
disp(written_rows);
fclose(f);
%% vis
vis = double(hulls);
vis(:,:,2) = bw_smooth;
vis(:,:,3) = labeled_rows;
imshow(vis);
%%
hold on
plot(x_convex, y_convex, 'g');
