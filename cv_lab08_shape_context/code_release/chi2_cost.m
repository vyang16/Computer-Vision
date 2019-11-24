function C = chi2_cost(s1,s2)
%compute chi2 distance/cost for every pair of columns of s1 and s2
n = size(s1, 2);
m = size(s2, 2);
C = zeros(n,m);

for i = 1:n
    for j = 1:m
        C(i,j) = chi2_cost_vector(s1(:, i), s2(:, j));
    end
end

end

function c = chi2_cost_vector(s1, s2)
    c = sum(((s1 - s2).^2)./(s1+s2))/2;
end