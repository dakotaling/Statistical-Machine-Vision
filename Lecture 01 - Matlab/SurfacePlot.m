n=128; m=128;
fxy=zeros(n,m);
for i=1:n
    for j=1:m
        fxy(i,j)=(i-n/2)^2+(j-m/2)^2;
    end
end

x=(1:n); y=(1:m);
[X,Y] = meshgrid(x,y);
figure;
surf(X,Y,fxy)
set(gca,'xtick',[0:16:128])
set(gca,'ytick',[0:16:128])
%print(gcf,'-dtiffn','-r100',['MySurf'])

figure;
imagesc(fxy)
colormap(jet)
set(gca,'xtick',[0:16:128])
set(gca,'ytick',[0:16:128])
axis image
%print(gcf,'-dtiffn','-r100',['MyImage'])

%save('MySurfData') % saves entire worksheet

%save('Myfxy','fxy','X','Y') % saves fxy, X, Y in file Myfxy.mat

vecfxy=reshape(fxy,[n*m,1]);
dlmwrite('MyVecfxy.txt',vecfxy,'\t')
load MyVecfxy.txt
Newfxy=reshape(MyVecfxy,[n,m]);
figure;
imagesc(Newfxy), colormap(jet), axis off, axis image



