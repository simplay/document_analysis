function [line_img ] = scanline_approach(img)     
    % white = fg.
    sum_rows = sum(img, 1);
    sum_columns = sum(img, 2);

    % Convert to binary by thresholding sum values according to mean. 
    threshold_factor_rows = -1;
    threshold_factor_cols = 0.4;
    binary_rows = sum_rows > mean(sum_rows)*threshold_factor_rows;
    binary_columns = sum_columns > mean(sum_columns)*threshold_factor_cols;
    
    %% Kill smaller runs of 1, set them to 0
    binary_columns =  eliminate_runs(binary_columns, 1, 5);
    binary_columns = eliminate_runs(binary_columns, 0, 5);

    %% Turn into masks
    row_binary_img = repmat(binary_rows, [size(img, 1), 1]);
    col_binary_img = repmat(binary_columns, [1, size(img, 2)]);
    line_img =  row_binary_img & col_binary_img;
end 