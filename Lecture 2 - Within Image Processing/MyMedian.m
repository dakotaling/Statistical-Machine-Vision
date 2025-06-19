% Perform image space convolution with wrap around
% usage is O=MyConv(I,a,b)
% I=input image, O=output image

function O=MyConv(I,a,b,c);

% load cardata.txt
% n=size(cardata,1);
% nx=sqrt(n); ny=nx;
% fxy=reshape(cardata,[ny,nx])';
% I=fxy;
% c=8
showfigs=0; savefigs=0;

if (showfigs==1)
    figure;
    imagesc(I)
    axis image, colormap(gray), axis off
    if (savefigs==1)
        print(gcf,'-dtiffn','-r100','I')
    end
end

[n,m]=size(I);

IW=[I(n-(a-1)/2+1:n,m-(b-1)/2+1:m),I(n-(a-1)/2+1:n,1:m-(a-1)/2+1),I(n-(a-1)/2+1:n,1:(b-1)/2);...
    I(1:n          ,m-(b-1)/2+1:m),I(1:n          ,1:m-(a-1)/2+1),I(1:n          ,1:(b-1)/2);...
    I(1:(a-1)/2    ,m-(b-1)/2+1:m),I(1:(a-1)/2    ,1:m-(a-1)/2+1),I(1:(a-1)/2    ,1:(b-1)/2)];

if (showfigs==1)
    figure;
    imagesc(IW)
    axis image, colormap(gray), axis off
    if (savefigs==1)
        print(gcf,'-dtiffn','-r100','IW')
    end
end

O=zeros(n+(a-1),m+(b-1));
for j=1+(a-1)/2:n+(a-1)/2
    for i=1+(b-1)/2:m+(b-1)/2
        if (c==8)
            patch =IW(j-(a-1)/2:j+(a-1)/2,i-(b-1)/2:i+(b-1)/2);
        elseif(c==4)
            patch=[IW(j-1,i),IW(j,i-1),IW(j,i),IW(j,i+1),IW(j+1,i)];
        end
        O(j,i)=median(patch(:));
    end
end
O(1:(a-1)/2,:)=[];
O(n+1:n+(a-1)/2,:)=[];
O(:,1:(b-1)/2)=[];
O(:,m+1:m+(b-1)/2)=[];

if (showfigs==1)
    figure;
    imagesc(O)
    axis image, colormap(gray), axis off
    if (savefigs==1)
        print(gcf,'-dtiffn','-r100','O')
    end
end






