% Code inspired by Professor Daniel Rowe Lecture 01
clear; clc;

n=128; m=128;
fxy=zeros(n,m);
for i=1:n
    for j=1:m
        fxy(i,j)=(1/(2*pi))*exp(-(1/2)*((i-n/2)^2+(j-m/2)^2)/100);
    end
end

x=(1:n); y=(1:m);
[X,Y]=meshgrid(x,y);
figure;
surf(X,Y,fxy)
set(gca,'xtick',[0:16:128])
set(gca,'ytick',[0:16:128])

% Save the workspace and figures
save('HW1_Question2')
print(gcf,'-dtiffn','-r100',['GaussianSurface'])

vecfxy=reshape(fxy,[n*m,1]);
dlmwrite('MyVecfxy.txt',vecfxy,'\t')
load MyVecfxy.txt
Newfxy=reshape(MyVecfxy,[n,m]);
figure;
imagesc(Newfxy), colormap(jet), axis off, axis image