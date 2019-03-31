clear; clc;
t1 = imresize(imread('./resources/t1.png'), [51 51]);
t2 = imresize(imread('./resources/t2.png'), [51 51]);

figure(1); clf;
hold on;

subplot(2, 3, 1); imshow(t1);
subplot(2, 3, 2); imshow(t2);

eps = 0.0000000000001;
bins = 8;
lambda = 0.5;

kernel = create_epanechnik_kernel(size(t1,2), size(t1,1), lambda);
shadow = epanechnikov_shadow(size(t1,2));

q = extract_histogram(t1, bins, kernel);
p = extract_histogram(t2, bins, kernel);

v(:,:,1) = (q(:,:,1)./(p(:,:,1)+eps)).^(0.5);
v(:,:,2) = (q(:,:,2)./(p(:,:,2)+eps)).^(0.5);
v(:,:,3) = (q(:,:,3)./(p(:,:,3)+eps)).^(0.5);

w = backproject_histogram(t2, v);

subplot(2, 3, 3); imagesc(w); axis square;

[xs, ys] = meanshift([25 25], w, shadow, 20);
xs(end)
ys(end)

iw = w;
iw(ys(end), xs(end)) = 100000;

subplot(2, 3, 6); imagesc(iw); axis square;

function shadow = epanechnikov_shadow(n)
    shadow = -ones(n)./(n.^2);
end