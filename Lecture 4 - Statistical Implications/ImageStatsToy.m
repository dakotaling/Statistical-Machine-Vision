% image statistics
rng('default')
printfigs=0;
load myposnegmapblk.txt

nx=8; ny=nx;
limMin=75; limMax=125; yhist=15;

mu=100; sigma2=20;
N=sqrt(sigma2)*randn([ny,nx]);
I=mu+N; 

Ibar=mean(I(:)), s2I=var(I(:))

figure;
imagesc(I,[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','I')
end
figure;
histogram(I(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ihist')
end
figure;
imagesc(repmat(reshape(I',nx*ny,1),[1,4]),[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','IvecIm')
end
% perform convolution
kernel=[  0,1/8,  0;...
        1/8,1/2,1/8;...
          0,1/8,  0];
O=MyConv(I,kernel);

figure;
imagesc(O,[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','O')
end
figure;
histogram(O(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ohist')
end
figure;
imagesc(repmat(reshape(O',nx*ny,1),[1,4]),...
    [limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','OvecIm')
end
Obar=mean(O(:)), s2O=var(O(:))
% form kernel with wrap
krnl=[1/2,1/8,  0,  0,  0,  0,  0,1/8;...
      1/8,  0,  0,  0,  0,  0,  0,  0;...
        0,  0,  0,  0,  0,  0,  0,  0;...
        0,  0,  0,  0,  0,  0,  0,  0;...
        0,  0,  0,  0,  0,  0,  0,  0;...
        0,  0,  0,  0,  0,  0,  0,  0;...
        0,  0,  0,  0,  0,  0,  0,  0;...
      1/8,  0,  0,  0,  0,  0,  0,  0]; 
% form convolution matrix
A=zeros(ny*nx,ny*nx);
for j=1:ny
    if (j~=1)
        krnl=[krnl(ny,:);krnl(1:ny-1,:)];
    end
    A((j-1)*nx+1,:)=reshape(krnl',[nx*ny,1])';
    for i=(j-1)*nx+2:j*nx
        krnl=[krnl(:,nx),krnl(:,1:nx-1)];
        A(i,:)=reshape(krnl',[nx*ny,1])';
    end
    krnl=[krnl(:,nx),krnl(:,1:nx-1)];
end
figure;
imagesc(A,[0,5/16])
axis image, axis off, colormap(gray)  
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','A')
end
figure;
imagesc(A,[-5/16,5/16])
axis image, axis off , colormap(myposnegmapblk)  
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Acolor')
end
% induced covariance
AAt=A*A';
figure;
imagesc(AAt,[0,5/16])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAt')
end
figure;
imagesc(AAt,[-5/16,5/16])
colormap(myposnegmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAtc')
end
% induced correlation
R=diag(1./sqrt(diag(AAt)))*AAt*diag(1./sqrt(diag(AAt)));
figure;
imagesc(R,[0,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','R')
end
figure;
imagesc(R,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Rcolor')
end
% perform matrix convolution
Ivec=reshape(I',nx*ny,1);
Wvec=A*Ivec;
W=reshape(Wvec,nx,ny)';
figure;
imagesc(W,[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','W')
end
figure;
histogram(W(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Whist')
end
figure;
imagesc(repmat(reshape(W',nx*ny,1),[1,4]),[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','WvecIm')
end
Wbar=mean(W(:)), s2W=var(W(:))
% compute deconvolution matrix
invA=pinv(A);
figure;
histogram(invA(:))
figure;
imagesc(invA,[-1,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','invA')
end
figure;
histogram(invA(:))
figure;
imagesc(invA,[-1,1])
colormap(myposnegmapblk), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','invAcolor')
end
% perform deconvoution
Vvec=invA*Wvec;
V=reshape(Vvec,nx,ny)';
figure;
imagesc(V,[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','V')
end
figure;
histogram(V(:),(limMin:2:limMax))
xlim([limMin,limMax]), ylim([0,yhist])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Vhist')
end
figure;
imagesc(repmat(reshape(V',nx*ny,1),[1,4]),[limMin,limMax])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','VvecIm')
end
Vbar=mean(V(:)), s2V=var(V(:))

% visualize correlation
% pick center pixel ny/2+1,nx/2+1

pixnum=ny/2*nx+nx/2+1;
r=R(pixnum,:);
corImage=reshape(r,[nx,ny])';
figure;
imagesc(corImage,[-1,1])
axis image, axis off , colormap(myposnegmapblk)  
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','corImage')
end



% extras
figure;
imagesc(invA*A,[-1,1])
colormap(myposnegmapblk), axis image, axis off



pixnum=ny/2*nx+nx/2+1;
r=invA(pixnum,:);
corImage=reshape(r,[nx,ny])';
figure;
imagesc(corImage,[-1,1])
axis image, axis off , colormap(myposnegmapblk)  










