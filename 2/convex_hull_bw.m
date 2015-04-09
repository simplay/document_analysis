function [ union_convex_bw, x_coords, y_coords ] = convex_hull_bw( bw )
%CONVEX_HULL_BW Takes a bw image and creates a convex hull around all white
%pixels. Returned as a bw image.
% DOES NOT WORK IF THERE IS A HORIZONTAL GAP between the white pixels.
%keyboard;
[row, ~] = find(bw);
row_first = min(row);
row_last = max(row);
x_coords = [];
y_coords = [];
union_convex_bw = zeros(size(bw));

for k = row_first:row_last
    [~, min_curr] = find(bw(k,:), 1, 'first');
    [~, max_curr] = find(bw(k, :), 1, 'last');
    union_convex_bw(k, min_curr:max_curr) = 1;
    x_coords = [min_curr, x_coords, max_curr];
    y_coords = [k, y_coords, k];
end

end

