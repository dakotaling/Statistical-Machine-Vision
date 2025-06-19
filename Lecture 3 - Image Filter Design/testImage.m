% flag whether to save images of figures
savefigs=0

% image dimensions
ny=200; nx=200;

% test image
I0=zeros(ny/4,nx/4);
I1=255*ones(ny/4,ny/4);
IS=repmat((1:4:nx),[ny/4,1]);
IB=[0*ones(ny/20,nx/2);64*ones(ny/20,nx/2);128*ones(ny/20,nx/2);192*ones(ny/20,nx/2);255*ones(ny/20,nx/2)];
IL=123*ones(ny/4,ny/4);
IL(1:4,:)=220;
IL(11:14,:)=30;
IL(21:24,:)=75;
IL(31:34,:)=180;
IL(41:44,:)=255;
IL(ny/4,:)=0;
IP=(IL+rot90(IL))/2;
IP=255*IP/max(max(IP));

IR=imrotate(repmat(IL,[4,4]),45,'crop');
IR(151:200,:)=[];
IR(1:100,:)=[];
IR(:,151:200)=[];
IR(:,1:100)=[];

figure;
imagesc(IR,[0,255])
colormap(gray),axis image,axis off

test=[I0,I1,IS,rot90(IS,2);...
    I1,I0,IB;...
    rot90(IS,3),rot90(IB(:,1:nx/4)),     IP,IL;...
    rot90(IS,1),rot90(IB(:,nx/4+1:nx/2)),rot90(IL,1),IR];

figure;
imagesc(test,[0,255])
colormap(gray),axis image,axis off
%print(gcf,'-dtiffn','-r100','testImage')
imwrite(uint8(test),'MyTest.tif');
imwrite(uint8(test),'MyTest.jpg');
MyTest=test;

%save('MyTest','MyTest')




