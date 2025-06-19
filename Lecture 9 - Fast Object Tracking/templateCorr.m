% Rowe FT Correlation Template Matching %
% First template matchng performed by double for loop that moves 
% template around and calculates the correlation between it and 
% the pixels under it. x is the template and y is the pixels under 
% Next, template matching performed by using the FFT to calculate 
% sum(xy),sum(y),sum(y^2), and precompute sum(x), sum(x^2), and hence 
% var(x) from the template.

% read mp4 files
clear all
close all
load myposnegmapblk.txt

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
    I(:,:,t)=(rgb2gray(videoRGB(:,:,:,t)));%histeq
end
clear videoRGB

figure; % display video frames
%pause
for t=1:nt
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    title(['Frame ',num2str(t)])
    pause(.1)
end

% extract and form template
gt500=squeeze(I(444:595,1318:1849,158));
figure;
imagesc(gt500)
colormap(gray), axis image, axis off
%imwrite(gt500,gray,'myGT.tif','Compression','none')
% edited in paint to make black background
myGT=double(imread('myGT.tif'));
gt500=myGT(:,:,1); %set gt500 to be first dimension
myGT(:,:,2:4)=[]; % delete dimensions 2-4
figure;
imagesc(gt500)
colormap(gray), axis image, axis off
%print(gcf,'-dtiffn','-r100','gt500')


% template match for car one image%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample image of scene
t=140; It140=squeeze(I(:,:,t));
figure; % select one sample frame for convolution
imagesc(It140,[0,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','It140')
end

template=gt500;
[a,b]=size(template);
Sx=sum(template(:)); Sx2=sum(template(:).^2);

% super slow image space template match
tvec=reshape(template',[a*b,1]);
nn=a*b;
O=zeros(ny,nx,nt); Omax=zeros(3,nt);
% perform correlation - takes a really long time
for t=150:161%1:2%nt % decrese frames
    psum=zeros(ny,nx); p2sum=zeros(ny,nx); ptsum=zeros(ny,nx);
    % appends border pixels for wrap-around
    IW=squeeze([I(ny-a/2+1:ny,nx-b/2+1:nx,t),I(ny-a/2+1:ny,1:nx,t),I(ny-a/2+1:ny,1:b/2,t);...
                I(1:ny       ,nx-b/2+1:nx,t),I(1:ny       ,1:nx,t),I(1:ny       ,1:b/2,t);...
                I(1:a/2      ,nx-b/2+1:nx,t),I(1:a/2      ,1:nx,t),I(1:a/2      ,1:b/2,t)]);
    for j=440:595%1:ny      % decrease search area
        for i=50:nx-50%1:nx % decrease search area
            patch =reshape(squeeze(IW(j:j+a-1,i:i+b-1))',[a*b,1]);
            psum(j,i)=sum(patch);
            p2sum(j,i)=sum(patch.^2);
            ptsum(j,i)=sum(patch.*tvec);
        end
    end
    O(:,:,t)=(ptsum-psum*Sx/nn)./(sqrt(p2sum-(psum.^2)/nn)*sqrt(Sx2-Sx^2/nn));
    Omax(3,t)=max(max(squeeze(O(:,:,t))));
    tmp=Omax(3,t);
    [indy,indx]=find(squeeze(O(:,:,t))==tmp);
    Omax(1:2,t)=[indy,indx];
end
clear tmp t j i

figure;
for t=150:159%1:nt
    indy=Omax(1,t); indx=Omax(2,t);
    imagesc(O(:,:,t),[-1,1])
    axis image, colormap(myposnegmapblk), axis off
    line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
    line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
    line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,0,1],'LineWidth',1.0)
    line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
    pause(.5)
end




% Tempate FFT based correlation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% precompute kernel sum(x), sum(x^2), and var(x)
Sx=sum(template(:)); 
Sx2=sum(template(:).^2);
Varx=(Sx2-Sx^2/(a*b))/(a*b-1);

% generate a kernel of ones the same size as template
tones=ones(a,b);
figure;
imagesc(tones,[0,1/25])
colormap(gray), axis image, axis off
line([0.5,b-.5],[.5,.5],'Color',...
    [0,0,0],'LineWidth',1)
line([0.5,b-.5],[a-.5,a-.5],'Color',....
    [0,0,0],'LineWidth',1)
line([0.5,.5],[.5,a-.5],'Color',...
    [0,0,0],'LineWidth',1)
line([b-.5,b-.5],[.5,a-.5],'Color',...
    [0,0,0],'LineWidth',1)
%print(gcf,'-dtiffn','-r100','tones')

% place ones template at the center of an image of zeros
tonesfill=zeros(ny,nx);
%tonesfill(ny/2-a/2+1:ny/2+a/2,...
%    nx/2-b/2+1:nx/2+b/2)=tones;
[ky,kx]=size(tones);
if (mod(ky,2)==1)
    tonesfill(ny/2-(ky-1)/2+1:ny/2+(ky-1)/2+1,...
        nx/2-(kx-1)/2+1:nx/2+(kx-1)/2+1)=tones;
elseif (mod(ky,2)==0)
    tonesfill(ny/2-ky/2+1:ny/2+ky/2,nx/2-kx/2+1:nx/2+kx/2)=tones;
end
if (showfigs==1)
    figure;
    imagesc(tones,[0,1])
    axis image, colormap(gray), axis off
    figure;
    imagesc(tonesfill,[0,1])
    axis image, colormap(gray), axis off
    %print(gcf,'-dtiffn','-r100','tonesfill')
end

% calculate the FFT of the centered kernel of ones
ftt1fill=fftshift(fft2(fftshift(tonesfill)));
if (showfigs==1)
    maxftt1fill=max(max(ftt1fill));
    figure;
    imagesc(log(abs(real(ftt1fill))+1),[0,15])
    axis image, colormap(gray), axis off
    %print(gcf,'-dtiffn','-r100','ftt1fillR')
    figure;
    imagesc(log(abs(imag(ftt1fill))+1),[0,15])
    axis image, colormap(gray), axis off
    %print(gcf,'-dtiffn','-r100','ftt1fillI')
end

% place the template at the center of an image of zeros
tfill=zeros(ny,nx); indx=961; indy=541;
tfill(ny/2-a/2+1:ny/2+a/2,...
    nx/2-b/2+1:nx/2+b/2)=template;
figure;
imagesc(tfill,[0,255])
colormap(gray), axis image, axis off
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],...
    'Color',[.2,.2,.2],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],...
    'Color',[.2,.2,.2],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],...
    'Color',[.2,.2,.2],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],...
    'Color',[.2,.2,.2],'LineWidth',1.0)
