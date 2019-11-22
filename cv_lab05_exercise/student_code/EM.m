function [map cluster] = EM(img)

img = double(img);
[a b n] = size(img);
L = a*b;
X = reshape(img, [L n]);

%number of clusters
K = 3;

alpha = ones(1, K)/K;

%compute boundaries
L_min = min(X(:,1));
a_min = min(X(:,2));
b_min = min(X(:,3));

delta_L = max(X(:,1)) - min(X(:,1));
delta_a = max(X(:,2)) - min(X(:,1));
delta_b = max(X(:,3)) - min(X(:,3));

% use function generate_mu to initialize mus
mu = generate_mu(L_min, a_min, b_min, delta_L, delta_a, delta_b, K);
% use function generate_cov to initialize covariances
cov = generate_cov(delta_L, delta_a, delta_b, K);
% iterate between maximization and expectation
tol = 1;
diff_mu = tol + 1;
iter = 0;

%EM step
while diff_mu > tol
    fprintf("iteration %d  with diff_mu = %d \n", iter, diff_mu);
    % use function expectation
    I = expectation(mu, cov, alpha, X);
    
    % use function maximization
    [mu_new, cov_new, alpha_new] = maximization(I, X);
    
    diff_mu = norm(mu_new(:)-mu(:)); %mu is Kx3, make it one column
    
    mu = mu_new;
    cov = cov_new;
    alpha = alpha_new;
    
    iter = iter + 1;
end

[~, index] = max(I, [], 2);


map = reshape(index, [a b]); %reshape into 2D format
cluster = mu; %what to put in cluster?

mu
cov
alpha

end