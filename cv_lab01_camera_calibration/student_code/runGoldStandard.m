%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy: size 2xn
% XYZ: size 3xn 

function [P, K, R, t, error] = runGoldStandard(xy, XYZ)
n = size(xy, 2);
%normalize data points
[xy_normalized, XYZ_normalized, T, U] = normalization(xy, XYZ);

%compute DLT with normalized coordinates
[P_normalized] = dlt(xy_normalized, XYZ_normalized);

%minimize geometric error to refine P_normalized
pn = [P_normalized(1,:) P_normalized(2,:) P_normalized(3,:)];
for i=1:20
    [pn] = fminsearch(@fminGoldStandard, pn, [], xy_normalized, XYZ_normalized);
end
P_normalized = reshape(pn, 4, 3)';
%denormalize projection matrix
P = inv(T)*P_normalized*U;
%factorize prokection matrix into K, R and t
[K, R, t] = decompose(P);

%compute average reprojection error
error = 0;
xy_new = P*[XYZ; ones(1,n)];
xy_new_normalized = xy_new./xy_new(3,:);
xy_new_normalized = xy_new_normalized(1:end-1, :);
diff = xy_new_normalized - xy;

error = sum(diag(diff'*diff))/n;
end