print(gcf,'-dtiffn','-r100','tfill')

% calculate the FFT of the centered template
fttfill=fftshift(fft2(fftshift(tfill)));
if (showfigs==1)
    maxftftt1fill=max(max(fttfill));
    figure;
    imagesc(log(abs(real(fttfill))+1),[0,15])
    axis image, colormap(gray), axis off
    %print(gcf,'-dtiffn','-r100','fttfillR')
    figure;
    imagesc(log(abs(imag(fttfill))+1),[0,15])
    axis image, colormap(gray), axis off
    %print(gcf,'-dtiffn','-r100','fttfillI')
end

% track in one sample image frame
% calculate the FFT of the image scene
t=140;
ftIt140=fftshift(fft2(fftshift(squeeze(I(:,:,t)))));
if (showfigs==1)
    maxftIt140=max(max(ftIt140));
    figure;
    imagesc(log(abs(real(ftIt140))+1),[0,15])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftIt140R')
    end
    figure;
    imagesc(log(abs(imag(ftIt140))+1),[0,15])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftIt140I')
    end
end

% image square for sample frame
figure; 
imagesc(squeeze(I(:,:,t)).^2,[0,limMax^2])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['I2',num2str(t)])
end

% calculate the FFT of the image square
ftI2t140=fftshift(fft2(fftshift((squeeze(I(:,:,t)).^2))));
if (showfigs==1)
    maxftI2t140=max(max(ftI2t140));
    figure;
    imagesc(log(abs(real(ftI2t140))+1),[0,30])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftI2t140R')
    end
    figure;
    imagesc(log(abs(imag(ftI2t140))+1),[0,30])
    axis image, colormap(gray), axis off
    if (printfigs==1)
        print(gcf,'-dtiffn','-r100','ftI2t140I')
    end
end

% calculate the local sum(y) via FFT
Sy =real(fftshift(ifft2(fftshift(ftIt140 .*ftt1fill))));
figure;
imagesc(real(Sy),[0,a*b*255])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','SyR')
end
figure;
imagesc(imag(Sy),[0,a*b*255])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','SyI')
end

