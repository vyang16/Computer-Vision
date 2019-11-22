%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runDLT(xy, XYZ)
n = size(xy,2);
% normalize 
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[Pn] = dlt(xy_normalized, XYZ_normalized);

%denormalize projection matrix
P = inv(T)*Pn*U;
%factorize projection matrix into K, R and t
[K, R, t] = decompose(P);   

%compute average reprojection error
%reprojection error = sum((xy_new - xy)^2);

xy_new = P*[XYZ; ones(1,n)];
xy_new_normalized = xy_new./xy_new(3,:);
xy_new_normalized = xy_new_normalized(1:end-1, :);
diff = xy_new_normalized - xy;

error = sum(diag(diff'*diff))/n;
end
 