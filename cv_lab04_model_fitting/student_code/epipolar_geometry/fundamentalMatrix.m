% Compute the fundamental matrix using the eight point algorithm
% Input
% 	x1s, x2s 	Point correspondences 3xN
%
% Output
% 	Fh 		Fundamental matrix with the det F = 0 constraint
% 	F 		Initial fundamental matrix obtained from the eight point algorithm
%
function [Fh, F] = fundamentalMatrix(x1s, x2s)
    N = size(x1s,2); % number of pairs of points, need at least 8
    %normalize x1s and x2s
    [x1s_norm, T1] = normalizePoints2d(x1s);
    [x2s_norm, T2] = normalizePoints2d(x2s);


    %build A matrix Nx9 maxtrix
    A = zeros(N, 9);
    for i = 1:N
       x1 = x1s_norm(1,i); 
       x2 = x2s_norm(1,i);
       y1 = x1s_norm(2,i);
       y2 = x2s_norm(2,i);
       A(i, :) = [x1*x2,x1*y2,x1,y1*x2,y1*y2,y1,x2,y2,1]; 
    end
    
    [~,~,V] = svd(A);
    P = V(:,end);
    E = reshape(P, [3,3])';
    
    [U,S,V] = svd(E);
    S(3,3) =  0; %enforce determinant to be zero
    
    Eh = U*S*V';
 
    F = T2'*E*T1;
    Fh = T2'*Eh*T1;
    
end