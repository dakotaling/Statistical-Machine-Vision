close all
clear all

% define parameters
ny=96; nx=ny;

FOVy=240; FOVx=240; deltay=FOVy/ny; deltax=FOVx/nx;
deltakx=1/ny/deltax; deltaky=1/nx/deltay;

A1=10; A2=1.5; A3=1; A4=3;
nu1=0/240; nu2=8/240; nu3=24/240; nu4=16/240;

% make image data
Y1=zeros(ny,nx); Y2=zeros(ny,nx); Y3=zeros(ny,nx); Y4=zeros(ny,nx);
for k=1:ny
    for j=1:nx
        Y1(k,j)= A1*cos(2*pi*nu1*(j-1)*deltax);
        Y2(k,j)= A2*cos(2*pi*nu2*(j-1)*deltax);
        Y3(k,j)= A3*sin(2*pi*nu3*(k-1)*deltay);
        Y4(k,j)= A4*cos(2*pi*nu4*(j-1)*deltax+2*pi*nu4*(k-1)*deltay);    
    end
end
Y=Y1+Y2+Y3+Y4;

figure;
imagesc(Y,[-15,15])
axis image, axis off, colormap(gray)

% DFT by matrix multiplication
OmegaxC=zeros(nx,nx);
for k=1:nx        
   for j=1:nx
      OmegaxC(k,j)=exp(-1i*2*pi*(k-(nx/2+1))*(j-(nx/2+1))/nx);
   end
end
OmegayC=zeros(ny,ny);
for k=1:ny         
   for j=1:ny
      OmegayC(k,j)=exp(-1i*2*pi*(k-(ny/2+1))*(j-(ny/2+1))/ny);
   end
end

F  = (OmegayC*Y *transpose(OmegaxC));
figure;
imagesc(real(F),[0,2*nx*ny/2])%A1*2*Nx*Ny/2  
axis image, axis off, colormap(gray)
figure;
imagesc(abs(imag(F)),[0,nx*ny/2])%A3*Nx*Ny/2  
axis image, axis off, colormap(gray)


% take inverse Fourier transforms
OmegaBarxC=zeros(nx,nx);
for k=1:nx         
   for j=1:nx
      OmegaBarxC(k,j)=exp(1i*2*pi*(k-(nx/2+1))*(j-(nx/2+1))/nx);
   end
end
OmegaBarxC=OmegaBarxC/nx;
OmegaBaryC=zeros(ny,ny);
for k=1:ny         
   for j=1:ny
      OmegaBaryC(k,j)=exp(1i*2*pi*(k-(ny/2+1))*(j-(ny/2+1))/ny);
   end
end
OmegaBaryC=OmegaBaryC/ny;

Yhat  = (OmegaBaryC*F*transpose(OmegaBarxC));

figure;
imagesc(real(Yhat),[-15,15])
axis image, colormap(gray), axis off
figure;
imagesc(imag(Yhat),[-15,15])
axis image, colormap(gray), axis off

% compute with Matlab's functions
FF=fftshift(fft2(fftshift(Y)));
figure;
imagesc(real(FF),[0,2*nx*ny/2])%A1*2*Nx*Ny/2  
axis image, axis off, colormap(gray)
figure;
imagesc(abs(imag(FF)),[0,nx*ny/2])%A3*Nx*Ny/2  
axis image, axis off, colormap(gray)

YYhat=fftshift(ifft2(fftshift(FF)));
figure;
imagesc(real(Yhat),[-15,15])
axis image, axis off, colormap(gray)
figure;
imagesc(imag(Yhat),[-15,15])
axis image, axis off, colormap(gray)









