% load original Car Scene image data
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
fxy=reshape(cardata,[ny,nx])';
%imwrite(uint8(fxy),'CarImage.tif','tif','Resolution',[300 300],'Compression','none');
saveimage=0;

mx=200; a=3; b=3;

figure;
imagesc(fxy,[0,mx])
axis image, colormap(gray), axis off

% extract car portion
car=fxy(93:104,27:64);
figure;
imagesc(car,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','car')
    %imwrite(uint8(car),'GrayCar.tif','tif');
end

% smooth Car portion without boundary
[n,m]=size(car);
carSm=zeros(n,m);
for j=1+1:n-1
    for i=1+1:m-1
        carSm(j,i)=(car(j-1,i)+car(j,i-1)+car(j,i)+car(j,i+1)+car(j+1,i))/5;
    end
end

% display smoothed car portion 
figure;
imagesc(carSm,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carSm')
end

% form car image with bordering ones for display
one=mx*ones(n,m);
carR=[one,one,one;
    one,car,one;
    one,one,one];
figure;
imagesc(carR,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carOPad')
end

%  form car image with bordering zeros
zro=zeros(n,m);
carZ=[zro,zro,zro;
    zro,car,zro;
    zro,zro,zro];
figure;
imagesc(carZ,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carZpad')
end

% form car image with bordering copies
carW=[car,car,car;
    car,car,car;
    car,car,car];

figure;
imagesc(carW,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carCpad')
end

% smooth car image with wrap around
[nn,mm]=size(carW);
carSmW=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSmW(j,i)=(carW(j-1,i)+carW(j,i-1)+carW(j,i)+carW(j,i+1)+carW(j+1,i))/5;
    end
end
carSmW(1:n,:)=[];
carSmW(n+1:end,:)=[];
carSmW(:,1:m)=[];
carSmW(:,m+1:end)=[];

figure;
imagesc(carSmW,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carSmW')
end

% smooth car image with zero copies
[nn,mm]=size(carR);
carSmZ=zeros(nn,mm);
for j=1+1:nn-1
    for i=1+1:mm-1
        carSmZ(j,i)=(carZ(j-1,i)+carZ(j,i-1)+carZ(j,i)+carZ(j,i+1)+carZ(j+1,i))/5;
    end
end
carSmZ(1:n,:)=[];
carSmZ(n+1:end,:)=[];
carSmZ(:,1:m)=[];
carSmZ(:,m+1:end)=[];

figure;
imagesc(carSmZ,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carSmZ')
end

% smooth car image with reweighting
carSmR=zeros(n,m);
for j=1:n
    for i=1:m
        % 1
        if (j>=1+(b-1)/2)&&(j<=n-(b-1)/2)&&(i>=1+(a-1)/2)&&(i<=m-(a-1)/2)
            carSmR(j,i)=(car(j-1,i)+car(j,i-1)+car(j,i)+car(j,i+1)+car(j+1,i))/5;
        % 2
        elseif(j==1)&&(i~=1)&&(i~=m)
            carSmR(j,i)=(car(j,i-1)+car(j,i)+car(j,i+1)+car(j+1,i+1))/4;
        % 3
        elseif(j==n)&&(i~=1)&&(i~=m)
            carSmR(j,i)=(car(j-1,i)+car(j,i-1)+car(j,i)+car(j,i+1))/4;
        % 4
        elseif(j~=1)&&(j~=n)&&(i==1)
            carSmR(j,i)=(car(j-1,i)+car(j,i)+car(j,i+1)+car(j+1,i+1))/4;
        % 5
        elseif(j~=1)&&(j~=n)&&(i==m)
            carSmR(j,i)=(car(j-1,i)+car(j,i-1)+car(j,i)+car(j+1,i))/4;
        % 6
        elseif(j==1)&&(i==1)
            carSmR(j,i)=(car(j,i)+car(j,i+1)+car(j+1,i))/3;
        % 7
        elseif(j==1)&&(i==m)
            carSmR(j,i)=(car(j,i-1)+car(j,i)+car(j+1,i))/3;
        % 8
        elseif(j==n)&&(i==1)
            carSmR(j,i)=(car(j-1,i)+car(j,i)+car(j,i+1))/3;
        % 9
         elseif(j==n)&&(i==m)
             carSmR(j,i)=(car(j-1,i)+car(j,i-1)+car(j,i))/3;
        end
    end
end

figure;
imagesc(carSmR,[0,mx])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','carSmR')
end





