function [dx, dy] = meanshift_step(w, mx, my)
    
    % current position in the center
    x_c = round(size(w, 2)/2);
    y_c = round(size(w, 1)/2);

    % calculate next position
    x_n = x_c;
    y_n = y_c;
    sw = sum(w, 'all');
    if sw ~= 0
        x_n = round(sum(mx .* w, 'all') / sw);
        y_n = round(sum(my .* w, 'all') / sw);
    end
    
    % calculate displacement
    dx = x_n - x_n;
    dy = y_n - y_n;
                
end