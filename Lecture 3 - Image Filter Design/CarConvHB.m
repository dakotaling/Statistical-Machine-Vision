rng('default') 

saveimage=1;

% load oiginal car scene image
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
fxy=reshape(cardata,[ny,nx])';

mx=200; % image max

carScene=fxy;

figure;
imagesc(carScene,[0,mx])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carScene')
end

k=5;
sigma2=0.5 %sigma2=8*log(2)*fwhm^2;
gk=kernelG(k,sigma2);
carSceneF=MyConv(carScene,gk);

figure;
histogram(carSceneF)

figure;
imagesc(carSceneF,[0,200])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneF')
end

sceneDiff=carSceneF-carScene;

figure;
imagesc(sceneDiff,[-40,40])
axis image, colormap(gray), axis off
%if (saveimage==1)
 %   print(gcf,'-dtiffn','-r100',['SceneHBDiff',num2str(A)])%end

A=3;
carSceneHB=A*carScene-carSceneF;
carSceneHB=255*carSceneHB/max(max(carSceneHB));
figure;
imagesc(carSceneHB,[0,200])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100',['SceneBoost',num2str(A)])
end

figure;
histogram(carSceneHB)


