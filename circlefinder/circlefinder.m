% Simple Matlab script (not a function) to identify circles in an image.
% Example is as an intro to Matlab, handling images, and convolution

%Brian Funt, Last Modified September 2017

% Note that '%' indicates a comment on that line.

%image=imread('onepenny_cropped.JPG');

%read in image. Must have matlab's 'current directory' set to where the
%file to be read is located.
image=imread('ThreePenniesAreduced.jpg');

% Semi-colons aren't required, but often useful. They inhibit the command's output.

imshow(image);  %display the image

size(image) %prints (note no ";") image dimensions, which will be x by y by 3

bw=(double(image(:,:,1))+double(image(:,:,2))+double(image(:,:,3)))/(3*255);
%%normalized to 0-1 range

figure;  %open new figure window
imshow(bw);
input('Hit any key to continue.');

dt = 110/255;  %Set threshold for being dark. Chosen experimentally
dark=find(bw<dt);  %dark contains the array indices of the pixels that
                   %pass the test bw < dt
tw=-ones(size(bw));   %Make up a new array full of -1's that's the same
                      %dimensions as input image bw.
tw(dark)=1;      %Set all pixels of dark (pennies we hope) indices to +1

figure; imshow(tw); %Two or more commands can go on one line
input('Hit any key to continue.');
cs=13.5;   %generate disks of radius 13.5  (must always be something + 1/2)
border=4;  %border to go around the disk
ms=2*(cs+border);   %define masksize for circular disk. Must be odd.
msh=floor(ms/2)+1;  %midway point to use as center
mask=-ones(ms,ms);  %initialize mask with -1 everywhere

for i=1:ms
    for j=1:ms
        if (i-msh)^2+(j-msh)^2<=cs^2 mask(i,j)=1;
        end;
    end;
end;
figure; imshow(mask)
input('Hit any key to continue.');

%Alternatively, generate disk mask without using FOR loops
w = 35; r = 13.5;
[x, y] = meshgrid(1:w, 1:w);

%[p q] = meshgrid(1:2,3:5) %an example to show how meshgrid works
circle = ((x - (w/2)).^2 + (y - (w/2)).^2 <= r^2);
figure; imshow(circle)

mask=double(circle); %convert logicals to doubles
mask(mask==0)=-1;    %make mask -1 outside circle

c=conv2(mask,tw);  %convolve mask with thresholded image to measure how
                   %disk-like each region is
                   
c01 = c-min(c(:)); c01=c01/max(c01(:)); %Adjust to [0 1] for display only
% Indexed c as c(:) in line above as a 1D vector even though it's also a 2D matrix
imshow(c01);
input('Hit any key to continue.');

y=find(c>900);  %locations of candidate circular disks are those with high
%values after the convolution

res=zeros(size(c));  %Important here that 'c' is in fact bigger than 'bw'
                     %because of convolution boundaries.

res(y)=1;   %Mark all candidate locations in res

figure; imshow(res);
input('Hit any key to continue.');
result=bwmorph(res,'shrink',Inf);  %shrink connected objects to single points

[xcenter ycenter]=find(result>0);
'Number of circles found is: '
length(xcenter)

'Circle locations are: '

[xcenter ycenter]

imshow(result)














