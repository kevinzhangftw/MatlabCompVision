% img = imread('Cig_on_Orange1.JPG');
img = imread('Cig13.JPG');
I = rgb2gray(img);
J = imadjust(I);
BW = imregionalmax(J);
BWM = medfilt2(BW, [9,9]);
imshow(BWM);

rmnoise = bwareaopen(BW,200);
imshow(rmnoise);

% getdim = bwmorph(rmnoise,'shrink',Inf);
% imshow(getdim);
% [xcenter ycenter]=find(getdim>0);

% imshow(J);
% s = regionprops(BW,'BoundingBox');
% centroids = cat(1, s.BoundingBox);
% imshow(BW)
% hold on
% plot(centroids(:,1),centroids(:,2), 'b*')
% hold off

rmnoise = bwareaopen(BW,400);
stats = regionprops('table',rmnoise,'Centroid');
