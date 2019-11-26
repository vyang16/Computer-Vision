function d = sc_compute(X,nbBins_theta,nbBins_r,smallest_r,biggest_r)
% X is nx2
n = size(X, 1);
d = cell(n,1);
theta = linspace(-pi, pi, nbBins_theta);
%log scale for r
r = linspace(log(smallest_r), log(biggest_r), nbBins_r);
distances = dist2(X, X);
meanDistance = mean2(sqrt(distances)); %normalization for scale invariance

for p = 1:n
   px = X(p, :);
   %compute distance to all 
   dist_vec = repmat(px, size(X,1), 1) - X;
   dist_vec(p, :) = [];
   [TH, R]= cart2pol(dist_vec(:,1), dist_vec(:,2));
   %save histogram to cell
   d{p} = hist3([TH log(R/meanDistance)], 'Edges', {theta r});
end

end