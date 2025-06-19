% image statistics
printfigs=0;
load myposnegmapblk.txt
load myposmapblk.txt

limMin=0; limMaxI=200; yhist=400; yhist2=2000;

% form kernel convolution
kernel=[0,1,0;...
        1,1,1;...
        0,1,0];
ksum=sum(kernel(:));

load cardata.txt
[n,p]=size(cardata);
nx=sqrt(n); ny=nx;
I=double(reshape(cardata,[ny,nx])');

% original image statistics
Ibar=mean(I(:)), s2I=var(I(:))
figure;
imagesc(I,[limMin,limMaxI])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','I')
end
figure;
histogram(I(:),(limMin:2:limMaxI))
xlim([limMin,limMaxI]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ihist')
end

I2=I.^2; 
I2bar=mean(I2(:)), s2I2=var(I2(:))
figure;
imagesc(I2,[limMin,limMaxI^2])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','I2')
end
figure;
histogram(I2(:),50)
xlim([limMin,limMaxI^2]), ylim([0,yhist2])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','I2hist')
end

% calculate local sum statistics
O=MyConv(I,kernel);
Obar=mean(O(:)), s2O=var(O(:)) 
figure;
imagesc(O,[limMin,ksum*limMaxI])
colormap(myposmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ocolor')
end
figure;
histogram(O(:),(limMin:8:5*limMaxI))
xlim([limMin,5*limMaxI]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ohist')
end

% compute local sum of image square
O2=MyConv(I2,kernel);
O2bar=mean(O2(:)), s2O2=var(O2(:))
figure;
imagesc(O2,[limMin,ksum*limMaxI^2])
colormap(myposmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','O2color')
end
figure;
histogram(O2(:),50)
xlim([limMin,ksum*limMaxI^2]), ylim([0,yhist2])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','O2hist')
end


figure;
imagesc(O.^2)
colormap(myposmapblk), axis image, axis off

S2=(O2-(O.^2)/ksum)/(ksum-1);

figure;
imagesc(S2,[0,2000])
colormap(myposmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','S2color')
end










