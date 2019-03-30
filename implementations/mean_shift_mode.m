% Click on figure to trigger mean shift

load('helpers/tabulated.mat');

kernel = ones(20);%create_epanechnik_kernel(10, 10, 0.5);

figure(1);
hold on;
imagesc(responses, 'ButtonDownFcn', {@button_down_handler,responses,kernel});
axis([0 100 0 100]);
axis square;

function button_down_handler(src, eventdata, relief, kernel)
    coordinates = get(get(src,'Parent'),'CurrentPoint'); 
    coordinates = round(coordinates(1,1:2));
    x = coordinates(1);
    y = coordinates(2);

    % Plot click point & square of neighbourhood
    plot(x, y, 'rx','MarkerSize', 20);
    plot_square(x, y, size(kernel, 1))
    
    % Find path
    [xs, ys] = find_mode([x y], relief, kernel);
    
    % Plot path
    plot(xs, ys, '-r.','MarkerSize',8);
end

function [xs, ys] = find_mode(start, relief, kernel)

    n = size(kernel, 1);
    pad = round(n/2+1);
    [mx, my] = meshgrid([1:n]);
        
    relief = padarray(relief, [pad pad], 0);
    
    xs = [start(1)+pad];
    ys = [start(2)+pad];
           
    while true
        
        % Extract neighbourhood
        [fx1, fy1, fx2, fy2] = square_points(xs(end), ys(end), n)  ;      
        frame = relief([fy1:fy2], [fx1:fx2]);

        % Calculate new position
        x_n = round(sum((mx+fx1).*frame)/sum(frame));
        y_n = round(sum((my+fy1).*frame)/sum(frame));

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
    
    xs = xs-pad
    ys = ys-pad
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

