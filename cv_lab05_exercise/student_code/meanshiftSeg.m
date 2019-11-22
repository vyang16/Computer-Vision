function [map peak] = meanshiftSeg(img)

[a b n] = size(img);
L = a*b;
r = 30;

%generate density function X

X = reshape(double(img), [L n]) ;
map = zeros(1, L);


[map peak] = mean_shift(X, r);

map = reshape(map, [a b]);
end