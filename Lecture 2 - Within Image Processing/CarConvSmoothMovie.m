

saveimage=0;

% load oiginal car scene image
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
fxy=reshape(cardata,[ny,nx])';

mx=200; % image max

figure;
imagesc(fxy,[0,mx])
axis image, colormap(gray), axis off

carScene=fxy;


figure;
imagesc(carScene,[0,mx])
axis image, colormap(gray), axis off

[n,m]=size(carScene);
carSceneW=[carScene,carScene,carScene;...
    carScene,carScene,carScene;...
    carScene,carScene,carScene];
carSceneW=double(carSceneW);

figure;
imagesc(carSceneW,[0,mx])
axis image, colormap(gray), axis off

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

sceneDiff=carSceneSmW-double(carScene);

figure;
imagesc(sceneDiff,[-mx/10,mx/10])
axis image, colormap(gray), axis off





