% Perform image space convolution with wrap around
% usage is O=MyCorr(I,template)
% I=input image, O=output image, k=template

function [O,psum,p2sum,ptsum]=MyCorr(I,template)

[a,b]=size(template);
[n,m]=size(I);
tvec=reshape(template',[a*b,1]);
nn=a*b;

O=zeros(n,m); psum=zeros(n,m); p2sum=zeros(n,m); ptsum=zeros(n,m);
is_a_even=~mod(a,2);
is_b_even=~mod(b,2);
if (is_a_even==0)&&(is_b_even==0)
    % appends border pixels for wrap-around
    IW=[I(n-(a-1)/2+1:n,m-(b-1)/2+1:m),I(n-(a-1)/2+1:n,1:m),I(n-(a-1)/2+1:n,1:(b-1)/2);...
        I(1:n          ,m-(b-1)/2+1:m),I(1:n          ,1:m),I(1:n          ,1:(b-1)/2);...
        I(1:(a-1)/2    ,m-(b-1)/2+1:m),I(1:(a-1)/2    ,1:m),I(1:(a-1)/2    ,1:(b-1)/2)];
    % perform correlation
    for j=1:n
        for i=1:m
            patch =reshape(IW(j:j+a-1,i:i+b-1)',[a*b,1]);
            psum(j,i)=sum(patch);
            p2sum(j,i)=sum(patch.^2);
            ptsum(j,i)=sum(patch.*tvec);
            tempcor=corrcoef(patch,tvec);
            O(j,i)=tempcor(1,2);
        end
    end
elseif(is_a_even==1)&&(is_b_even==1)
    % appends border pixels for wrap-around
    IW=[I(n-a/2+1:n,m-b/2+1:m),I(n-a/2+1:n     ,1:m),I(n-a/2+1:n,1:b/2);...
        I(1:n      ,m-b/2+1:m),I(1:n           ,1:m),I(1:n      ,1:b/2);...
        I(1:a/2    ,m-b/2+1:m),I(1:a/2         ,1:m),I(1:a/2    ,1:b/2)];
    % perform correlation
    for j=1:n
        for i=1:m
            patch =reshape(IW(j:j+a-1,i:i+b-1)',[a*b,1]);
            psum(j,i)=sum(patch);
            p2sum(j,i)=sum(patch.^2);
            ptsum(j,i)=sum(patch.*tvec);
%             tempcor=corrcoef(patch,tvec);
%             O(j,i)=tempcor(1,2);
        end
    end
end

% use psum, p2sum, ptsum,template
O=(ptsum-psum*sum(template(:))/nn)./(sqrt(p2sum-(psum.^2)/nn)*sqrt(sum(template(:).^2)-sum(template(:))^2/nn));

end






