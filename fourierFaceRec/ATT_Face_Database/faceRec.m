clear;
a=double(imread('s1/1.pgm'))/255;
% imshow(a);
b=double(imread('s2/1.pgm'))/255;
imshow(b);

src=fft2(a);  %Take 2D Fourier.
% src=abs(src);
% src=src-min(src(:));
% src=src/max(src(:)); %Scale to 0-1.
shiftedsrc = fftshift(src);
lowQuada = shiftedsrc(57:112,47:92);
maga = imag(lowQuada);

invlow = ifft2(maga);
imshow(invlow);

target=fft2(b);  %Take 2D Fourier.
% target=abs(target);
% target=target-min(target(:));
% target=target/max(target(:)); %Scale to 0-1.
shiftedtarget = fftshift(target);
lowQuadb = shiftedtarget(57:112,47:92);
magb = imag(lowQuadb);
% % imshow(magb)
% 
% % Compute the Euclidean distance
D = pdist2(maga,magb);
distance = sum(sum(D));
% comparing same person in s1/1 and s1/2, distance = 150.2607
% comparing diff person in s1/1 and s2/1, distance = 165.1755


