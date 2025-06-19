function O=EmbossFilter(I)

% 5x5 emboss kernel
kernel=[-2, -1,  0,  1,  2;
         -1, -1,  0,  1,  1;
          0,  0,  0,  0,  0;
          1,  1,  0, -1, -1;
          2,  1,  0, -1, -2];

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

% add offset to make emboss effect visible
O = O + 128;

% clip to valid range
O(O<0) = 0;
O(O>255) = 255;

end