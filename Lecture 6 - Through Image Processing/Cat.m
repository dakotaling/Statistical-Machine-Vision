% read mp4 files
clear all
close all

saveimage=0;
savevideo=1;
load myposnegmapblk.txt
load myposmapblk.txt

% video file name
filename='Cat.mp4';

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
% write out some frames
figure;
for t=1:25:nt
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['catScene',num2str(t)])
    end
end
% view and write out grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('catHistEq.avi','Uncompressed AVI');
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

%pick out pixel of interest
figure;
imagesc(I(:,:,101))
colormap(gray), axis image, axis off
px=915; py=460;

% matrix version
figure;
imagesc(repmat(squeeze(I(py,px,:)),[1,25]),[165,205])
colormap(gray), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','tsIm')
end

% average all frames together
vidmean=mean(I,3);
figure;
imagesc(vidmean)
colormap(gray),axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','catSceneMean')
end
figure;
imagesc(vidmean,[0,255])
colormap(myposmapblk),axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','catSceneMeancolor')
end
vidvar=var(I,0,3);
figure;
imagesc(vidvar,[0,1750])
colormap(myposmapblk),axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','catSceneVarcolor')
end
figure;
histogram(vidvar(:))

% view video and average
figure;
for t=1:nt
    subplot(1,2,1)
    imagesc(I(:,:,t))
    colormap(gray),axis image, axis off
    title(['Frame ',num2str(t)])
    subplot(1,2,2)
    imagesc(vidmean)
    colormap(gray),axis image, axis off
    pause(.001)
end

x=squeeze(I(py,px,:));
figure;
plot(squeeze(I(py,px,:)),'r')
xlim([0,nt]),ylim([1,255])
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['catSceneTSpy',num2str(py),'px',num2str(px)])
end


figure;
if (savevideo==1)
    vidfile = VideoWriter(['catseriesIpy',num2str(py),'px',num2str(px),'.mp4'],'MPEG-4');
    open(vidfile);
end
for t=1:nt
    plot(squeeze(I(py,px,1:t)),'r','LineWidth',1.1)
    set(gcf,'color','w');
    line([ 51, 51],[0,255])
    line([ 76, 76],[0,255])
    line([101,101],[0,255])
    line([126,126],[0,255])
    line([151,151],[0,255])
    line([176,176],[0,255])
    xlim([0,nt]),ylim([1,255])
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
    pause(.05)
end
if (savevideo==1)
    close(vidfile)
end


% % % perform 3 pt temporal averaging
% % kernel=[1/8,2/8,5/8];
% % k=length(kernel);
Ovid3=zeros(ny,nx,nt);
% % for t=1:nt
% %     if (t==1)
% %         Ovid3(:,:,t)=I(:,:,t);
% %     elseif(t==2)
% %         ksum=sum([kernel(1,k-1),kernel(1,k)]);
% %         Ovid3(:,:,t)=(kernel(1,k-1)/ksum)*I(:,:,t)+(kernel(1,k)/ksum)*I(:,:,t);
% %     elseif(t>=3)
% %         Ovid3(:,:,t)=kernel(1,k-2)*I(:,:,t-2)+kernel(1,k-1)*I(:,:,t-1)+kernel(1,k)*I(:,:,t);
% %     end
% % end
% % figure;
% % for t=1:nt
% %     plot(squeeze(I(py,px,1:t)),'r','LineWidth',1.1)
% %     hold on
% %     plot(squeeze(Ovid3(py,px,1:t)),'b','LineWidth',1.1)
% %     set(gcf,'color','w');
% %     line([ 51, 51],[0,255])
% %     line([ 76, 76],[0,255])
% %     line([101,101],[0,255])
% %     line([126,126],[0,255])
% %     line([151,151],[0,255])
% %     line([176,176],[0,255])
% %     xlim([0,nt]),ylim([1,255])
% %     pause(.05)
% % end
% % figure;
% % plot(squeeze(I(py,px,:)),'r','LineWidth',1.1)
% % hold on
% % plot(squeeze(Ovid3(py,px,:)),'b','LineWidth',1.1)
% % set(gcf,'color','w');
% % line([ 51, 51],[0,255])
% % line([ 76, 76],[0,255])
% % line([101,101],[0,255])
% % line([126,126],[0,255])
% % line([151,151],[0,255])
% % line([176,176],[0,255])
% % xlim([0,nt]),ylim([1,255])
% % if (saveimage==1)
% %     print(gcf,'-dtiffn','-r100',['catIO3',num2str(py),'px',num2str(px)])
% % end
% % 
% % % view grayscale video
% % figure;
% % for t=1:nt
% %     imagesc(Ovid3(:,:,t))
% %     xlim([0,nt]),ylim([1,255])
% %     title(['Frame ',num2str(t)])
% %     colormap(gray), axis image, axis off
% %     pause(1/fr)
% % end


