function [ union_convex_bw ] = convex_hull_bw( bw )
%CONVEX_HULL_BW Takes a bw image and creates a convex hull around all white
%pixels. Returned as a bw image.
% DOES NOT WORK IF THERE IS A HORIZONTAL GAP between the white pixels.

[row, ~] = find(bw, 1, 'first');
[row_last, ~] = find(bw, 1, 'last');

union_convex_bw = zeros(size(bw));
for k = row:row_last
    [~, min_curr] = find(bw(k,:), 1, 'first');
    [~, max_curr] = find(bw(k, :), 1, 'last');
    union_convex_bw(k, min_curr:max_curr) = 1;
end

end

