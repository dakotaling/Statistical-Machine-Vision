% Rowe FT convolution reexample %

clear all
close all

savevideo=0;
showfigs=1;
printfigs=0;
limMax=255;

% video file name
filename='shelby.mp4';
% get video information
vidObj = VideoReader(filename);
nt = vidObj.NumFrames;
nx = vidObj.Width;
ny = vidObj.Height;
fr = vidObj.FrameRate;
% convert video to grayscale and equalize
videoRGB = read(vidObj,[1 nt]);
I=zeros([ny,nx,nt]);
for t=1:nt
    I(:,:,t)=(rgb2gray(videoRGB(:,:,:,t)));
end
clear videoRGB

% save grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('Shelby500.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
     set(gca, 'Position', get(gca, 'OuterPosition'));
     set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I(:,:,t))
    %title(['Frame ',num2str(t)])
    colormap(gray), axis image, axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    pause(1/fr)
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end
%


t=140; Y=I(:,:,t);

figure; % display video frames
pause
for t=1:nt
%     figure; % select one sample frame for convolution
%     imagesc(Y,[0,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['I',num2str(t)])
end
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    title(['Frame ',num2str(t)])
    pause(.1)
end



% form kernel for convolution smoothing
kernel=ones(5,5)/25;
[ky,kx]=size(kernel);

% appends border pixels for wrap-around
YW=[Y(ny-(ky-1)/2+1:ny,nx-(kx-1)/2+1:nx),Y(ny-(ky-1)/2+1:ny,1:nx),Y(ny-(ky-1)/2+1:ny,1:(kx-1)/2);...
    Y(1:ny            ,nx-(kx-1)/2+1:nx),Y(1:ny            ,1:nx),Y(1:ny            ,1:(kx-1)/2);...
    Y(1:(ky-1)/2      ,nx-(kx-1)/2+1:nx),Y(1:(ky-1)/2      ,1:nx),Y(1:(ky-1)/2      ,1:(kx-1)/2)];
% perform convolution
Ysm=zeros(ny,nx);
for j=1:ny
    for i=1:nx
        Ysm(j,i)=sum(sum(kernel.*YW(j:j+ky-1,i:i+kx-1)));
    end
end
figure;
imagesc(Ysm,[0,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ysm')
end

kernelfill=zeros(ny,nx);
if (mod(ky,2)==1)
    kernelfill(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=kernel;
elseif (mod(ky,2)==0)
    kernelfill(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=kernel;
end
if (showfigs==1)
    figure;
    imagesc(kernelfill,[0,1/25])
    colormap(gray), axis image, axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','kern25')
    end
    figure;
    imagesc(kernelfill(ny/2-3:ny/2+5,...
        nx/2-3:nx/2+5),[0,1/25])
    colormap(gray), axis image, axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','kern25z')
    end
end

ftkern=fftshift(fft2(fftshift(kernelfill)));
if (showfigs==1)
    maxftKern=max(max(ftkern));
    figure;
    imagesc(real(ftkern),[0,1])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftkernR25')
    end
    figure;
    imagesc(imag(ftkern),[0,.1])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftkernI25')
    end
end

ftY=fftshift(fft2(fftshift(Y)));
if (showfigs==1)
    maxftY=max(max(real(ftY)));
    figure;
    imagesc(log(abs(real(ftY))+1),[0,log(abs(maxftY)+1)])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftYR')
    end
    figure;
    imagesc(log(abs(imag(ftY))+1),[0,log(abs(maxftY)+1)])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftYI')
    end
end

YsmFT=fftshift(ifft2(fftshift(ftY.*ftkern)));
if (showfigs==1)
    figure;
    imagesc(real(YsmFT),[0,limMax])
    colormap(gray), axis image, axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','YsmFTR')
    end
    figure;
    imagesc(imag(YsmFT),[0,1])
    colormap(gray), axis image, axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','YsmFTI')
    end
end














