function [w_x w_y E] = tps_model(X,Y,lambda)
    


    E_x = w_x'*K*w_x;
    E_y = w_y'*K*w_y;

end