a_line = imread('dummy_line.png');
a_line = 1 - a_line;
[M, N] = size(a_line);

% word = from to till cursor column indices range
from_cursor = 1;
may_check = true;
min_zero_run_widt = 100;

zero_run_map = zeros(1,N);
counter = 0;
for a=1:N,
    a_line_row = a_line(:, a);
    
    if (sum(a_line_row(:)) < 2)
        zero_run_map(:, a) = 0;
    else
        zero_run_map(:, a) = 1;
    end
    
end
% min pixel dist
dx = 10;
count = 0;
do_check = false;
candidates = {};
t = 1;
for k=1:N,
    col_value = zero_run_map(1, k);
    if (col_value == 1),
        if count >= dx
            finish = k;
            do_check = true;
        else
                   count = 0; 
                   start = k;
        end


    else
      if count == 0
        %start = k;
      end
      count = count + 1; 
    end
    
    if do_check
        if finish - start > dx
            from = {start}; to = {finish};
            candidate = {from, to};
            candidates{t} = candidate;
            t = t + 1;
            disp(['start ', num2str(start), ' finish ' , num2str(finish)]);
        end
        start = finish;
        do_check = false;
    end
    
end

% process/visit candidate indices to extract words
imshow(a_line)
