function [ array ] = eliminate_runs(array, run_number, run_length)
% Removes runs of a given number (run_number) that are smaller than the
% given run length from the given array.
    idxs = find(array == 1 - run_number);
    for i = 2:length(idxs)
        count = idxs(i) - idxs(i-1) - 1;
        if (count == 0 || count > run_length)
            continue;
        else
            array(idxs(i-1):idxs(i)) = 0;
        end
    end
end

