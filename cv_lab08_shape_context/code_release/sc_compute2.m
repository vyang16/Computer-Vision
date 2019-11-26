function d = sc_compute2(X,nbBins_theta,nbBins_r,smallest_r,biggest_r,n)
% computes the shape context descriptors for a set of point
% Output:
%   - d the shape context descriptor for all input points
% Inputs:
%   - X the set of points
%   - nbBins_theta the number of bins in the angular dimension
%   - nbBins_r the number of bins in the radial dimension
%   - smallest_r the length of the smallest radius
%   - biggest_r the length of the biggest radius

X = X';
d = cell(n,1);                  % shape context descriptors
norm = mean2(sqrt(dist2(X,X))); % normalizing value

minr = log(smallest_r);
maxr = log(biggest_r);
dr = (maxr-minr)/nbBins_r;
r = linspace(minr,maxr-dr,nbBins_r);

dtheta = 2*pi/nbBins_theta;
theta = linspace(0,2*pi-dtheta,nbBins_theta);

% for each point
for i=1:n
    % store current pixel in curr_pt
    curr_pt = zeros(1,2);
    curr_pt = X(i,:);
    
    % calculate distance from curr_pt to all other points of X
    % X_dist has size 1xm, where m is equal to num-1
    X_repcurr = repmat(curr_pt,size(X,1),1);
    vec = X_repcurr - X;
    vec(i,:) = [];
    
    [X_theta,X_r] = cart2pol(vec(:,1),vec(:,2));
    distr = [X_theta log(X_r/norm)];
    d{i} = hist3(distr,'Edges',{theta, r});
end
end