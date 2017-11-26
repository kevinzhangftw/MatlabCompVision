%% ***************This program finds the key points and their descriptors of two images and matches them************
%% *******************Output of this program will give you the matching percentage of key points********************
%% **********************Submitted to Texas Instruments on October 1st 2013*****************************************
%% ****************************************By:Ch.Naveen*************************************************************
%% Important Variables
% a : Input image
% kpmag : keypoints magnitude
% kpori : keypoints orientation
% kpd   : key point descriptors
% kp    : keypoints
% kpl   : keypoint locations
% Extension of 2 for above variable indicates,it is used for second image for matching
% mp    : matching percentage


clc;
close all;
clear all;
a=imread('cigmodel.jpg');
imshow(a);
title('Selected image');
[row,col,plane]=size(a);
if plane==3
a=rgb2gray(a);
end
a=im2double(a);
original=a;
store1=[];
store2=[];
store3=[];
tic
%% 1st octave generation
k2=0;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store1=[store1 c];
end
clear a;
a=imresize(original,1/2);

%% 2nd level pyramid generation
k2=1;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store2=[store2 c];
end
clear a;
a=imresize(original,1/4);

%% 3rd level pyramid generation
k2=2;
[m,n]=size(a);
a(m:m+6,n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*1.6;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=a(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store3=[store3 c];
end

%% Obtaining key point from the image
i1=store1(1:row,1:col)-store1(1:row,col+1:2*col);
i2=store1(1:row,col+1:2*col)-store1(1:row,2*col+1:3*col);
i3=store1(1:row,2*col+1:3*col)-store1(1:row,3*col+1:4*col);
[m,n]=size(i2);
kp=[];
kpl=[];
for i=2:m-1
    for j=2:n-1
        x=i1(i-1:i+1,j-1:j+1);
        y=i2(i-1:i+1,j-1:j+1);
        z=i3(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i2(i,j)>mz && i2(i,j)>my) || (i2(i,j)<miz && i2(i,j)<miy)
            kp=[kp i2(i,j)];
            kpl=[kpl i j];
        end
    end
end

%% Key points plotting on to the image
for i=1:2:length(kpl);
    k1=kpl(i);
    j1=kpl(i+1);
    i2(k1,j1)=1;
end
figure, imshow(i2);
title('Image with key points mapped onto it');

%% Magnitude and orientation assignment to the key points
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i2(i+1,j)-i2(i,j))^2)+((i2(i,j+1)-i2(i,j))^2));
         oric(i,j)=atan2(((i2(i+1,j)-i2(i,j))),(i2(i,j+1)-i2(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods
kpmag=[];
kpori=[];
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag=[kpmag kmag];
kpori=[kpori kori];
% maxstore=[];
% for i=1:length(magcounts)
%     if magcounts(i)>=0.8*maxvm
%         maxstore=[maxstore magcounts(i) i];
%     end
% end
% 
% if maxstore > 2
%     kmag=maxstore(1:2:length(maxstore));
%     maxvp1=maxstore(2:2:length(maxstore));
%     temp=(countl((2*maxvp1)-1)+countl(2*maxvp1)+1)/2;
%     kori=temp;
% end
end


%% Forming key point Descriptors
kpd=[];
%% Forming key point neighbourhooods
for x1=1:2:length(kpl)
    k1=kpl(x1);
    j1=kpl(x1+1);
    if k1 > 7 && j1 > 7 && k1 < m-8 && j1 < n-8
    p2=mag(k1-7:k1+8,j1-7:j1+8);
    q2=oric(k1-7:k1+8,j1-7:j1+8);
    else
        continue;
    end
    kpmagd=[];
    kporid=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            
        %% Finding orientation and magnitude for the key point
        [m1,n1]=size(p1);
        magcounts=[];
        for x=0:45:359
            magcount=0;
        for i=1:m1
            for j=1:n1
                ch1=-180+x;
                ch2=-180+45+x;
                if ch1<0  ||  ch2<0
                if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                else
                if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                end
            end
        end
        magcounts=[magcounts magcount];
        end
        kpmagd=[kpmagd magcounts];
        end
    end
    kpd=[kpd kpmagd];
end
fprintf('\n\nTime taken for calculating the SIFT keys and their desccriptors is :%f\n\n',toc);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 2ng image for comparision
a=original;
b=imread('Cig_on_Orange1.JPG');
[row,col,plane]=size(b);
if plane==3
b=rgb2gray(b);
end
b=im2double(b);
sigmae=1.6;
store4=[];
store5=[];
store6=[];
tic
%% 1st octave generation
k2=0;
[m,n]=size(b);
b(m:m+6, n:n+6)=0;
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=b(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store4=[store4 c];
end
clear b;
b=imresize(original,1/2);

%% 2nd level pyramid generation
k2=1;
[m,n]=size(b);
b(m:m+6,n:n+6)=0;
b=im2double(b);
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=b(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store5=[store5 c];
end
clear b;
b=imresize(original,1/4);

%% 3rd level pyramid generation
k2=2;
[m,n]=size(b);
b(m:m+6,n:n+6)=0;
b=im2double(b);
clear c;
for k1=0:3
    k=sqrt(2);
sigma=(k^(k1+(2*k2)))*sigmae;
for x=-3:3
    for y=-3:3
        h(x+4,y+4)=(1/((2*pi)*((k*sigma)*(k*sigma))))*exp(-((x*x)+(y*y))/(2*(k*k)*(sigma*sigma)));
    end
end
for i=1:m
    for j=1:n
        t=b(i:i+6,j:j+6)'.*h;
        c(i,j)=sum(sum(t));
    end
end
store6=[store6 c];
end

%% Obtaining key point from the image
i4=store4(1:row,1:col)-store4(1:row,col+1:2*col);
i5=store5(1:row,col+1:2*col)-store5(1:row,2*col+1:3*col);
i6=store6(1:row,2*col+1:3*col)-store6(1:row,3*col+1:4*col);

[m,n]=size(i5);
kp2=[];
kpl2=[];
for i=2:m-1
    for j=2:n-1
        y=[];
        x=i4(i-1:i+1,j-1:j+1);
        y=i5(i-1:i+1,j-1:j+1);
        z=i6(i-1:i+1,j-1:j+1);
        y(1:4)=y(1:4);
        y(5:8)=y(6:9);
        mx=max(max(x));
        mz=max(max(z));
        mix=min(min(x));
        miz=min(min(z));
        my=max(max(y));
        miy=min(min(y));
        if (i5(i,j)>mz && i5(i,j)>my) || (i5(i,j)<miz && i5(i,j)<miy)
            kp2=[kp2 i5(i,j)];
            kpl2=[kpl2 i j];
        end
    end
end

%% Key points plotting on to the image
for i=1:2:length(kpl2);
    i4=kpl2(i);
    j5=kpl2(i+1);
    i6(i4,j5)=1;
end
figure, imshow(i5);
title('2nd image with key points mapped onto it');

%% Magnitude and orientation assignment to the key points
for i=1:m-1
    for j=1:n-1
         mag(i,j)=sqrt(((i5(i+1,j)-i5(i,j))^2)+((i5(i,j+1)-i5(i,j))^2));
         oric(i,j)=atan2(((i5(i+1,j)-i5(i,j))),(i5(i,j+1)-i5(i,j)))*(180/pi);
    end
end

%% Forming key point neighbourhooods
kpmag2=[];
kpori2=[];
for x1=1:2:length(kpl2)
    k1=kpl2(x1);
    j1=kpl2(x1+1);
    if k1 > 2 && j1 > 2 && k1 < m-2 && j1 < n-2
    p1=mag(k1-2:k1+2,j1-2:j1+2);
    q1=oric(k1-2:k1+2,j1-2:j1+2);
    else
        continue;
    end
    %% Finding orientation and magnitude for the key point
[m1,n1]=size(p1);
magcounts=[];
for x=0:10:359
    magcount=0;
for i=1:m1
    for j=1:n1
        ch1=-180+x;
        ch2=-171+x;
        if ch1<0  ||  ch2<0
        if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        else
        if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
            ori(i,j)=(ch1+ch2+1)/2;
            magcount=magcount+p1(i,j);
        end
        end
    end
end
magcounts=[magcounts magcount];
end
[maxvm maxvp]=max(magcounts);
kmag=maxvm;
kori=(((maxvp*10)+((maxvp-1)*10))/2)-180;
kpmag2=[kpmag2 kmag];
kpori2=[kpori2 kori];
% maxstore=[];
% for i=1:length(magcounts)
%     if magcounts(i)>=0.8*maxvm
%         maxstore=[maxstore magcounts(i) i];
%     end
% end
% 
% if maxstore > 2
%     kmag=maxstore(1:2:length(maxstore));
%     maxvp1=maxstore(2:2:length(maxstore));
%     temp=(countl((2*maxvp1)-1)+countl(2*maxvp1)+1)/2;
%     kori=temp;
% end
end

%% Forming key point Descriptors
kpd2=[];
for x1=1:2:length(kpl2)
    k1=kpl2(x1);
    j1=kpl2(x1+1);
    if k1 > 7 && j1 > 7 && k1 < m-8 && j1 < n-8
    p2=mag(k1-7:k1+8,j1-7:j1+8);
    q2=oric(k1-7:k1+8,j1-7:j1+8);
    else
        continue;
    end
    kpmagd=[];
%% Dividing into 4x4 blocks
    for k1=1:4
        for j1=1:4
            p1=p2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            q1=q2(1+(k1-1)*4:k1*4,1+(j1-1)*4:j1*4);
            
        %% Finding orientation and magnitude for the key point
        [m1,n1]=size(p1);
        magcounts=[];
        for x=0:45:359
            magcount=0;
        for i=1:m1
            for j=1:n1
                ch1=-180+x;
                ch2=-180+45+x;
                if ch1<0  ||  ch2<0
                if abs(q1(i,j))<abs(ch1) && abs(q1(i,j))>=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                else
                if abs(q1(i,j))>abs(ch1) && abs(q1(i,j))<=abs(ch2)
                    ori(i,j)=(ch1+ch2+1)/2;
                    magcount=magcount+p1(i,j);
                end
                end
            end
        end
        magcounts=[magcounts magcount];
        end
        kpmagd=[kpmagd magcounts];
        end
    end
    kpd2=[kpd2 kpmagd];
end
fprintf('\n\nTime taken for calculating the SIFT keys and their desccriptors for 2nd image is :%f\n\n',toc);

%% Two images key point comparision
tic
count=0;
for i=1:2:length(kpl)
    for j=1:2:length(kpl2)
        if (kpl(i)==kpl2(j))  &&   (kpl(i+1)==kpl2(j+1))
            count=count+1;
            break;
        end
    end
end
mp=(count/length(kp))*100;
fprintf('Time taken for calculating the matching percentage is :%f\n\n',toc);
fprintf('Matching percentage between 2 images by key point location is :%f \n\n',mp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         END OF THE PROGRAM        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%