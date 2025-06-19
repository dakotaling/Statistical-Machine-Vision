% Code inspired by Professor Daniel Rowe
% Based on ImageStatsToy.m and MotivationImage.m
clear; clc;

rng('default')
printfigs=0;

nx=32; ny=nx;
limMin=75; limMax=125; yhist=15;
mu=100; sigma2=20;

I0=ones(ny,nx)*mu;
N=sqrt(sigma2)*randn([ny,nx]);
I=I0+N;

Ibar=mean(I(:)), s2I=var(I(:))

figure;
imagesc(I,[limMin,limMax])
colormap(gray), axis image, axis off
title('Original Image with Noise')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','I')
end

figure;
histogram(I(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
title('Histogram of Original Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ihist')
end

kernel=[  0,1/8,  0;...
        1/8,1/2,1/8;...
          0,1/8,  0];

O=MyConv(I,kernel);

Obar=mean(O(:)), s2O=var(O(:))

figure;
imagesc(O,[limMin,limMax])
colormap(gray), axis image, axis off
title('Smoothed Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','O')
end

figure;
histogram(O(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
title('Histogram of Smoothed Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ohist')
end

% convolution matrix with wrap-around 
% (original was hardcoded for 8x8)
krnl=zeros(ny,nx);
krnl(1,1)=1/2;
krnl(1,2)=1/8;
krnl(2,1)=1/8;
krnl(1,nx)=1/8;
krnl(ny,1)=1/8;

% Matrix
A=zeros(ny*nx,ny*nx);
for j=1:ny
    if (j~=1)
        krnl=[krnl(ny,:);krnl(1:ny-1,:)];
    end
    A((j-1)*nx+1,:)=reshape(krnl',[nx*ny,1])';
    for i=(j-1)*nx+2:j*nx
        krnl=[krnl(:,nx),krnl(:,1:nx-1)];
        A(i,:)=reshape(krnl',[nx*ny,1])';
    end
    krnl=[krnl(:,nx),krnl(:,1:nx-1)];
end

figure;
imagesc(A,[0,5/16])
axis image, axis off, colormap(gray)
title('Convolution Matrix A')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','A')
end

AAt=A*A';
figure;
imagesc(AAt,[0,5/16])
colormap(gray), axis image, axis off
title('Induced Covariance Matrix AA^T')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAt')
end

R=diag(1./sqrt(diag(AAt)))*AAt*diag(1./sqrt(diag(AAt)));
figure;
imagesc(R,[0,1])
colormap(gray), axis image, axis off
title('Spatial Correlation Matrix R')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','R')
end

Ivec=reshape(I',nx*ny,1);
Wvec=A*Ivec;
W=reshape(Wvec,nx,ny)';

figure;
imagesc(W,[limMin,limMax])
colormap(gray), axis image, axis off
title('Matrix Convolution Result')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','W')
end

Wbar=mean(W(:)), s2W=var(W(:))

invA=pinv(A);
figure;
imagesc(invA,[-1,1])
colormap(gray), axis image, axis off
title('Deconvolution Matrix (pseudo-inverse of A)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','invA')
end

% deconvolution
Vvec=invA*Wvec;
V=reshape(Vvec,nx,ny)';

figure;
imagesc(V,[limMin,limMax])
colormap(gray), axis image, axis off
title('Deconvolved Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','V')
end

figure;
histogram(V(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
title('Histogram of Deconvolved Image')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Vhist')
end

Vbar=mean(V(:)), s2V=var(V(:))

pixnum=ny/2*nx+nx/2+1;
r=R(pixnum,:);
corImage=reshape(r,[nx,ny])';
figure;
imagesc(corImage,[-1,1])
axis image, axis off, colormap(gray)
title('Spatial Autocorrelation from Center Pixel')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','corImage')
end

figure;
imagesc(invA*A,[-1,1])
colormap(gray), axis image, axis off
title('invA*A (should approximate identity)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','invAA')
end