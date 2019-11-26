function C = chi2_cost(s1,s2)
%compute chi2 distance/cost for every pair cells in s1 and s2

n = size(s1, 1);
m = size(s2, 1);
C = zeros(n,m);

for i = 1:n
    for j = 1:m
        %make histogram matrix to column vector
        C(i,j) = chi2_cost_vector(s1{i}(:), s2{j}(:));
    end
end

%handle dimensions (without sampling)
if(n < m)
    C = C(1:n, 1:n);    
elseif(n > m)
    C = C(1:m, 1:m);
end

end

%add eps to avoid division by zero
function c = chi2_cost_vector(s1, s2)
    c = sum(((s1 - s2).^2)./((s1+s2)+eps))/2;
end