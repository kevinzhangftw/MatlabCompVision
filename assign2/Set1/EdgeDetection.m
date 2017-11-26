img = imread('Cig_on_Orange1.JPG');
I = rgb2gray(img);
% BW = edge(I);
% e = edge(I,'log');
% [BW,threshOut] = edge(I,'Canny',0.5);
x = edge(I,'Canny',0.1);
BW2 = bwareaopen(x,40);

% theta = 0:179;
% [R,xp] = radon(BW2,theta);
% figure
% imagesc(theta, xp, R); colormap(hot);

% imshow(BW2);