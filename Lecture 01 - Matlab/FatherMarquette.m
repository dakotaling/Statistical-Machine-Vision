A = imread('FrMarquette.jpg');

figure;
imagesc(A)
axis image, axis off
%print(gcf,'-dtiffn','-r100',['ColorFr'])

I = rgb2gray(A);

figure;
imagesc(I)
axis image, axis off
colormap(hot)
%print(gcf,'-dtiffn','-r100',['GrayFr'])

imwrite(I,'GrayMarquette.jpg');
