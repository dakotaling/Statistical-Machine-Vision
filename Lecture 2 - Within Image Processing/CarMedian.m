% median filter image
rng('default') 
saveimage=0;
noisetype=2;

load cardata.txt
n=size(cardata,1);
nx=sqrt(n); ny=nx;
fxy=double(reshape(cardata,[ny,nx])');

figure;
imagesc(fxy,[0,200])
axis image, colormap(gray), axis off

%add noise to car scene image
if (noisetype==0)
    carScene=fxy;
elseif (noisetype==1)
    sigma=10;
    carScene=fxy+sigma*randn(ny,nx);
elseif (noisetype==2)
    d=0.01;
    carScene = double(imnoise(uint8(fxy),'salt & pepper',d));
end

figure;
imagesc(carScene,[0,200])
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

a=3; b=3; c=4
carSceneMedian=MyMedian(carScene,a,b,c);

figure;
imagesc(carSceneMedian,[0,200])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100',['carSceneMdW',num2str(c)])
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100',['carSceneMdNW',num2str(c)])
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100',['carSceneMdSPW',num2str(c)])
    end
end

sceneMdDiff=carSceneMedian-carScene;

figure;
imagesc(sceneMdDiff,[-20,20])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (noisetype==0)
        print(gcf,'-dtiffn','-r100',['SceneMdDiff',num2str(c)])
    elseif (noisetype==1)
        print(gcf,'-dtiffn','-r100',['SceneMdNDiff',num2str(c)])
    elseif(noisetype==2)
        print(gcf,'-dtiffn','-r100',['SceneMdSPDiff',num2str(c)])
    end
end


