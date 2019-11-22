function [map peak] = mean_shift(X, r)

L = size(X, 1);
map = zeros(1, L);
peak = [];

for i = 1:L
    cur_peak = find_peak(X, X(i, :), r);
    
    if(i == 1)
       % create map, add new peak
       peak = cur_peak;
       map(i) = size(peak, 1);
    else
        % check if we can merge peaks
        found = 0;
        for j= 1:size(peak)
            dist = norm(peak(j, :) - cur_peak);
            %dist
            if(dist < r/2)
                %found, just take old index
                map(i) = j;
                found = 1;
                break;
            end
        end
        %not found, add new peak to list
        if(found == 0)
            peak = [peak; cur_peak];
            map(i) = size(peak, 1);
        end
    end
end 