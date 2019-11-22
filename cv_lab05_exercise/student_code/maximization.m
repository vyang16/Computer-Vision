function [mu, var, alpha] = maximization(I, X)
% I is LxK
% X is Lx3

K = size(I,2); 
L = size(X,1);
N = size(X,2);

alpha = zeros(1, K);
mu = zeros(K, N);
var = zeros(N, N, K);

for k = 1:K
    sumI = sum(I(:,k));
    alpha(k) = sumI/L;
    mu(k,:) = sum(X.*repmat(I(:,k), [1,3]))/sumI;
    for l = 1:L
       var(:,:,k) = var(:,:,k)+ I(l,k)*((X(l,:)-mu(k,:))'*(X(l,:)-mu(k,:)));
    end
    var(:,:,k) = var(:,:,k)/sumI;
end
alpha = alpha / sum(alpha);
end