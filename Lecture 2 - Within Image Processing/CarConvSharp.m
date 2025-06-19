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
carSceneShW=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSceneShW(j,i)=(carSceneW(j-1,i)+carSceneW(j,i-1)-4*carSceneW(j,i)+carSceneW(j,i+1)+carSceneW(j+1,i));
    end
end
carSceneShW(1:n,:)=[];
carSceneShW(n+1:end,:)=[];
carSceneShW(:,1:m)=[];
carSceneShW(:,m+1:end)=[];

figure;,histogram(carSceneShW)

figure;
imagesc(carSceneShW,[-100,100])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneShW')
end

sceneShDiff=carSceneShW-carScene;

figure;
imagesc(sceneShDiff,[-200,0])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','SceneShDiff')
end






