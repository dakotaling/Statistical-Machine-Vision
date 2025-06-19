close all
clear all

% define parameters
ny=96; nx=ny;

FOVy=240; FOVx=240; deltay=FOVy/ny; deltax=FOVx/nx;
deltakx=1/ny/deltax; deltaky=1/nx/deltay;

% make image data
A1=10; A2=1.5; A3=1; A4=3;
nu1=0/240; nu2=8/240; nu3=24/240; nu4=16/240;
Y=zeros(ny,nx); 
for k=1:ny
    for j=1:nx
        Y(k,j)= A1*cos(2*pi*nu1*(j-1)*deltax)...
        + A2*cos(2*pi*nu2*(j-1)*deltax)...
        + A3*sin(2*pi*nu3*(k-1)*deltay)...
        + A4*cos(2*pi*(nu4*(j-1)*deltax+nu4*(k-1)*deltay));    
    end
end
figure;
imagesc(Y,[-15,15])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','YR')
figure;
imagesc(abs(imag(Y)),[0,1])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','YI')

% form kernel for convolution
kernel=[0,1,0;...
        1,1,1;...
        0,1,0]/5;
[a,b]=size(kernel);

% appends border pixels for wrap-around
YW=[Y(ny-(a-1)/2+1:ny,nx-(b-1)/2+1:nx),Y(ny-(a-1)/2+1:ny,1:nx),Y(ny-(a-1)/2+1:ny,1:(b-1)/2);...
    Y(1:ny         ,nx-(b-1)/2+1:nx)  ,Y(1:ny           ,1:nx),Y(1:ny           ,1:(b-1)/2);...
    Y(1:(a-1)/2    ,nx-(b-1)/2+1:nx)  ,Y(1:(a-1)/2      ,1:nx),Y(1:(a-1)/2      ,1:(b-1)/2)];
% perform convolution
Ysm=zeros(ny,nx);
for j=1:ny
    for i=1:nx
        Ysm(j,i)=sum(sum(kernel.*YW(j:j+a-1,i:i+b-1)));
    end
end
figure;
imagesc(Ysm,[-15,15])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','YsmR')
figure;
imagesc(abs(imag(Ysm)),[0,1])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','YsmI')


% Fourier transform of smoothed image
ftYsm=fftshift(fft2(fftshift(Ysm)));
figure;
imagesc(2*real(ftYsm)/(nx*ny),[0,2.5])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','ftYsmR')
figure;
imagesc(2*abs(imag(ftYsm))/(nx*ny),[0,.5])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','ftYsmI')

% Fourier transform of original image
ftY=fftshift(fft2(fftshift(Y)));
figure;
imagesc(2*real(ftY)/(nx*ny),[0,2.5])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','ftYR')
figure;
imagesc(2*abs(imag(ftY))/(nx*ny),[0,.5])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','ftYI')

Yhat=fftshift(ifft2(fftshift(ftY)));
figure;
imagesc(real(Yhat),[-15,15])
axis image, axis off, colormap(gray)
figure;
imagesc(imag(Yhat),[-15,15])
axis image, axis off, colormap(gray)

kMat=zeros(ny,nx);
kMat(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1,nx/2-(a-1)/2+1:nx/2+(a-1)/2+1)=kernel;
figure;
imagesc(real(kMat),[0,.2])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','kMatR')
figure;
imagesc(imag(kMat),[0,.2])
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','kMatI')

ftkMat=fftshift(fft2(fftshift(kMat)));
figure;
imagesc(real(ftkMat),[0,1])
axis image, axis off, colormap(gray)
print(gcf,'-dtiffn','-r100','ftkMatR')
figure;
imagesc(abs(imag(ftkMat)),[0,0.1])
axis image, axis off, colormap(gray)
print(gcf,'-dtiffn','-r100','ftkMatI')

ftkMatftY=ftkMat.*ftY;
figure;
imagesc(2*real(ftkMatftY)/(nx*ny),[0,2.5])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','ftkMatftYR')
figure;
imagesc(2*abs(imag(ftkMatftY))/(nx*ny),[0,.5])
axis image, axis off, colormap(gray)
%print(gcf,'-dtiffn','-r100','ftkMatftYI')

YsmFT=fftshift(ifft2(fftshift(ftkMatftY)));
figure;
imagesc(YsmFT,[-15,15])
colormap(gray), axis image, axis off
print(gcf,'-dtiffn','-r100','YsmFTR')
figure;
imagesc(abs(imag(YsmFT)),[0,1])
colormap(gray), axis image, axis off
print(gcf,'-dtiffn','-r100','YsmFTI')




