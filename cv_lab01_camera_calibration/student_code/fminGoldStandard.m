%% !!! DO NOT CHANGE THE FUNCTION INTERFACE, OTHERWISE, YOU MAY GET 0 POINT !!! %%
% xy_normalized: 3xn
% XYZ_normalized: 4xn

function f = fminGoldStandard(pn, xy_normalized, XYZ_normalized)
n = size(xy_normalized, 2);
%reassemble P
P = [pn(1:4);pn(5:8);pn(9:12)];

%compute reprojection error 
xy_new = P*XYZ_normalized;
xy_new_normalized = xy_new./xy_new(3,:); % normalization

diff = xy_new_normalized - xy_normalized;

%throw away last row
diff = diff(1:end-1, :);

errorx = sum(diff(1).^2);
errory = sum(diff(2).^2);
%errors = sum()/size(xy_normalized,2);

%compute cost function value
f = sum(diag(diff'*diff));
end