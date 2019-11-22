%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%

function [K, R, t] = decompose(P)
%Decompose P into K, R and t using QR decomposition
 M = P(:,1:3); %3x3
 N = P(:, 4); % -KRC %3x1


% Compute R, K with QR decomposition such M=K*R 
[R_i,K_i] = qr(inv(M));
R = inv(R_i);
K = inv(K_i);

% Compute camera center C=(cx,cy,cz) such P*C=0 
C = -inv(M)*N;
% normalize K such K(3,3)=1
K = K./K(3,3);

% Adjust matrices R and Q so that the diagonal elements of K = intrinsic matrix are non-negative values and R = rotation matrix = orthogonal has det(R)=1

% Compute translation t=-R*C
t = -R*C;
end