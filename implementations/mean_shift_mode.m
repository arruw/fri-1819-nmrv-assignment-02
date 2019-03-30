% Click on figure to trigger mean shift

load('helpers/tabulated.mat');

kernel1 = -ones(30)./900;
kernel2 = -fspecial('gaussian', [30 30], 2);

figure(1);
hold on;
imagesc(responses, 'ButtonDownFcn', {@button_down_handler,responses,kernel1});
axis([0 100 0 100]);
axis square;

for cx = [1:10:100]
    for cy = [1:10:100]
        test(cx, cy, responses, kernel2);
    end
end

function button_down_handler(src, eventdata, relief, kernel)
    coordinates = get(get(src,'Parent'),'CurrentPoint'); 
    coordinates = round(coordinates(1,1:2));
    x = coordinates(1);
    y = coordinates(2);

    test(x, y, relief, kernel);
end

function test(x, y, relief, kernel)
    % Plot click point & square of neighbourhood
    plot(x, y, 'r.','MarkerSize', 20);
    %plot_square(x, y, size(kernel, 1));
    
    % Find path
    [xs, ys] = find_mode([x y], relief, kernel);
        
    % Plot path & end position
    plot(xs(end), ys(end), 'rx','MarkerSize', 20);
    plot(xs, ys, '-k');
    
    % Plot number of steps
    steps = size(xs, 2)-1;
    text(x, y, "  "+steps);
end

function [xs, ys] = find_mode(start, relief, kernel)

    n = size(kernel, 1);
    pad = round(n/2+1);
    [mx, my] = meshgrid(1:n);
        
    relief = padarray(relief, [pad pad], 0);
    
    xs = [start(1)+pad];
    ys = [start(2)+pad];
           
    while true
        
        % Extract neighbourhood
        [fx1, fy1, fx2, fy2] = square_points(xs(end), ys(end), n);
        frame = relief(fy1:fy2, fx1:fx2);
        
        % Calculate new position
        x_n = xs(end);
        xi = mx+fx1;
        gx = conv2(abs((xs(end)-xi)/n).^2, kernel, 'same');
        sgx = sum(frame.*gx, 'all');
        if sgx ~= 0
            x_n = round(sum(xi.*frame.*gx, 'all')/sgx);
        end
        
        y_n = ys(end);
        yi = my+fy1;
        gy = conv2(abs((ys(end)-yi)/n).^2, kernel, 'same');
        sgy = sum(frame.*gy, 'all');
        if sgy ~= 0
            y_n = round(sum(yi.*frame.*gy, 'all')/sgy);
        end
        
        
        % Calculate displacement vector
        dx = x_n - xs(end);
        dy = y_n - ys(end);
        
        % Stop when displacement vector converges
        if dx == 0 && dy == 0
            break
        end  
                
        % Append new step
        xs = [xs x_n];
        ys = [ys y_n];
    end
    
    xs = xs-pad;
    ys = ys-pad;
end

function [x1, y1, x2, y2] = square_points(x, y, n)
    x1 = round(x-n/2);
    y1 = round(y-n/2);
    x2 = x1 + n-1;
    y2 = y1 + n-1;
end

function plot_square(x, y, n)
    [x1, y1, x2, y2] = square_points(x, y, n);
    
    x = [x1, x2, x2, x1, x1];
    y = [y1, y1, y2, y2, y1];
    plot(x, y, '--r', 'LineWidth', 1);
end