% calculate the local sum(y^2) via FFT
Sy2=real(fftshift(ifft2(fftshift(ftI2t140.*ftt1fill))));
figure;
imagesc(real(Sy2),[0,a*b*255^2])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Sy2R')
end
figure;
imagesc(imag(Sy2),[0,a*b*255^2])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Sy2I')
end

% calculate the local sum(xy) via FFT
Sxy=real(fftshift(ifft2(fftshift(ftIt140.*conj((fttfill))))));
figure;
maxSxy=max(max(real(Sxy(:))));
imagesc(real(Sxy),[0,maxSxy])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','SxyR')
end
figure;
imagesc(imag(Sxy),[0,1])
axis image, colormap(gray), axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','SxyI')
end

% put it all together and compute correlation
Vary=(Sy2-(Sy.^2)/(a*b))/(a*b-1);
CovxyI140=(Sxy-(Sx*Sy)/(a*b))/(a*b-1);
CorxyI140=CovxyI140./sqrt((Varx)*(Vary));
% find max val and indices for box
maxval=max(max(CorxyI140));
Cor140max(3,t)=maxval;
tmp=Cor140max(3,t);
[indy,indx]=find(CorxyI140==tmp);
Cor140max(1:2,t)=[indy,indx];
figure;
imagesc(CorxyI140,[-1,1])
axis image, colormap(myposnegmapblk), axis off
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','CorxyI140cl')
end
figure;
imagesc(It140,[0,limMax])
axis image, colormap(gray), axis off
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,0,1],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','CorxyI140bw')
end

% track through all images
Corxy=zeros(ny,nx,nt);
figure;
pause
for t=1:nt
    % calculate the FFT of the image scene
    ftI=fftshift(fft2(fftshift(squeeze(I(:,:,t)))));
    % calculate the FFT of the image square
    ftI2=fftshift(fft2(fftshift((squeeze(I(:,:,t)).^2))));
    
    % calculate the local sum(y) via FFT
    Sy =real(fftshift(ifft2(fftshift(ftI .*ftt1fill))));
    % calculate the local sum(y^2) via FFT
    Sy2=real(fftshift(ifft2(fftshift(ftI2.*ftt1fill))));
    
    % calculate variance of y
    Vary=(Sy2-(Sy.^2)/(a*b))/(a*b-1);
    % compute sum(xy) between template x and pixels under y
    Sxy=real(fftshift(ifft2(fftshift(ftI.*conj((fttfill))))));
    % compute covariance between template x and pixels under y
    Covxy=(Sxy-(Sx*Sy)/(a*b))/(a*b-1);
    Corxy(:,:,t)=Covxy./sqrt((Varx)*(Vary));
    
    % find max val and indices for box
    maxval=max(max(squeeze(Corxy(:,:,t))));
    Cor140max(3,t)=maxval;
    tmp=Cor140max(3,t);
    [indy,indx]=find(squeeze(Corxy(:,:,t))==tmp);
    Cor140max(1:2,t)=[indy,indx]
    
    % display correlation image and matched location
%     imagesc(Corxy(:,:,t),[-1,1])
%     axis image, colormap(myposnegmapblk), axis off
    imagesc(I(:,:,t),[0,limMax])
    axis image, colormap(gray), axis off
    title(['Image ',num2str(t)])
    if (tmp>=0.5) % if high correlation place a magenta box around
        line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
    end
    pause(.000001)
end
clear ftI ftI2 ftt1fill

% save grayscale video
figure;
pause
if (savevideo==1)
    vidfile = VideoWriter('TrackShelbyCor.avi','Uncompressed AVI');
    %vidfile = VideoWriter('TrackShelby.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
     set(gca,'Position', get(gca, 'OuterPosition'));
     set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
%     imagesc(I(:,:,t),[0,limMax])
%     axis image, colormap(gray), axis off
    imagesc(Corxy(:,:,t),[-1,1])
    axis image, colormap(myposnegmapblk), axis off
    title(['Image ',num2str(t)])
    indy=Cor140max(1,t); indx=Cor140max(2,t);
    if (Cor140max(3,t)>=0.5) % if high correlation place a magenta box around
        if (indx>b/2)&&(indx<nx-b/2)
        line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,0,1],'LineWidth',1.0)
        line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,0,1],'LineWidth',1.0)
        end
    end
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
