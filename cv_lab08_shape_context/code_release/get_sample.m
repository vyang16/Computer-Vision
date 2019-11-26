function X_sampled = get_sample(X, n)
N=size(X, 1);
if(N < n)
    X_sampled = X;
else
    %ensure the points are distant to each other deleting the point with
    %closest distance to another point
    index = randperm(N);
    dist = dist2(X, X);
    dist = dist + diag(Inf*ones(N,1) - diag(dist)); %set distances to self high
    
    while length(index) > n
        %remove the point that has the smallest distance in distance
        %matrix. 
        [col_min, idx] = min(dist);
        [~, col] = min(col_min);
        row = idx(col);
        %set this to high, dist is symmetric
        dist(row, :) = ones(1,N)*Inf;
        dist(:, row) = ones(N,1)*Inf;
        %remove one of the indexes (here its the row index)
        index(find(index == row)) = [];
    end
    X_sampled = X(index, :);
end