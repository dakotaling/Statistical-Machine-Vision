close all

load myposnegmapblk.txt
load myposmapblk.txt

% Image 1
load MyTest.mat
I=MyTest; filename='MyTest';
% Image 2
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx; filename='cardata';
I=reshape(double(cardata),[ny,nx])';

figure;
imagesc(I)
colormap(gray), axis off, axis image


[ny,nx]=size(I);
% derivatives using kernels
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
%print(gcf,'-dtiffn','-r100','MyImageftKxR')
figure;
imagesc(log(abs(imag(ftkernx))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKxI')

ftkerny =fftshift(fft2(fftshift(kernelfilly )));
figure;
imagesc(log(abs(real(ftkerny))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKyR')
figure;
imagesc(log(abs(imag(ftkerny))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKyI')

ftkernxx=fftshift(fft2(fftshift(kernelfillxx)));
figure;
imagesc(log(abs(real(ftkernxx))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKxxR')
figure;
imagesc(log(abs(imag(ftkernxx))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKxxI')

ftkernyy=fftshift(fft2(fftshift(kernelfillyy)));
figure;
imagesc(log(abs(real(ftkernyy))+1),[0,3/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKyyR')
figure;
imagesc(log(abs(imag(ftkernyy))+1),[0,1/10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKyyI')

ftkernxy=fftshift(fft2(fftshift(kernelfillxy)));
figure;
imagesc(log(abs(real(ftkernxy))+1),[0,1/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKxyR')
figure;
imagesc(log(abs(real(ftkernxy))+1),[0,1/4])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','MyImageftKxyI')

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
%print(gcf,'-dtiffn','-r100','ftkernxyftIR')
figure;
imagesc(log(abs(imag(ftkernxyftI))+1),[0,15])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100','ftkernxyftII')

Ix      =real(fftshift(ifft2(fftshift(ftkernx .*ftI))));
Iy      =real(fftshift(ifft2(fftshift(ftkerny .*ftI))));
Ixx     =real(fftshift(ifft2(fftshift(ftkernxx.*ftI))));
Iyy     =real(fftshift(ifft2(fftshift(ftkernyy.*ftI))));
Ixy     =real(fftshift(ifft2(fftshift(ftkernxy.*ftI))));
ID      =Ixx.*Iyy-(Ixy).^2; % Determinant

figure;
imagesc(Ix,[-10,10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftIx'])
figure;
imagesc(Iy,[-10,10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftIy'])
figure;
imagesc(Ixx,[-10,10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftIxx'])
figure;
imagesc(Iyy,[-10,10])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftIyy'])
figure;
imagesc(Ixy,[-1,1])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftIxy'])
figure;
imagesc(ID,[-1,1])
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ftID'])



% added after lecture
EV=zeros(ny,nx,2,2); ED=zeros(ny,nx,2,2); 
theta1=zeros(ny,nx); theta2=zeros(ny,nx);
for j=1:ny
    for i=1:nx
        H=[Ixx(j,i),Ixy(j,i);Ixy(j,i),Iyy(j,i)]; % Hessian
        [V,D]=eig(H); % compute eigen vector an eigen value
        EV(j,i,:,:)=V; ED(j,i,:,:)=D;
        theta1(j,i)=atan2(EV(j,i,2,1),EV(j,i,1,1)); % angle v1
        theta2(j,i)=atan2(EV(j,i,2,2),EV(j,i,1,2)); % angle v2
    end
end
figure;
imagesc(squeeze(ED(:,:,1,1)))
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ED1'])
figure;
imagesc(squeeze(ED(:,:,2,2)))
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ED2'])
figure;
imagesc(theta1)
colormap(colorwheel), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'theta1'])
figure;
imagesc(theta2)
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'theta2'])


ratio=squeeze(ED(:,:,1,1))./squeeze(ED(:,:,2,2));
figure;
histogram(ratio(:))
figure;
imagesc(ratio)
colormap(gray), axis off, axis image
%print(gcf,'-dtiffn','-r100',[filename,'ED1divED2'])