% perform 4 pt temporal averaging
kernel=[1/16,3/16,5/16,7/16];
k=length(kernel);
Ovid4=zeros(ny,nx,nt);
for t=1:nt
    if (t==1)
        Ovid4(:,:,t)=I(:,:,t);
    elseif(t==2)
        ksum=sum([kernel(1,k-1),kernel(1,k)]);
        Ovid4(:,:,t)=(kernel(1,k-1)/ksum)*I(:,:,t-1)+...
            (kernel(1,k)/ksum)*I(:,:,t);
    elseif(t==3)
        ksum=sum([kernel(1,k-2),kernel(1,k-1),kernel(1,k)]);
        Ovid4(:,:,t)=(kernel(1,k-2)/ksum)*I(:,:,t-2)+...
            (kernel(1,k-1)/ksum)*I(:,:,k-1)+(kernel(1,k)/ksum)*I(:,:,t);
    elseif(t>=4)
        Ovid4(:,:,t)=kernel(1,k-3)*I(:,:,t-3)+kernel(1,k-2)*I(:,:,t-2)+...
            kernel(1,k-1)*I(:,:,t-1)+kernel(1,k)*I(:,:,t);
    end
end
figure;
if (savevideo==1)
    vidfile = VideoWriter(['catseries4py',num2str(py),'px',num2str(px),'.mp4'],'MPEG-4');
    open(vidfile);
end
for t=1:nt
    plot(squeeze(I(py,px,1:t)),'r','LineWidth',1.1)
    hold on
    plot(squeeze(Ovid4(py,px,1:t)),'b','LineWidth',1.1)
    set(gcf,'color','w');
    line([ 51, 51],[0,255])
    line([ 76, 76],[0,255])
    line([101,101],[0,255])
    line([126,126],[0,255])
    line([151,151],[0,255])
    line([176,176],[0,255])
    xlim([0,nt]),ylim([1,255])
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end
  
figure;
plot(squeeze(I(py,px,:)),'r')
hold on
plot(squeeze(Ovid4(py,px,:)),'b')
xlim([0,nt]),ylim([1,255])
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['catIO4',num2str(py),'px',num2str(px)])
end

% write out some frames
figure;
for t=1:25:nt
    imagesc(Ovid4(:,:,t))
    colormap(gray), axis image, axis off
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['catSceneO4',num2str(t)])
    end
end

% matrix version of ts
figure;
imagesc(repmat(squeeze(Ovid4(py,px,:)),[1,25]),[165,205])
colormap(gray), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','tsO4')
end

