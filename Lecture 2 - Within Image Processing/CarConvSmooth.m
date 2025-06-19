rng('default') 

saveimage=0;
noisetype=0; % 0 no noise, 1 is Gaussian, 2 is Salt and Peppper
% load oiginal car scene image
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
fxy=reshape(cardata,[ny,nx])';

mx=200; % image max

figure;
imagesc(fxy,[0,mx])
axis image, colormap(gray), axis off

%add noise to car scene image
if (noisetype==0)
    carScene=fxy;
elseif (noisetype==1)
    sigma=10;
    carScene=fxy+sigma*randn(ny,nx);
elseif (noisetype==2)
    d=0.01;
    carScene = imnoise(uint8(fxy),'salt & pepper',d);
end

figure;
imagesc(carScene,[0,mx])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100','carScene')
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100','carSceneN')
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100','carSceneSP')
    end
end

[n,m]=size(carScene);
carSceneW=[carScene,carScene,carScene;...
    carScene,carScene,carScene;...
    carScene,carScene,carScene];
carSceneW=double(carSceneW);

figure;
imagesc(carSceneW,[0,mx])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100','carSceneW')
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100','carSceneNW')
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100','carSceneSPW')
    end
end

[nn,mm]=size(carSceneW);
carSceneSmW=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSceneSmW(j,i)=(carSceneW(j-1,i)+carSceneW(j,i-1)+carSceneW(j,i)+carSceneW(j,i+1)+carSceneW(j+1,i))/5;
    end
end
carSceneSmW(1:n,:)=[];
carSceneSmW(n+1:end,:)=[];
carSceneSmW(:,1:m)=[];
carSceneSmW(:,m+1:end)=[];

figure;
imagesc(carSceneSmW,[0,mx])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100','carSceneSmW')
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100','carSceneSmNW')
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100','carSceneSmSPW')
    end
end

sceneDiff=carSceneSmW-double(carScene);

figure;
imagesc(sceneDiff,[-mx/10,mx/10])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100','SceneDiff')
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100','SceneNDiff')
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100','SceneSPDiff')
    end
end






