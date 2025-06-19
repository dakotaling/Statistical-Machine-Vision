rng('default') 

saveimage=0;

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


gk=[0,0,1,0,0;0,1,2,1,0;1,2,-16,2,1;0,1,2,1,0;0,0,1,0,0];
carSceneLG=MyConv(carScene,gk);

figure;
histogram(carSceneLG)

figure;
imagesc(carSceneLG,[-500,500])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carSceneLG')
end

sceneDiff=carSceneLG-carScene;

figure;
histogram(sceneDiff)

figure;
imagesc(sceneDiff,[-500,500])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','SceneLGDiff')
end
