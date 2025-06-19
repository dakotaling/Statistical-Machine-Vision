% Perform image space convolution with wrap around
% usage is O=MyConv(I,kernel)
% I=input image, O=output image, k=linear kernel

function O=MyConv(I,kernel);

% get sizes of kernel and image
[a,b]=size(kernel);
[n,m]=size(I);

% appends border pixels for wrap-around
IW=[I(n-(a-1)/2+1:n,m-(b-1)/2+1:m),I(n-(a-1)/2+1:n,1:m),I(n-(a-1)/2+1:n,1:(b-1)/2);...
    I(1:n          ,m-(b-1)/2+1:m),I(1:n          ,1:m),I(1:n          ,1:(b-1)/2);...
    I(1:(a-1)/2    ,m-(b-1)/2+1:m),I(1:(a-1)/2    ,1:m),I(1:(a-1)/2    ,1:(b-1)/2)];

O=zeros(n+(a-1),m+(b-1));
for j=1+(a-1)/2:n+(a-1)/2
    for i=1+(b-1)/2:m+(b-1)/2
        patch =IW(j-(a-1)/2:j+(a-1)/2,i-(b-1)/2:i+(b-1)/2);
        O(j,i)=sum(sum(patch.*kernel));
    end
end
% remove appended pixels
O(1:(a-1)/2,:)=[];
O(n+1:n+(a-1)/2,:)=[];
O(:,1:(b-1)/2)=[];
O(:,m+1:m+(b-1)/2)=[];

end






