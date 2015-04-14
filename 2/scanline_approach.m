function [line_img ] = scanline_approach(img)   
    %% Make profile analysis
    % white = fg.
    sum_rows = sum(img, 1);
    sum_columns = sum(img, 2);
    sum_rows_normed = sum_rows/max(sum_rows);
    sum_columns_normed = sum_columns/max(sum_columns);
    [h, centers] = hist(sum_columns_normed(sum_columns_normed > 0.01 & sum_columns_normed < 0.5));
    h_grad = h(1:end - 1) - h(2:end);
    [~, max_grad_idx] = max(h_grad);
    threshold_factor_cols = centers(max_grad_idx + 1);
    % Convert to binary by thresholding.
    % (rows are ignored bc of threshold 0)
    threshold_factor_rows = 0;
    binary_rows = sum_rows_normed >= threshold_factor_rows;
    binary_columns = sum_columns_normed >= threshold_factor_cols;
    
    %% Kill smaller runs of 1, set them to 0
    binary_columns =  eliminate_runs(binary_columns, 1, 4);
    binary_columns = eliminate_runs(binary_columns, 0, 4);

    %% Turn into masks
    row_binary_img = repmat(binary_rows, [size(img, 1), 1]);
    col_binary_img = repmat(binary_columns, [1, size(img, 2)]);
    line_img =  row_binary_img & col_binary_img;
end 