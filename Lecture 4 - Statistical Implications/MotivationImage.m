% Image Statistics Motivation
rng('default')
printfigs=0;

nx=32; ny=nx;
mu=100; sigma2=20;

I0=ones(ny,nx);
N=sqrt(sigma2)*randn([ny,nx])+mu;
I=I0+N;

limMin=0; limMax=250; histmax=250;
figure;
imagesc(I,[limMin,limMax])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['I',num2str(limMax)])
end

figure;
histogram(I(:),[(0:1:limMax)])
xlim([limMin,limMax]), ylim([0,histmax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['Ihist',num2str(limMax)])
end

Ibar=mean(I(:)), Ivar= var(I(:))

% multiply all values by 2
O1=2*I;

figure;
imagesc(O1,[limMin,limMax])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['O1',num2str(limMax)])
end

figure;
histogram(O1(:),[(0:1:limMax)])
xlim([limMin,limMax]), ylim([0,histmax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['O1hist',num2str(limMax)])
end

O1bar=mean(O1(:)), O1var= var(O1(:))

% smooth 3x3 average
limMin=0; limMax=125; histmax=250;
figure;
imagesc(I,[limMin,limMax])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['I',num2str(limMax)])
end

figure;
histogram(I(:),[(0:1:limMax)])
xlim([limMin,limMax]), ylim([0,histmax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['Ihist',num2str(limMax)])
end

kernel=ones([3,3])/9;
O2=MyConv(I,kernel);

figure;
imagesc(O2,[limMin,limMax])
axis image, axis off, colormap(gray)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['O2',num2str(limMax)])
end

figure;
histogram(O2(:),[(0:1:limMax)])
xlim([limMin,limMax]), ylim([0,histmax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100',['O2hist',num2str(limMax)])
end

O2bar=mean(O2(:)), O2var= var(O2(:))

% % correlation
% O2ones=zeros(3600,1); O2twos=zeros(7200,1);  O2threes=zeros(7200,1); 
% count1=0; count2=0; count3=0;
% for i=2:nx-1
%     for j=2:ny-1
%         for a=i-2:i+2
%             for b=j-2:j+2
%                 if     (abs(i-a)+abs(j-b)==1)
%                     count1=count1+1;
%                 elseif (abs(i-a)+abs(j-b)==2)
%                     count2=count2+1;
%                 elseif (abs(i-a)+abs(j-b)==3)
%                     count3=count3+1;
%                 end
%             end
%         end
%     end
% end
% [count1,count2,count3]






