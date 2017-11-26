img = imread('Cig_on_Orange1.JPG');
% imshow(img);
lab = rgb2lab(img);
% labwhite1 = imregionalmin(lab(:,:,3));
% rmnoise = bwareaopen(BW,10);
% imshow(rmnoise);
% imshow(labwhite1);
% imshow(lab(:,:,1),[0 100]);
imshow(lab)