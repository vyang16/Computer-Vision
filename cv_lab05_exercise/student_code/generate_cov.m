% Generate initial values for the K
% covariance matrices

function cov = generate_cov(d_L, d_a, d_b, K)

cov = zeros(3,3,K);

for k = 1:K
   cov(:,:,k) = [d_L 0 0;0 d_a 0;0 0 d_b];
end

end
