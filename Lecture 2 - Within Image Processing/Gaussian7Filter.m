% Code inspired by Professor Daniel Rowe

function O=Gaussian7Filter(I)

% 7x7 Gaussian-like smoothing kernel
sigma=1.5;
kernel=zeros(7,7);
center=4; 

for i=1:7
    for j=1:7
        dist=(i-center)^2+(j-center)^2;
        kernel(j,i)=exp(-dist/(2*sigma^2));
    end
end

kernel=kernel/sum(kernel(:));
[a,b]=size(kernel);
[n,m]=size(I);

% appends border pixels for wrap-around
pad = (a-1)/2;
IW=[I(n-pad+1:n,m-pad+1:m),I(n-pad+1:n,1:m),I(n-pad+1:n,1:pad);...
    I(1:n        ,m-pad+1:m),I(1:n        ,1:m),I(1:n        ,1:pad);...
    I(1:pad      ,m-pad+1:m),I(1:pad      ,1:m),I(1:pad      ,1:pad)];

O=zeros(n,m);
for j=1:n
    for i=1:m
        patch = IW(j:j+a-1,i:i+b-1);
        O(j,i)=sum(sum(patch.*kernel));
    end
end

end