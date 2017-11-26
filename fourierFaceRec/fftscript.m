
%fft script examples Fall 2017  Brian Funt
%1d Example similar to fourier.m but different
x=0:511;
a5=x*5*2*pi/511;

a120=x*120*2*pi/511;
plot(sin(a5)) %plot a 5 cycle sine

input('5-cycle sine. Enter to Continue \n')

figure
plot(sin(a120)) %plot a 120 cycle sine
input('120-cylce sine. Enter to Continue \n')

figure
plot(sin(a5)+0.1*sin(a120)); %plot the weighted combination of 5 and 120 cycles
input('Combined 5 and 120 sines. Enter to Continue \n')

b=fft(sin(a5)+0.1*sin(a120)); %Make up 1d signal of 2 sines
figure
plot(abs(b));  %abs of a complex number is its magnitude
title('Magnitude of transform unshifted')
input('Enter to Continue \n')

%Now shift as well (not done in fourier.m example)
b=fftshift(b);  %shift so that the origin is in the middle
plot(abs(b))
title('Shifted version of transform')
input('Enter to Continue \n')

%now to 2d examples


[x y] = meshgrid(0:511, 0:511);

ah5 = sin(5*2*pi/511*x+0*y); %5 cycle horizontal sine
figure
imshow(ah5+1, [0 2]);  %Display the sine as an image. Add 1 to make in +ve
title('5 cycle 2D sine')
input('press enter to continue');

figure;
surf(ah5)
title('surf plot of 5 cycle 2D sine')
input('press enter to continue');


bh5=fftshift(fft2(ah5));
figure
magnitude_bh5=abs(bh5);
imshow(magnitude_bh5/max(magnitude_bh5(:)))
title('Magnitude of shifted FFT of 5-cycle horizontal sine')
input('press enter to continue');

av5 = sin(0*x+5*2*pi/511*y); %5 cycle vertical sine
figure
imshow(av5+1, [0 2]);  %Display the sine as an image. Add 1 to make in +ve
title('5-cycle vertical sine')
input('press enter to continue');


bv5=fftshift(fft2(av5)); 
figure
magnitude_bv5=abs(bv5);
imshow(magnitude_bv5/max(magnitude_bv5(:)))
title('Magnitude of shifted FFT of 5-cycle vertical sine')
input('press enter to continue');

ad5 = sin(5*2*pi/511*(x+y)/sqrt(2)); %5 cycle diagonal sine
figure
imshow(ad5+1, [0 2]);  %Display the sine as an image. Add 1 to make in +ve
title('5-cycle diagonal sine')
input('press enter to continue');

bd5=fftshift(fft2(ad5)); 
figure
magnitude_bd5=abs(bd5);
imshow(magnitude_bd5/max(magnitude_bd5(:)))
title('Magnitude of shifted FFT of 5-cycle diagonal sine')
input('press enter to continue');

avhd5=(av5+ah5+ad5)/3;  %combine all 3 sines into single complicated image
figure;
imshow(avhd5+1, [0 2]); %Display the sine as an image. Add 1 to make in +ve
title('5-cycle vertical+horizontal+diagonal sine')
input('press enter to continue');
bvhd5=fftshift(fft2(avhd5)); 
figure
magnitude_bvhd5=abs(bvhd5);
imshow(magnitude_bvhd5/max(magnitude_bvhd5(:)))
title('Magnitude of shifted FFT of 5-cycle combined sines')