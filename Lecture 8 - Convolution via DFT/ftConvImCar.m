clear all
close all

printfigs=0;

% form kernel for convolution
kernel=[0,1,0;1,1,1;0,1,0]/5;
[a,b]=size(kernel);

load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
I=double(reshape(cardata,[ny,nx])');
figure;
imagesc(I,[0,200])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ireal')
end
figure;
imagesc(imag(I),[0,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Iimag')
end

% appends border pixels for wrap-around
IW=[I(ny-(a-1)/2+1:ny,nx-(b-1)/2+1:nx)  ,I(ny-(a-1)/2+1:ny,1:nx),I(ny-(a-1)/2+1:ny,1:(b-1)/2);...
    I(1:ny         ,nx-(b-1)/2+1:nx),I(1:ny           ,1:nx),I(1:ny           ,1:(b-1)/2);...
    I(1:(a-1)/2    ,nx-(b-1)/2+1:nx),I(1:(a-1)/2      ,1:nx),I(1:(a-1)/2      ,1:(b-1)/2)];
% perform convolution
Ism=zeros(ny,nx);
for j=1:ny
    for i=1:nx
        Ism(j,i)=sum(sum(kernel.*IW(j:j+a-1,i:i+b-1)));
    end
end
figure;
imagesc(Ism,[0,200])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','IsmR')
end
figure;
imagesc(imag(Ism),[0,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','IsmI')
end
figure;
histogram(I(:),(0:2:255))
xlim([0,255]), ylim([0,400])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ismhist')
end

% fourier transform of smoothed image
ftIsm=fftshift(fft2(fftshift(Ism)));
maxftIsmreal=max(max(2*real(ftIsm)/(nx*ny)));
maxftIsmimag=max(max(2*imag(ftIsm)/(nx*ny)));
figure;
imagesc(log(2*abs(real(ftIsm))/n+1),[0,log(maxftIsmreal+1)])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIsmR')
end
figure;
imagesc(log(2*abs(imag(ftIsm))/n+1),[0,log(maxftIsmimag+1)])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIsmI')
end

ftI=fftshift(fft2(fftshift(I)));
figure;
imagesc(log(2*abs(real(ftIsm))/n+1),[0,log(maxftIsmreal+1)])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIR')
end
figure;
imagesc(log(2*abs(imag(ftIsm))/n+1),[0,log(maxftIsmimag+1)])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftII')
end
% check zero frequency
[mean(I(:)),real(ftI(61,61)/(nx*ny))]


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
kMat=zeros(ny,nx);
kMat(ny/2-(a-1)/2+1:ny/2+(a-1)/2+1,nx/2-(a-1)/2+1:nx/2+(a-1)/2+1)=kernel;
figure;
imagesc(real(kMat),[0,.2])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','kMatR')
end
figure;
imagesc(imag(kMat),[0,.2])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','kMatI')
end

ftkMat=fftshift(fft2(fftshift(kMat)));
figure;
imagesc(real(ftkMat),[0,1])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftkMatR')
end
figure;
imagesc(abs(imag(ftkMat)),[0,0.1])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftkMatI')
end

figure;
imagesc(log(abs(2*real(ftI)/(nx*ny))+1),[0,log(maxftIsmreal+1)])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIreal')
end
figure;
imagesc(log(2*abs(imag(ftI))/(nx*ny)+1),[0,log(maxftIsmimag+1)])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftIimag')
end

ftkMatftI=ftkMat.*ftI;
figure;
imagesc(log(abs(2*real(ftkMatftI)/(nx*ny))+1),[0,log(maxftIsmreal+1)])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftkMatftYR')
end
figure;
imagesc(log(2*abs(imag(ftkMatftI))/(nx*ny)+1),[0,log(maxftIsmimag+1)])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','ftkMatftYI')
end

IsmFT=fftshift(ifft2(fftshift(ftkMatftI)));
figure;
imagesc(IsmFT,[0,200])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','YsmFTR')
end
figure;
imagesc(abs(imag(IsmFT)),[0,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','YsmFTI')
end




