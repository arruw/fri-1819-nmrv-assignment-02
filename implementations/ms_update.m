function [state, bbox] = ms_update(state, I, bins, eps, lambda, steps)

    % get template region with padding
    x1 = state.region(1);
    y1 = state.region(2);
    x2 = state.region(3);
    y2 = state.region(4);
        
    while true
    
        % get template
        template = I(y1:y2, x1:x2, :);
        
        % calculate weights
        p = extract_histogram(template, bins, state.kernel);
        v(:,:,1) = (state.q(:,:,1)./(p(:,:,1)+eps)).^(0.5);
        v(:,:,2) = (state.q(:,:,2)./(p(:,:,2)+eps)).^(0.5);
        v(:,:,3) = (state.q(:,:,3)./(p(:,:,3)+eps)).^(0.5);
        w = backproject_histogram(template, v);
            
        x_c = size(w, 2)/2;
        y_c = size(w, 1)/2;
        
        % execute meanshift step
        [dx, dy] = meanshift_step(w, state.mx, state.my);
                
        % update template region
        x1 = x1 + dx;
        x2 = x2 + dx;
        y1 = y1 + dy;
        y2 = y2 + dy;
        
        % debug
        hold on;
        subplot(4, 4, 14);
            axis square;
            axis([0 state.size(1) 0 state.size(2)]);
            imagesc(w);
            set(gca,'XAxisLocation','top','YAxisLocation','left','ydir','reverse');
            plot([x_c x_c+dx], [y_c y_c+dy], '-r.', 'MarkerSize', 10);
        hold off;
        drawnow;
        
        
        % stop when meanshift converges
        if (dx < 1 && dy < 0) || steps == 0
            break
        end
        
        steps = steps - 1;
    end
        
    state.region = [x1 y1 x2 y2];
    
    bbox = [x1 y1 state.size];
end
