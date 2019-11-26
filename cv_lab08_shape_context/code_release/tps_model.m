function [w_x w_y E] = tps_model(X,Y,lambda)
    n = size(X, 1);
    K = U(sqrt(dist2(X,X))); 
    P = [ones(n,1) X];
    A = [K+lambda*eye(n) P; P' zeros(3)];
    vx = Y(:, 1);
    vy = Y(:, 2);
    w_x = A \ [vx; zeros(3,1)];
    w_y = A \ [vy; zeros(3,1)];
    
    ax = w_x(end-2:end);
    ay = w_y(end-2:end);

    E_x = w_x(1:n)'*K*w_x(1:n);
    E_y = w_y(1:n)'*K*w_y(1:n);
    E = E_x + E_y;
end


function u = U(t)
    u = t.^2 .* log(t.^2);
    u(isnan(u)) = 0;
end