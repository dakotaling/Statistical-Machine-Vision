% Code inspired by Daniel Rowe
% Based on CarTemplateMatch.m structure
clear; clc;

saveimage=0;
load myposnegmapblk.txt
load myposmapblk.txt

I_rgb = imread('FrMarquette.jpg');

I = double(rgb2gray(I_rgb));
[ny, nx] = size(I);

limMin=0; limMax=255;

figure;
imagesc(I,[limMin,limMax])
axis image, colormap(gray), axis on
title('Original Scene with Coordinates')
xlabel('Column (x)')
ylabel('Row (y)')
grid on
set(gca,'XTick',0:500:nx,'YTick',0:500:ny)
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','statueScene')
end

statue_head = I(650:800, 1280:1420);
% Extract statue head 
figure;
imagesc(statue_head,[limMin,limMax])
axis image, colormap(gray), axis off
title('Statue Head Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','statueHead')
end

% templatematch for statue head
tsum = sum(template(:)); t2sum = sum(template(:).^2);
[O,psum,p2sum,ptsum] = MyCorr(I,template);
Omax = max(max(O));
[indy,indx] = find(O==Omax);
indy0 = indy; indx0 = indx;
% display pixel sums
figure;
imagesc(psum,[0,a*b*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum Image')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum')
end
figure;
histogram(psum(:),100)
title('Histogram of Pixel Sum')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histpsum')
end

figure;
imagesc(p2sum,[0,a*b*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares Image')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum')
end
figure;
histogram(p2sum(:),100)
title('Histogram of Pixel Sum of Squares')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histp2sum')
end

figure;
imagesc(ptsum,[0,a*b*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel Image')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum')
end
figure;
histogram(ptsum(:),100)
title('Histogram of Sum of Template Pixel')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histptsum')
end

figure;
imagesc(O,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image')
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg')
end

figure;
histogram(O(:),[-1:.02:1])
title('Histogram of Correlation Image')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histCorImg')
end

rhoTH=0.75;
Othresh=O;
for j=1:ny
    for i=1:nx
        if abs(O(j,i))<=rhoTH
            Othresh(j,i)=0;
        end
    end
end

figure;
imagesc(Othresh,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Thresholded Correlation Image')
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImgThresh')
end

over=O;
thresh=.2;
under=I;
[newmap,supmap,newanat] = superimpose(under,over,thresh,1);
figure;
image(newmap);
axis image, axis off, colormap(supmap)
title('Superimposed Result')
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)