saveimage=0;
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
fxy=reshape(cardata,[ny,nx])';

mx=200; sigma=10;

figure;
imagesc(fxy,[0,200])
axis image, colormap(gray), axis off

carScene=fxy;

figure;
imagesc(carScene,[0,200])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carScene')
end

[n,m]=size(carScene);
carSceneW=[carScene,carScene,carScene;...
    carScene,carScene,carScene;...
    carScene,carScene,carScene];
carSceneW=double(carSceneW);

figure;
imagesc(carSceneW,[0,200])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneW')
end

[nn,mm]=size(carSceneW);
%
carSceneGrUDW=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSceneGrUDW(j,i)=(-carSceneW(j-1,i-1)-carSceneW(j-1,i)-carSceneW(j-1,i+1)...
                          +carSceneW(j+1,i-1)+carSceneW(j+1,i)+carSceneW(j+1,i+1));
    end
end
carSceneGrUDW(1:n,:)=[];
carSceneGrUDW(n+1:end,:)=[];
carSceneGrUDW(:,1:m)=[];
carSceneGrUDW(:,m+1:end)=[];

figure;
imagesc(carSceneGrUDW,[-100,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneGRUDW')
end

sceneGrLRDiff=carSceneGrUDW-carScene;

figure;
imagesc(sceneGrLRDiff,[-300,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','SceneGRUDDiff')
end
%
carSceneGrLRW=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSceneGrLRW(j,i)=(-carSceneW(j-1,i-1)-carSceneW(j,i-1)-carSceneW(j+1,i-1)...
                          +carSceneW(j-1,i+1)+carSceneW(j,i+1)+carSceneW(j+1,i+1));
    end
end
carSceneGrLRW(1:n,:)=[];
carSceneGrLRW(n+1:end,:)=[];
carSceneGrLRW(:,1:m)=[];
carSceneGrLRW(:,m+1:end)=[];

figure;
imagesc(carSceneGrLRW,[-100,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneGRLRW')
end

sceneGrLRDiff=carSceneGrLRW-carScene;

figure;
imagesc(sceneGrLRDiff,[-300,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','SceneGRLRDiff')
end

carSceneGrMgW=sqrt(carSceneGrUDW.^2+carSceneGrLRW.^2);

figure;
imagesc(carSceneGrMgW,[-100,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneGRMgW')
end

%sceneGrMgDiff=carSceneGrMgW-carScene;

% figure;
% imagesc(sceneGrMgDiff,[-300,100])
% axis image, colormap(gray), axis off
% if (saveimage==1)
%     print(gcf,'-dtiffn','-r100','SceneGRMgDiff')
% end

carSceneGrAngW=atan2(carSceneGrUDW,carSceneGrLRW);

figure;
imagesc(carSceneGrAngW,[-pi,pi])
axis image, colormap(gray), axis off
%if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneGRAngW')
%end


%sceneGrAngDiff=carSceneGrAngW-carScene;

% figure;
% histogram(sceneGrAngDiff)

% figure;
% imagesc(sceneGrAngDiff,[-200,0])
% axis image, colormap(gray), axis off
% if (saveimage==1)
%     print(gcf,'-dtiffn','-r100','SceneGRMgDiff')
% end



