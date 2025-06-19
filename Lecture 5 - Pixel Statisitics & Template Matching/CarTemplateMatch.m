% template matching code
saveimage=0;
load myposnegmapblk.txt
load myposmapblk.txt

% load oiginal car scene image
load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
I=reshape(double(cardata),[ny,nx])';

limMin=0; limMax=200;

figure;
imagesc(I,[limMin,limMax])
axis image, colormap(gray), axis off
if (saveimage==1)
    print(gcf,'-dtiffn','-r100','carScene')
end

car=I(93:104,27:64);
% extract car portion
figure;
imagesc(car,[limMin,limMax])
axis image, colormap(gray), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','car')
end

% templatematch for car
template=car;
[a,b]=size(template);
tsum=sum(template(:)); t2sum=sum(template(:).^2);
[O,psum,p2sum,ptsum]=MyCorr(I,template);
Omax=max(max(O));
[indy,indx]=find(O==Omax)
indy0=indy; indx0=indx;
% display pixel sums
figure;
imagesc(psum,[0,a*b*limMax])
axis image, colormap(myposmapblk), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','psum')
end
figure;
histogram(psum(:),100)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histpsum')
end
figure;
imagesc(p2sum,[0,a*b*limMax^2])
axis image, colormap(myposmapblk), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','p2sum')
end
figure;
histogram(p2sum(:),100)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histp2sum')
end
figure;
imagesc(ptsum,[0,a*b*limMax^2/2])
axis image, colormap(myposmapblk), axis off
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','ptsum')
end
figure;
histogram(ptsum,100)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','histptsum')
end

figure;
imagesc(O,[-1,1])
axis image, colormap(myposnegmapblk), axis off
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImg')
end

figure;
histogram(O(:),[-1:.02:1])
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
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImgThresh')
end


% 
% figure;
% for t=1:nx
%     I=circshift(I,1,2);
%     imagesc(I,[limMin,limMax])
%     axis image, colormap(gray), axis off
%     pause(.1)
% end
% 
% O=zeros(ny,nx);
% figure;
% for t=1:nx
%     J=circshift(I,t,2)+20*randn(ny,nx);
%     O=MyCorr(J,template);
%     Omax=max(max(O));
%     [indy,indx]=find(O==Omax)
%     imagesc(O,[-1,1])
%     axis image, colormap(myposnegmapblk), axis off
%     line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
%     line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
%     line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
%     line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
%     pause(.01)
% end


over=O;
thresh=.2;
under=I;
[newmap,supmap,newanat] = superimpose(under,over,thresh,1);
figure;
image(newmap);
axis image, axis off, colormap(supmap)
line([0.5+indx-b/2,0.5+indx-b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx+b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy-a/2,0.5+indy-a/2],'Color',[1,1,0],'LineWidth',1.0)
line([0.5+indx-b/2,0.5+indx+b/2],[0.5+indy+a/2,0.5+indy+a/2],'Color',[1,1,0],'LineWidth',1.0)
if(saveimage==1)
    print(gcf,'-dtiffn','-r100','corImgThreshSup')
end





