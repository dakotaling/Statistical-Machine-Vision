close all

load myposnegmapblk.txt
load myposmapblk.txt

% 1 D
dx=1;
x=(dx:dx:3*180);
nx=length(x);
y=cos(2*pi*x/180).^2;
figure;
plot(x/180,y)
%2 D
dy=1;
y=(dy:dy:90);
ny=length(y);
scale=128;

[X,Y]=meshgrid(x,y);

% function image
f=scale*(cos(2*pi*X/180).^2+cos(2*pi*Y/60).^2);
%f=scale*ones(ny,nx)/2;
%f=repmat((1:nx),[ny,1]);

figure;
imagesc(f)
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelI')
figure;
imagesc(f)
colormap(myposnegmapblk), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelIc')

figure;
surf(X,Y,f)
az=-30; el=30; view(az,el)
colormap(myposnegmapblk), axis off
%print(gcf,'-dtiffn','-r100','cartonModelZ')

% x derivative image
fx=-scale*2*pi/180*sin(4*pi*X/180);
figure;
imagesc(fx,[-scale*2*pi/180,scale*2*pi/180])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftfx')
% y derivative image
fy=-scale*2*pi/60*sin(4*pi*Y/60);
figure;
imagesc(fy,[-scale*2*pi/60,scale*2*pi/60])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftfy')
% xx derivative image
fxx=-2*pi^2/8100/4*scale*cos(4*pi*X/180);
figure;
imagesc(fxx,[-2*pi^2/8100/4*scale,2*pi^2/8100/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftfxx')
% yy derivative image
fyy=-2*pi^2/900/4*scale*cos(4*pi*Y/60);
figure;
imagesc(fyy,[-2*pi^2/900/4*scale,2*pi^2/900/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftfyy')
% xy derivative image
fxy=zeros(ny,nx);
figure;
imagesc(fxy,[-1/10,1/10])
colormap(gray), axis off, axis image
line([0.5,nx+0.5],[0.5,0.5],'Color',[0,0,0],'LineWidth',1.0)
line([0.5,nx+0.5],[ny+0.5,ny+0.5],'Color',[0,0,0],'LineWidth',1.0)
line([0.5,0.5],[0.5,ny+0.5],'Color',[0,0,0],'LineWidth',1.0)
line([nx+0.5,nx+0.5],[0.5,ny+0.5],'Color',[0,0,0],'LineWidth',1.0)
%print(gcf,'-dtiffn','-r100','cartonModelftfxy')
% Discriminant
fD=fxx.*fyy-(fxy).^2;
figure;
imagesc(fD,[-2*pi^2/8100/4*scale*2*pi^2/900/4*scale,...
    2*pi^2/8100/4*scale*2*pi^2/900/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftfD')


% derivatives using kernels
I=f; 
kernelx=[ones(3,1),zeros(3,1),-ones(3,1)]/6;
kernely=[ones(1,3);zeros(1,3);-ones(1,3)]/6;
kernelxx=[[1;2;1],[-2;-4;-2],[1;2;1]]/16;
kernelyy=[[1,2,1];[-2,-4,-2];[1,2,1]]/16;
kernelxy=[1,0,-1;0,0,0;-1,0,1]/16;

kernelfillx=zeros(ny,nx);  kernelfilly=zeros(ny,nx); 
kernelfillxx=zeros(ny,nx); kernelfillyy=zeros(ny,nx); 
kernelfillxy=zeros(ny,nx); [ky,kx]=size(kernelx);
if (mod(ky,2)==1)
    kernelfillx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernelx;
    kernelfilly(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernely;
    kernelfillxx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernelxx;
    kernelfillyy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernelyy;
    kernelfillxy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernelxy;
elseif (mod(ky,2)==0)
    kernelfillx(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernelx;
    kernelfilly(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernely;
    kernelfillxx(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernelxx;
    kernelfillyy(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernelyy;
    kernelfillxy(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernelxy;
end
ftI     =fftshift(fft2(fftshift(I           )));
figure;
imagesc(log(abs(real(ftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftIR')
figure;
imagesc(log(abs(imag(ftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftII')

ftkernx =fftshift(fft2(fftshift(kernelfillx )));
figure;
imagesc(log(abs(real(ftkernx))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxR')
figure;
imagesc(log(abs(imag(ftkernx))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxI')

ftkerny =fftshift(fft2(fftshift(kernelfilly )));
figure;
imagesc(log(abs(real(ftkerny))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKyR')
figure;
imagesc(log(abs(imag(ftkerny))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKyI')

ftkernxx=fftshift(fft2(fftshift(kernelfillxx)));
figure;
imagesc(log(abs(real(ftkernxx))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxxR')
figure;
imagesc(log(abs(imag(ftkernxx))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxxI')

ftkernyy=fftshift(fft2(fftshift(kernelfillyy)));
figure;
imagesc(log(abs(real(ftkernyy))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKyyR')
figure;
imagesc(log(abs(imag(ftkernyy))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKyyI')

ftkernxy=fftshift(fft2(fftshift(kernelfillxy)));
figure;
imagesc(log(abs(real(ftkernxy))+1),[0,1/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxyR')
figure;
imagesc(log(abs(real(ftkernxy))+1),[0,1/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftKxyI')

ftkernxftI =ftkernx .*ftI;
figure;
imagesc(log(abs(real(ftkernxftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernxftIR')
figure;
imagesc(log(abs(imag(ftkernxftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernxftII')

ftkernyftI =ftkerny .*ftI;
figure;
imagesc(log(abs(real(ftkernyftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernyftIR')
figure;
imagesc(log(abs(imag(ftkernyftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernyftII')

ftkernxxftI=ftkernxx.*ftI;
figure;
imagesc(log(abs(real(ftkernxxftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernxxftIR')
figure;
imagesc(log(abs(imag(ftkernxxftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernxxftII')

ftkernyyftI=ftkernyy.*ftI;
figure;
imagesc(log(abs(real(ftkernyyftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernyyftIR')
figure;
imagesc(log(abs(imag(ftkernyyftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernyyftII')

ftkernxyftI=ftkernxy.*ftI;
figure;
imagesc(log(abs(real(ftkernxyftI))+1),[0,15])
colormap(gray), axis off, axis image
print(gcf,'-dtiffn','-r100','ftkernxyftIR')
figure;
imagesc(log(abs(imag(ftkernxyftI))+1),[0,15])
colormap(gray), axis off, axis image
print(gcf,'-dtiffn','-r100','ftkernxyftII')

Ix      =real(fftshift(ifft2(fftshift(ftkernx .*ftI))));
Iy      =real(fftshift(ifft2(fftshift(ftkerny .*ftI))));
Ixx     =real(fftshift(ifft2(fftshift(ftkernxx.*ftI))));
Iyy     =real(fftshift(ifft2(fftshift(ftkernyy.*ftI))));
Ixy     =real(fftshift(ifft2(fftshift(ftkernxy.*ftI))));
ID      =Ixx.*Iyy-(Ixy).^2; % Discriminant

figure;
imagesc(Ix,[-scale*2*pi/180,scale*2*pi/180])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftIx')
figure;
imagesc(Iy,[-scale*2*pi/60,scale*2*pi/60])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftIy')
figure;
imagesc(Ixx,[-2*pi^2/8100/4*scale,2*pi^2/8100/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftIxx')
figure;
imagesc(Iyy,[-2*pi^2/900/4*scale,2*pi^2/900/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftIyy')
figure;
imagesc(Ixy,[-1/10,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftIxy')
figure;
imagesc(ID,[-2*pi^2/8100/4*scale*2*pi^2/900/4*scale,2*pi^2/8100/4*scale*2*pi^2/900/4*scale])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','cartonModelftID')

figure;
subplot(2,6,1)
imagesc(fx)
title('fx')
subplot(2,6,2)
imagesc(fy)
title('fy')
subplot(2,6,3)
imagesc(fxx)
title('fxx')
subplot(2,6,4)
imagesc(fyy)
title('fyy')
subplot(2,6,5)
imagesc(fxy)
title('fxy')
subplot(2,6,6)
imagesc(fD)
title('fD')
subplot(2,6,7)
imagesc(Ix)
title('Ix')
subplot(2,6,8)
imagesc(Iy)
title('Iy')
subplot(2,6,9)
imagesc(Ixx)
title('Ixx')
subplot(2,6,10)
imagesc(Iyy)
title('Iyy')
subplot(2,6,11)
imagesc(Ixy)
title('Ixy')
subplot(2,6,12)
imagesc(ID)
title('ID')






