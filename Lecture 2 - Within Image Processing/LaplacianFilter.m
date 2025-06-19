% Code inspired by Professor Daniel Rowe

function O=LaplacianFilter(I)

% Laplacian sharpening kernel (like in CarConvSharp.m)
kernel=[0,  1,  0;
        1, -4,  1;
        0,  1,  0];

[a,b]=size(kernel);
[n,m]=size(I);

% appends border pixels for wrap-around (same approach as your MyConv.m)
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