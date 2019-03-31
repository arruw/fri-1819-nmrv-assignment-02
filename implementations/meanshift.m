function [xs, ys] = meanshift(start, relief, kernel, steps)

    n = size(kernel, 1);
    pad = ceil(n/2);
    
    % Pad edges with 0
    relief = padarray(relief, [pad pad], min(relief(:)));
    
    xs = [start(1)+pad];
    ys = [start(2)+pad];
    
    [mx, my] = meshgrid(1:max(size(relief)));      
    
    while true
        
        % Extract neighbourhood
        [fx1, fy1, fx2, fy2] = square_points(xs(end), ys(end), n);
        f_relief = relief(fy1:fy2, fx1:fx2);
        f_mx = mx(fy1:fy2, fx1:fx2);
        f_my = my(fy1:fy2, fx1:fx2);
                
        % Calculate new position
        x_n = xs(end);
        %xi = mx+fx1;%-1;
        gx = conv2(abs((xs(end)-f_mx)/n).^2, kernel, 'same');
        sgx = sum(f_relief.*gx, 'all');
        if sgx ~= 0
            x_n = round(sum(f_mx.*f_relief.*gx, 'all')/sgx);
        end
        
        y_n = ys(end);
        %yi = my+fy1,%-1;
        gy = conv2(abs((ys(end)-f_my)/n).^2, kernel, 'same');
        sgy = sum(f_relief.*gy, 'all');
        if sgy ~= 0
            y_n = round(sum(f_my.*f_relief.*gy, 'all')/sgy);
        end
        
        
        % Calculate displacement vector
        dx = x_n - xs(end);
        dy = y_n - ys(end);
                
        % Stop when displacement vector converges
        if (dx == 0 && dy == 0) || steps == 0
            break
        end  
                
        % Append new step
        xs = [xs x_n];
        ys = [ys y_n];
        steps = steps-1;
    end
    
    xs = xs-pad;
    ys = ys-pad;
end

function [x1, y1, x2, y2] = square_points(x, y, n)
    x1 = ceil(x-n/2);
    y1 = ceil(y-n/2);
    x2 = x1 + n-1;
    y2 = y1 + n-1;
end