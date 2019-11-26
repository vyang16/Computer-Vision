function X_sampled = get_sample(X, n)
N=size(X, 1);
if(N < n)
    X_sampled = X;
else
    index = randperm(N);
    %ensure the points are distant to each other by choosing the n ones
    %with max distance
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
        %remove one of the indexes ( here its the first one )
        index(find(index == row)) = [];
    end
    X_sampled = X(index, :);
end