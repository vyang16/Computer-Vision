% Generate initial values for mu
% K is the number of segments

function mu = generate_mu(L_min, a_min, b_min, d_L, d_a, d_b, K)

mu = zeros(K, 3);

for k = 1:K
   l = L_min + d_L * rand;
   a = a_min + d_a * rand;
   b = b_min + d_b * rand;
   mu(k, :) = [l, a, b];
end

end