% Normalization of 2d-pts
% Inputs: 
%           xs = 2d points
% Outputs:
%           nxs = normalized points
%           T = 3x3 normalization matrix
%               (s.t. nx=T*x when x is in homogenous coords)
function [nxs, T] = normalizePoints2d(xs)
N = size(xs);
for i=1:N
    xs(:,i) = xs(:,i) * (1/xs(3,i));
end

m = mean(xs,2);

xs_star = xs - m;

sum_s_xs_star = sum(xs_star.^2,2);
sigma = sqrt(N./sum_s_xs_star);

T = [sigma(1) 0 -1*sigma(1)*m(1);
     0 sigma(2) -1*sigma(2)*m(2);
     0 0 1];
 
nxs = T*xs;
end
