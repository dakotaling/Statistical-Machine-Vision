% Code inspired by Daniel Rowe
% Based on CarTemplateMatch.m
clear; clc;

saveimage=0;
load myposnegmapblk.txt
load myposmapblk.txt

I_rgb = imread('billards.jpg');
I = double(rgb2gray(I_rgb));

[ny, nx] = size(I);
limMin=0; limMax=255;

figure;
imagesc(I,[limMin,limMax])
axis image, colormap(gray), axis on
title('Original Pool Table Scene')
xlabel('Column (x)')
ylabel('Row (y)')
set(gca,'XTick',0:50:nx,'YTick',0:50:ny)
grid on
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','billiardScene')
end

% Extract first ball template
row_start1 = 125; row_end1 = 190;
col_start1 = 70; col_end1 = 140;

ball1 = I(row_start1:row_end1, col_start1:col_end1);
figure;
imagesc(ball1,[limMin,limMax])
axis image, colormap(gray), axis off
title('Ball 1 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ball1')
end

% Extract second ball template
row_start2 = 135; row_end2 = 210;
col_start2 = 210; col_end2 = 280;

ball2 = I(row_start2:row_end2, col_start2:col_end2);
figure;
imagesc(ball2,[limMin,limMax])
axis image, colormap(gray), axis off
title('Ball 2 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ball2')
end

% Extract third ball template
row_start3 = 130; row_end3 = 200;
col_start3 = 425; col_end3 = 495;

ball3 = I(row_start3:row_end3, col_start3:col_end3);
figure;
imagesc(ball3,[limMin,limMax])
axis image, colormap(gray), axis off
title('Ball 3 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ball3')
end

template1 = ball1;
[a1,b1] = size(template1);

template2 = ball2;
[a2,b2] = size(template2);

template3 = ball3;
[a3,b3] = size(template3);

% Template match for first ball
tsum1 = sum(template1(:)); 
t2sum1 = sum(template1(:).^2);
[O1,psum1,p2sum1,ptsum1] = MyCorr(I,template1);
Omax1 = max(max(O1));
[indy1,indx1] = find(O1==Omax1);
indy01 = indy1; indx01 = indx1;

% Template match for second ball
tsum2 = sum(template2(:)); 
t2sum2 = sum(template2(:).^2);
[O2,psum2,p2sum2,ptsum2] = MyCorr(I,template2);
Omax2 = max(max(O2));
[indy2,indx2] = find(O2==Omax2);
indy02 = indy2; indx02 = indx2;

% Template match for third ball
tsum3 = sum(template3(:)); 
t2sum3 = sum(template3(:).^2);
[O3,psum3,p2sum3,ptsum3] = MyCorr(I,template3);
Omax3 = max(max(O3));
[indy3,indx3] = find(O3==Omax3);
indy03 = indy3; indx03 = indx3;

figure;
imagesc(psum1,[0,a1*b1*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum - Ball 1 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum1')
end

figure;
imagesc(psum2,[0,a2*b2*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum - Ball 2 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum2')
end

figure;
imagesc(psum3,[0,a3*b3*limMax])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum - Ball 3 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum3')
end

figure;
imagesc(p2sum1,[0,a1*b1*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares - Ball 1 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum1')
end

figure;
imagesc(p2sum2,[0,a2*b2*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares - Ball 2 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum2')
end

figure;
imagesc(p2sum3,[0,a3*b3*limMax^2])
axis image, colormap(myposmapblk), axis off
title('Pixel Sum of Squares - Ball 3 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum3')
end

figure;
imagesc(ptsum1,[0,a1*b1*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel - Ball 1 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum1')
end

figure;
imagesc(ptsum2,[0,a2*b2*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel - Ball 2 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum2')
end

figure;
imagesc(ptsum3,[0,a3*b3*limMax^2/2])
axis image, colormap(myposmapblk), axis off
title('Sum of Template Pixel - Ball 3 Template')
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum3')
end

figure;
imagesc(O1,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image - Ball 1')
line([0.5+indx1-b1/2,0.5+indx1-b1/2],[0.5+indy1-a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1+b1/2,0.5+indx1+b1/2],[0.5+indy1-a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1-b1/2,0.5+indx1+b1/2],[0.5+indy1-a1/2,0.5+indy1-a1/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx1-b1/2,0.5+indx1+b1/2],[0.5+indy1+a1/2,0.5+indy1+a1/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg1')
end

figure;
imagesc(O2,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image - Ball 2')
line([0.5+indx2-b2/2,0.5+indx2-b2/2],[0.5+indy2-a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2+b2/2,0.5+indx2+b2/2],[0.5+indy2-a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2-b2/2,0.5+indx2+b2/2],[0.5+indy2-a2/2,0.5+indy2-a2/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx2-b2/2,0.5+indx2+b2/2],[0.5+indy2+a2/2,0.5+indy2+a2/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg2')
end

figure;
imagesc(O3,[-1,1])
axis image, colormap(myposnegmapblk), axis off
title('Correlation Image - Ball 3')
line([0.5+indx3-b3/2,0.5+indx3-b3/2],[0.5+indy3-a3/2,0.5+indy3+a3/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx3+b3/2,0.5+indx3+b3/2],[0.5+indy3-a3/2,0.5+indy3+a3/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx3-b3/2,0.5+indx3+b3/2],[0.5+indy3-a3/2,0.5+indy3-a3/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx3-b3/2,0.5+indx3+b3/2],[0.5+indy3+a3/2,0.5+indy3+a3/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg3')
end