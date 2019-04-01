clear; clc;

[w mx my] = random_weight(51, 101, 10, 30, 2);

sx = size(w,2);
sy = size(w,1);

figure(1); clf;
hold on;
axis([0 sx 0 sy]);
imagesc(w);
plot(sx/2, sy/2, 'r.', 'MarkerSize', 10);

[dx, dy] = meanshift_step(w, mx, my);
plot(sx/2+dx, sy/2+dy, 'gx', 'MarkerSize', 10);


function [weights mx my] = random_weight(h, w, k, iterations, lambda)
    weights = zeros(h, w);
    
    mask = fspecial('gaussian', [k k], lambda);
    
    for i = [1:iterations]
        rx = randi([1, floor(h-k)]);
        ry = randi([1, floor(w-k)]);
        
        weights([rx:rx+k-1], [ry:ry+k-1]) = weights([rx:rx+k-1], [ry:ry+k-1])+mask;
    end
    
    h2 = floor(h/2);
    w2 = floor(w/2);
    
    [mx my] = meshgrid(-w2:w2, -h2:h2);
end
