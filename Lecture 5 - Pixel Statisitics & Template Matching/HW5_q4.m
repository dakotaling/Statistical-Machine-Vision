% Code inspired by Daniel Rowe
% Based on CarTemplateMatch.m structure
clear; clc;

saveimage=0;
load myposnegmapblk.txt
load myposmapblk.txt

I_rgb = imread('two_cups.jpg');
I = double(I_rgb);

[ny, nx] = size(I);
limMin=0; limMax=255;

figure;
imagesc(I,[limMin,limMax])
axis image, colormap(gray), axis off
title('Original Scene with Two Mugs')
set(gca,'XTick',0:50:nx,'YTick',0:50:ny)
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','mugScene')
end

% Extract white mug template
mug1 = I(50:250, 50:280);
figure;
imagesc(mug1,[limMin,limMax])
axis image, colormap(gray), axis off
title('White Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','whiteMug')
end

% Extract black mug template
mug2 = I(50:250, 350:580);
figure;
imagesc(mug2,[limMin,limMax])
axis image, colormap(gray), axis off
title('Black Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','blackMug')
end

template1 = mug1;
[a1,b1] = size(template1);

template2 = mug2;
[a2,b2] = size(template2);

% Template match for white mug
tsum1 = sum(template1(:)); 
t2sum1 = sum(template1(:).^2);
[O1,psum1,p2sum1,ptsum1] = MyCorr(I,template1);
Omax1 = max(max(O1));
[indy1,indx1] = find(O1==Omax1);
indy01 = indy1; indx01 = indx1;

% Template match for black mug
tsum2 = sum(template2(:)); 
t2sum2 = sum(template2(:).^2);
[O2,psum2,p2sum2,ptsum2] = MyCorr(I,template2);
Omax2 = max(max(O2));
[indy2,indx2] = find(O2==Omax2);
indy02 = indy2; indx02 = indx2;

figure;
imagesc(psum1,[0,a1*b1*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum - White Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum1')
end

figure;
imagesc(p2sum1,[0,a1*b1*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares - White Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum1')
end

figure;
imagesc(ptsum1,[0,a1*b1*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel - White Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum1')
end

figure;
imagesc(O1,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image - White Mug')
line([0.5+indx1-b1/2,0.5+indx1-b1/2],[0.5+indy1-a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1+b1/2,0.5+indx1+b1/2],[0.5+indy1-a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1-b1/2,0.5+indx1+b1/2],[0.5+indy1-a1/2,0.5+indy1-a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1-b1/2,0.5+indx1+b1/2],[0.5+indy1+a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg1')
end

figure;
imagesc(psum2,[0,a2*b2*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum - Black Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum2')
end

figure;
imagesc(p2sum2,[0,a2*b2*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares - Black Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum2')
end

figure;
imagesc(ptsum2,[0,a2*b2*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel - Black Mug Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum2')
end

figure;
imagesc(O2,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image - Black Mug')
line([0.5+indx2-b2/2,0.5+indx2-b2/2],[0.5+indy2-a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2+b2/2,0.5+indx2+b2/2],[0.5+indy2-a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2-b2/2,0.5+indx2+b2/2],[0.5+indy2-a2/2,0.5+indy2-a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2-b2/2,0.5+indx2+b2/2],[0.5+indy2+a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg2')
end