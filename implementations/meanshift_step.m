function [dx, dy] = meanshift_step(w, mx, my)
% INPUT:
% w: matrix of weights
% mx: matrix of x indexes from negative to positive [-2 -1 0 1 2]
% my: matrix of y indexes from negative to positive [-2 -1 0 1 2]
% OUTPUT:
% dx: change in direction of x
% dy: change in direction of y

    % calculate next position
    dx = 0;
    dy = 0;
    sw = sum(w, 'all');
    if sw ~= 0
        dx = sum(mx .* w, 'all') / sw;
        dy = sum(my .* w, 'all') / sw;
    end                
end