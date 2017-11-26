% img = imread('Cig_on_Orange1.JPG');
img = imread('Cig13.JPG');
% imshow(img);

I = rgb2gray(img);
J = imadjust(I);
% imshow(J);

BW = imregionalmax(J);
% imshow(BW);

BWM = medfilt2(BW, [9,9]);
% imshow(BWM);

% rmnoise = bwareaopen(BW,200);
rmnoise = bwareaopen(BW,275);
% imshow(rmnoise);

stats = regionprops('table',rmnoise,'Centroid');
