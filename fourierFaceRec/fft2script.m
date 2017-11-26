%Simple script to show fft2 magnitudes

a=double(imread('ThreePenniesAreduced.jpg'))/255;
imshow(a);

f=fft2(a);  %Take 2D Fourier.
fa=abs(f); %Compute magnitude of complex numbers using abs. 
 
figure;
imshow(fa/max(fa(:))) %Put in 0-1 range before displaying
title('FFT magnitude');
fa=log(fa); %Take log just for display purposes since range will be large.
fa=fa-min(fa(:)); %Make min zero.
fa=fa/max(fa(:)); %Scale to 0-1.
figure;
imshow(fa)
title('Log FFT magnitude');
figure;
imshow(fftshift(fa)); 
title('Shifted Log FFT magnitude');

a=zeros(500);
a(300:400,300:400)=1;
imshow(a);

f=fft2(a);  %Take 2D Fourier.
fa=abs(f); %Compute magnitude of complex numbers using abs. 
 
figure;
imshow(fa/max(fa(:))) %Put in 0-1 range before displaying
title('FFT magnitude');
fa=log(fa); %Take log just for display purposes since range will be large.
fa=fa-min(fa(:)); %Make min zero.
fa=fa/max(fa(:)); %Scale to 0-1.
figure;
imshow(fa)
title('Log FFT magnitude');
figure;
imshow(fftshift(fa)); 
title('Shifted Log FFT magnitude');

a=imrotate(a,45);
imshow(a)
f=fft2(a);  %Take 2D Fourier.
fa=abs(f); %Compute magnitude of complex numbers using abs. 
 
figure;
imshow(fa/max(fa(:))) %Put in 0-1 range before displaying
title('FFT magnitude');
fa=log(fa+1); %Take log just for display purposes since range will be large.
%Added 1 in the log case just to avoid log(0).
fa=fa-min(fa(:)); %Make min zero.
fa=fa/max(fa(:)); %Scale to 0-1.
figure;
imshow(fa)
title('Log FFT magnitude');
figure;
imshow(fftshift(fa)); 
title('Shifted Log FFT magnitude');
