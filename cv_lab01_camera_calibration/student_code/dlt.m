%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xyn: 3xn
% XYZn: 4xn

function [P_normalized] = dlt(xyn, XYZn)
%computes DLT, xy and XYZ should be normalized before calling this function
n = size(xyn, 2); % n == 6
% 1. For each correspondence xi <-> Xi, computes matrix Ai
A = zeros(n*2,12); %12x12
for c = 1:n
    A_i = [-XYZn(:,c)', zeros(1,4), xyn(1, c)*XYZn(:,c)'; zeros(1,4), -XYZn(:,c)', xyn(2,c)*XYZn(:,c)']; %2x12
    A(2*c-1:2*c, :) = A_i;
end

% 2. Compute the Singular Value Decomposition of A
[U,S,V] = svd(A,0);

% 3. Compute P_normalized (=last column of V if D = matrix with positive
P = V(:,end);
% diagonal entries arranged in descending order)
P_normalized = reshape(P,[4,3])';

end
