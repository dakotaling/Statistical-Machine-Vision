
saveimage=0;
smoothtype=1; % 0 Gaussian, 1 is Binomial
k=5;

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

if (smoothtype==0)
    k=5;
    sigma2=0.5 %sigma2=8*log(2)*fwhm^2;
    gk=kernelG(k,sigma2);
    carSceneSm=MyConv(carScene,gk);
elseif (smoothtype==1)
    k=5;
    p=0.5      %sigma2=n*p*(1-p);
    gk=kernelB(k,p)
    carSceneSm=MyConv(carScene,gk);
end

figure;
imagesc(carSceneSm,[0,mx])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (smoothtype==0)
        print(gcf,'-dtiffn','-r100','carSceneG')
    elseif (smoothtype==1)
        print(gcf,'-dtiffn','-r100','carSceneB')
    end
end

sceneDiff=carSceneSm-double(carScene);

figure;
imagesc(sceneDiff,[-mx/10,mx/10])
axis image, colormap(gray), axis off
if (saveimage==1)
    if (smoothtype==0)
        print(gcf,'-dtiffn','-r100','SceneNDiff')
    elseif (smoothtype==1)
        print(gcf,'-dtiffn','-r100','SceneBDiff')
    end
end






