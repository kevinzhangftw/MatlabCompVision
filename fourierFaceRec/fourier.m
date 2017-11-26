%Simple Fourier transform examples

%Brian Funt 2017


%Make up cos and sin curves
N=32;
x=0:N-1;
u=2 %frequency
c2=cos(2*pi*u*x/length(x));
u=5
shift=.2;
c5=cos(2*pi*u*x/length(x)+shift);
figure; hold; plot(c2,'r');plot(c5,'g')

%test orthogonality
disp(['Orthogonality of the two curves:']);
disp(dot(c2,c5))
input('Enter to Continue \n')

figure;
f2=fft(c2);
plot(abs(f2))
title('Abs of FFT of c2');
input('Enter to Continue \n')

cc=c2+c5;  %Make up a more complicated function as the sum of 2 cosines
figure
plot(cc)
title('c2+c5')
input('Enter to Continue \n')

fcc=fft(cc);
figure
plot(abs(fcc))
title('Magnitude of FFT of c2+c5')
input('Enter to Continue \n')
fcc(6)=0+0i;  %6th entry is frequency 5 because vector goes from 1.
fcc(28)=0+0i;
rcc=ifft(fcc);  %reconstruct with 5 cycle sine removed
figure
plot(rcc);
title('Reconstruction of c2+c5 with 5 cycle removed')
input('Enter to Continue \n')


window=ones(1,N);
tails = floor(N/4);
window(1:tails)=0; %Create vector [0 0 0 ... 1 1 1..0 0 0]
window(N-tails:end)=0;
figure
plot(cc.*window)
title('c2+c5 through window')
input('Enter')
figure; plot(abs(fft(cc.*window)));
title('FFT of c2+c5 view through centered window');