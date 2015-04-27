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
%%
access_index_set = {};
access_index_set{1} = {{1},{candidates{1}{1}{1} } };
disp(['s: ', num2str(1), ' e: ', num2str(candidates{1}{1}{1}) ])
tt = 2;
for k=1:length(candidates)-1,
    first = 1;
    second = 2;
    end_idx = candidates{k+1}{first}{1};
    start_idx = candidates{k}{second}{1};
    access_index_set{tt} = {{start_idx},{end_idx}};
    disp(['s: ', num2str(start_idx), ' e: ', num2str(end_idx) ])
end

for k=1:length(access_index_set),
    figure
    index_set = access_index_set{k};
    fro = index_set{1}{1};
    till = index_set{2}{1};
    imshow(a_line(:,fro:till));
end


% process/visit candidate indices to extract words
imshow(a_line(:,1:candidates{1}{1}{1}))
