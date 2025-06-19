% Code inspired by Professor Daniel Rowe
clear all
close all

I = imread('empire_state.jpg');

figure;
imagesc(I)
colormap(gray), axis off, axis image
title('Original Empire State Building Image')

[ny,nx] = size(I);

% Define derivative kernels
kernelx = [ones(3,1),zeros(3,1),-ones(3,1)]/6;        
kernely = [ones(1,3);zeros(1,3);-ones(1,3)]/6;        
kernelxx = [[1;2;1],[-2;-4;-2],[1;2;1]]/16;           
kernelyy = [[1,2,1];[-2,-4,-2];[1,2,1]]/16;          
kernelxy = [1,0,-1;0,0,0;-1,0,1]/16;            

% Create zero-padded kernels for FFT
kernelfillx = zeros(ny,nx);  kernelfilly = zeros(ny,nx); 
kernelfillxx = zeros(ny,nx); kernelfillyy = zeros(ny,nx); 
kernelfillxy = zeros(ny,nx); 

[ky,kx] = size(kernelx);
if (mod(ky,2)==1)
    kernelfillx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelx;
    kernelfilly(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernely;
    kernelfillxx(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelxx;
    kernelfillyy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelyy;
    kernelfillxy(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1) = kernelxy;
end

% Apply kernels using FFT convolution
ftI = fftshift(fft2(fftshift(I)));
ftkernx = fftshift(fft2(fftshift(kernelfillx)));
ftkerny = fftshift(fft2(fftshift(kernelfilly)));
ftkernxx = fftshift(fft2(fftshift(kernelfillxx)));
ftkernyy = fftshift(fft2(fftshift(kernelfillyy)));
ftkernxy = fftshift(fft2(fftshift(kernelfillxy)));

Ix = real(fftshift(ifft2(fftshift(ftkernx.*ftI))));    
Iy = real(fftshift(ifft2(fftshift(ftkerny.*ftI))));    
Ixx = real(fftshift(ifft2(fftshift(ftkernxx.*ftI))));  
Iyy = real(fftshift(ifft2(fftshift(ftkernyy.*ftI)))); 
Ixy = real(fftshift(ifft2(fftshift(ftkernxy.*ftI))));  


ID = Ixx.*Iyy - (Ixy).^2;

% Display each derivative in separate figures
figure;
imagesc(Ix)
colormap(gray), axis off, axis image
title('First Derivative Ix')

figure;
imagesc(Iy)
colormap(gray), axis off, axis image
title('First Derivative Iy')

figure;
imagesc(Ixx)
colormap(gray), axis off, axis image
title('Second Derivative Ixx')

figure;
imagesc(Iyy)
colormap(gray), axis off, axis image
title('Second Derivative Iyy')

figure;
imagesc(Ixy)
colormap(gray), axis off, axis image
title('Second Derivative Ixy')

figure;
imagesc(ID)
colormap(gray), axis off, axis image
title('Discriminant D = Ixx*Iyy - Ixy^2')