% view grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('catVid4.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(Ovid4(:,:,t))
    %title(['Frame ',num2str(t)])
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

%kernel=[1/16,3/16,5/16,7/16];
%k=length(kernel);
A=zeros(nt,nt);
for t=1:nt
    if (t==1)
        A(1,1)=1;
    elseif (t==2)
        ksum=sum(kernel(1,k-1:k));
        A(t,1:2)=kernel(1,k-1:k)/ksum;
    elseif (t==3)
        ksum=sum(kernel(1,k-2:k));
        A(t,1:3)=kernel(1,k-2:k)/ksum;
    elseif (t>=4)
        A(t,t-k+1:t)=kernel;
    end
end

figure;
imagesc(A,[0,1])
colormap(gray), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','A')
end
figure;
imagesc(A(1:4,1:4),[0,1])
colormap(gray), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','A4by4')
end
figure;
imagesc(A,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','Acolor')
end
figure;
imagesc(A(3:8,3:8),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','A3x8')
end
figure;
imagesc(A',[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','Atcolor')
end
AAt=A*A';
figure;
imagesc(AAt,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','AAtcolor')
end
figure;
imagesc(AAt(1:7,1:7),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','AAt7by7')
end
D=diag(1./sqrt(diag(AAt)));
corAAt=D*AAt*D;
figure;
imagesc(corAAt,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','corAAt')
end
figure;
imagesc(corAAt(1:7,1:7),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','corAAt7by7')
end




% smooth and perform 2 pt difference
% O=zeros(ny,nx,nt);
% kernel=[  0,1/8,  0;...
%         1/8,1/2,1/8;...
%           0,1/8,  0];
% Ovid2=zeros(ny,nx,nt);
for t=1:nt
    %O(:,:,t)=MyConv(squeeze(I(:,:,t)),kernel);
    if (t>=2)
        Ovid2(:,:,t)=I(:,:,t)-I(:,:,t-1);
    end
end

lim2=100;
figure;
if (savevideo==1)
    vidfile = VideoWriter(['catseriesO2py',num2str(py),'px',num2str(px),'.mp4'],'MPEG-4');
    open(vidfile);
end
for t=1:nt
    plot(squeeze(I(py,px,1:t))-202,'r','LineWidth',1.1)
    hold on
    plot(squeeze(Ovid2(py,px,1:t)),'b','LineWidth',1.1)
    set(gcf,'color','w');
    line([ 51, 51],[-lim2,lim2])
    line([ 76, 76],[-lim2,lim2])
    line([101,101],[-lim2,lim2])
    line([126,126],[-lim2,lim2])
    line([151,151],[-lim2,lim2])
    line([176,176],[-lim2,lim2])
    xlim([0,nt]),ylim([-lim2,lim2])
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
    pause(.05)
end
if (savevideo==1)
    close(vidfile)
end


% view grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('catVid2.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
     set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(Ovid2(:,:,t))
    %title(['Frame ',num2str(t)])
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

% write out some frames
figure;
for t=1:25:nt
    imagesc(Ovid2(:,:,t))
    colormap(gray), axis image, axis off
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['catSceneO2',num2str(t)])
    end
end

% write out some frames
figure;
for t=101-3:101
    imagesc(I(:,:,t))
    colormap(gray), axis image, axis off
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['catScene',num2str(t)])
    end
end

% temporal recursive filter
w=3/4;
B=zeros(nt,nt);
B(1,1)=1;
for t=2:nt
    B(t,:)=[(1-w)^(t-1),B(t-1,1:nt-1)];
end
B=w*B;

figure;
imagesc(B,[0,1])
colormap(myposmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','B')
end
figure;
imagesc(B(1:4,1:4),[0,1])
colormap(myposmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','B4by4')
end
figure;
imagesc(B,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','Bcolor')
end
figure;
imagesc(B(3:8,3:8),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','B3x8')
end
figure;
imagesc(B',[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','Btcolor')
end
BBt=B*B';
figure;
imagesc(BBt,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','BBtcolor')
end
figure;
imagesc(BBt(1:7,1:7),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','BBt7by7')
end
corBBt=diag(1./sqrt(diag(BBt)))*BBt*diag(1./sqrt(diag(BBt)));
figure;
imagesc(corBBt,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','corBBt')
end
figure;
imagesc(corBBt(1:7,1:7),[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','corBBt7by7')
end

OR=zeros(ny,nx,nt);
for j=1:ny
    for i=1:nx
        OR(j,i,:)=B*squeeze(I(j,i,:));
    end
end

figure;
plot(squeeze(I(py,px,:)),'r','LineWidth',1.1)
hold on
plot(squeeze(Ovid3(py,px,:)),'b','LineWidth',1.1)
plot(squeeze(OR(py,px,:)),'g','LineWidth',1.1)
set(gcf,'color','w');
line([ 51, 51],[0,255])
line([ 76, 76],[0,255])
line([101,101],[0,255])
line([126,126],[0,255])
line([151,151],[0,255])
line([176,176],[0,255])
xlim([0,nt]),ylim([1,255])
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['catIO3R',num2str(py),'px',num2str(px)])
end


% write out some frames
figure;
for t=1:25:nt
    imagesc(OR(:,:,t))
    colormap(gray), axis image, axis off
    if (saveimage==1)
        print(gcf,'-dtiffn','-r100',['catSceneOR',num2str(t)])
    end
end










figure;
if (savevideo==1)
    vidfile = VideoWriter(['catseriesRpy',num2str(py),'px',num2str(px),'.mp4'],'MPEG-4');
    open(vidfile);
end
for t=1:nt
    plot(squeeze(I(py,px,1:t)),'r','LineWidth',1.1)
    hold on
    plot(squeeze(OR(py,px,1:t)),'g','LineWidth',1.1)
    set(gcf,'color','w');
    line([ 51, 51],[0,255])
    line([ 76, 76],[0,255])
    line([101,101],[0,255])
    line([126,126],[0,255])
    line([151,151],[0,255])
    line([176,176],[0,255])
    xlim([0,nt]),ylim([1,255])
    if (savevideo==1)
        F(t) = getframe(gcf);
        writeVideo(vidfile,F(t));
    end
end
if (savevideo==1)
    close(vidfile)
end


% view grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('catVidR.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(OR(:,:,t))
    %title(['Frame ',num2str(t)])
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

% subtract avg of last 10 from all
ImeanLast100=mean(I(:,:,nt-100+1:nt),3);
figure;
for t=1:nt
    imagesc(I(:,:,t)-ImeanLast100)
    colormap(gray), axis image, axis off
    pause(.1)
end




% view grayscale video
figure;
if (savevideo==1)
    vidfile = VideoWriter('catSbtMeanL100.avi','Uncompressed AVI');
    V.FrameRate = fr;
    V.Quality = 100;
    set(gca, 'Position', get(gca, 'OuterPosition'));
    set(gca,'visible','off')
    open(vidfile);
end
for t=1:nt
    imagesc(I(:,:,t)-ImeanLast100)
    %title(['Frame ',num2str(t)])
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



