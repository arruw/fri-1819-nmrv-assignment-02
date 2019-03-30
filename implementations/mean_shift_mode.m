load('helpers/tabulated.mat');

kernel = ones(15);%create_epanechnik_kernel(10, 10, 0.5);

figure(1);
hold on;
axis square;
h = imagesc(responses, 'ButtonDownFcn', {@button_down_handler,responses,kernel});

function button_down_handler(src, eventdata, relief, kernel)
    coordinates = get(get(src,'Parent'),'CurrentPoint'); 
    coordinates = round(coordinates(1,1:2));
    x = coordinates(1);
    y = coordinates(2);

    plot(x, y, 'rx','MarkerSize', 20);
    
    find_mode([x y], relief, kernel);
end

function find_mode(start, relief, kernel)
    n = size(kernel, 1);
    pad = round(n/2+1);
    [mx, my] = meshgrid([1:n]);
    
    x_c = start(1);
    y_c = start(2);
           
    while true
        
        frame_x = round(x_c-n/2);
        frame_y = round(y_c-n/2);

        frame = relief(...
            [frame_y:frame_y+n-1],...
            [frame_x:frame_x+n-1]...
            );

        x_n = round(sum((mx+frame_x).*frame)/sum(frame));
        y_n = round(sum((my+frame_y).*frame)/sum(frame));

        dx = x_n - x_c;
        dy = y_n - y_c;

        if dx == 0 && dy == 0
            break
        end  
        
        plot([x_c x_n], [y_c y_n], '-r.','MarkerSize',8);
        
        x_c = x_n;
        y_c = y_n;
    end
end

