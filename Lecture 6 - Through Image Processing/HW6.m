% Code inspired by Daniel Rowe
clear all
close all

saveimage=0;
savevideo=0;
load myposnegmapblk.txt
load myposmapblk.txt

% QUESTION 1: Load video and cycle through frames
% video file name
filename='train.mp4';

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
    I(:,:,t)=histeq(rgb2gray(videoRGB(:,:,:,t)));
end
clear videoRGB

% QUESTION 1: Display frames
figure;
for t=1:25:nt
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    title(['Train Frame ',num2str(t)])
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['trainScene',num2str(t)])
    end
    pause(0.5)
end

figure;
if (savevideo==1)
    vidfile = VideoWriter('trainHistEq.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I(:,:,t))
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

% QUESTION 2: Apply spatial convolution kernel to each frame
% Define spatial convolution kernel
spatial_kernel = [1/16, 2/16, 1/16;...
                  2/16, 4/16, 2/16;...
                  1/16, 2/16, 1/16];

% Apply spatial convolution
I_spatial = zeros(ny,nx,nt);
for t=1:nt
    I_spatial(:,:,t) = MyConv(squeeze(I(:,:,t)), spatial_kernel);
end

% Compare original vs convolution
figure;
for t=1:25:nt
    subplot(1,2,1)
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    title(['Original Frame ',num2str(t)])
    
    subplot(1,2,2)
    imagesc(I_spatial(:,:,t))
    colormap(gray), axis image, axis off
    title(['Spatially Convolved Frame ',num2str(t)])
    
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['trainSpatialComp',num2str(t)])
    end
    pause(0.5)
end

% Save video
figure;
if (savevideo==1)
    vidfile = VideoWriter('trainSpatialConv.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I_spatial(:,:,t))
    colormap(gray), axis image, axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end

% QUESTION 2: Compare spatial filtering effects on pixel time series
px=round(nx/2); py=round(ny/2);

figure;
plot(squeeze(I(py,px,:)),'r','LineWidth',1.5)
hold on
plot(squeeze(I_spatial(py,px,:)),'b','LineWidth',1.5)
xlim([0,nt]),ylim([1,255])
title('Spatial Convolution Comparison')
legend('Original','Spatial Filtered')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['trainSpatial',num2str(py),'px',num2str(px)])
end

% QUESTION 3: Apply temporal convolution kernel to pixel time series
% Use 4-point temporal averaging kernel
temporal_kernel=[1/16,3/16,5/16,7/16];
k=length(temporal_kernel);
I_temporal=zeros(ny,nx,nt);

% Apply temporal convolution
for t=1:nt
    if (t==1)
        I_temporal(:,:,t)=I(:,:,t);
    elseif(t==2)
        ksum=sum([temporal_kernel(1,k-1),temporal_kernel(1,k)]);
        I_temporal(:,:,t)=(temporal_kernel(1,k-1)/ksum)*I(:,:,t-1)+...
            (temporal_kernel(1,k)/ksum)*I(:,:,t);
    elseif(t==3)
        ksum=sum([temporal_kernel(1,k-2),temporal_kernel(1,k-1),temporal_kernel(1,k)]);
        I_temporal(:,:,t)=(temporal_kernel(1,k-2)/ksum)*I(:,:,t-2)+...
            (temporal_kernel(1,k-1)/ksum)*I(:,:,t-1)+(temporal_kernel(1,k)/ksum)*I(:,:,t);
    elseif(t>=4)
        I_temporal(:,:,t)=temporal_kernel(1,k-3)*I(:,:,t-3)+temporal_kernel(1,k-2)*I(:,:,t-2)+...
            temporal_kernel(1,k-1)*I(:,:,t-1)+temporal_kernel(1,k)*I(:,:,t);
    end
end

% plot for temporal filtering
figure;
plot(squeeze(I(py,px,:)),'r','LineWidth',1.1)
hold on
plot(squeeze(I_temporal(py,px,:)),'b','LineWidth',1.1)
xlim([0,nt]),ylim([1,255])
title('Temporal Convolution Comparison')
legend('Original','Temporal Filtered')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['trainTemporal',num2str(py),'px',num2str(px)])
end

% Save video
figure;
if (savevideo==1)
    vidfile = VideoWriter('trainTemporalConv.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I_temporal(:,:,t))
    colormap(gray), axis image, axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end

% QUESTION 4: Implement recursive filter
% Create recursive filter matrix
w=3/4;
B=zeros(nt,nt);
B(1,1)=1;
for t=2:nt
    B(t,:)=[(1-w)^(t-1),B(t-1,1:nt-1)];
end
B=w*B;

% Apply recursive filter to all pixels
I_recursive=zeros(ny,nx,nt);
for j=1:ny
    for i=1:nx
        I_recursive(j,i,:)=B*squeeze(I(j,i,:));
    end
end

% recursive filter
figure;
if (savevideo==1)
    vidfile = VideoWriter(['trainRecursiveSeriespy',num2str(py),'px',num2str(px),'.mp4'],'MPEG-4');
    open(vidfile);
end
for t=1:nt
    plot(squeeze(I(py,px,1:t)),'r','LineWidth',1.1)
    hold on
    plot(squeeze(I_recursive(py,px,1:t)),'g','LineWidth',1.1)
    set(gcf,'color','w');
    xlim([0,nt]),ylim([1,255])
    title('Red: Original, Green: Recursive Filter')
    legend('Original','Recursive Filtered')
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
    hold off
end
if (savevideo==1)
    close(vidfile)
end

% Save video
figure;
if (savevideo==1)
    vidfile = VideoWriter('trainRecursive.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I_recursive(:,:,t))
    colormap(gray), axis image, axis off
    set(gca,'position',[0 0 1 1],'units','normalized')
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end

% comparison
figure;
for t=1:10:nt
    subplot(2,2,1)
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    title(['Original Frame ',num2str(t)])
    
    subplot(2,2,2)
    imagesc(I_spatial(:,:,t))
    colormap(gray), axis image, axis off
    title(['Spatial Convolution Frame ',num2str(t)])
    
    subplot(2,2,3)
    imagesc(I_temporal(:,:,t))
    colormap(gray), axis image, axis off
    title(['Temporal Convolution Frame ',num2str(t)])
    
    subplot(2,2,4)
    imagesc(I_recursive(:,:,t))
    colormap(gray), axis image, axis off
    title(['Recursive Filter Frame ',num2str(t)])
    
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['trainComparison',num2str(t)])
    end
    pause(0.5)
end

% temporal matrix
A=zeros(nt,nt);
for t=1:nt
    if (t==1)
        A(1,1)=1;
    elseif (t==2)
        ksum=sum(temporal_kernel(1,k-1:k));
        A(t,1:2)=temporal_kernel(1,k-1:k)/ksum;
    elseif (t==3)
        ksum=sum(temporal_kernel(1,k-2:k));
        A(t,1:3)=temporal_kernel(1,k-2:k)/ksum;
    elseif (t>=4)
        A(t,t-k+1:t)=temporal_kernel;
    end
end

figure;
imagesc(A,[0,1])
colormap(gray), axis image, axis off
title('Temporal Convolution Matrix A')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','trainA')
end

% recursive filter matrix
figure;
imagesc(B,[0,1])
colormap(myposmapblk), axis image, axis off
title('Recursive Filter Matrix B')
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','trainB')
end