load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n);, ny=nx;
fxy=reshape(cardata,[ny,nx])';
imwrite(uint8(fxy),'CarImage.tif','tif','Resolution',[300 300],'Compression','none');

x=(1:nx); y=(1:ny);
[X,Y]=meshgrid(x,y);
figure;
surf(X,Y,fliplr(fxy)), colormap(gray)
set(gca,'xtick',[0:20:nx])
set(gca,'ytick',[0:20:ny])
az=140;, el=60;, view(az,el)
%print(gcf,'-dtiffn','-r100',['CarScene3D'])

figure;
imagesc(fxy)
axis image, colormap(turbo)
axis off
% set(gca,'xtick',[0:20:nx])
% set(gca,'ytick',[0:20:ny])
%imwrite(fxy,'CarImageHot.tif','tif','Resolution',[300 300],'Compression','none');
print(gcf,'-dtiffn','-r100',['CarSceneHot'])


car=uint8(fxy(93:104,27:64));
figure;
imagesc(car)
axis image, colormap(gray), axis off
%print(gcf,'-dtiffn','-r100',['car'])
imwrite(car,'GrayCar.tif','tif');

filename = 'cardata.xlsx';
%writematrix(car,filename,'Sheet',1,'Range','A1')

