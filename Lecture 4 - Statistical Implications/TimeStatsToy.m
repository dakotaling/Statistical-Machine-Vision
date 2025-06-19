% time series statistics
rng('default')
printfigs=0;

n=32;

mu=10;
sigma2=1;

x=sqrt(sigma2)*randn([1,n])+mu;

figure;
plot(x,'b')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xplot')
end

xbar=mean(x)
s2x=var(x)

%
kernel=[1/4,1/2,1/4];
k=length(kernel);

ywrap=[x(1,n),x,x(1,1)];
w=zeros(1,n+(k-1)/2);
for i=1+(k-1)/2:n+(k-1)/2
    w(1,i)=sum(ywrap(1,i-1:i+1).*kernel);
end
w=w(1,1+(k-1)/2:n+(k-1)/2);

wbar=mean(w)
s2w=var(w)

figure;
plot(x,'b')
hold on
plot(w,'r')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwSmplot')
end
figure;
plot(w,'r')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wSmplot')
end

% matrix version
figure;
imagesc(repmat(x',[1,4]),[5,15])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xIm')
end

a=[1/4,1/2,1/4,zeros(1,n-k)];
A=zeros(n,n);
for i=1:n
    A(i,:)=circshift(a,i-(k-1)/2-1);
end
figure;
imagesc(A,[0,1/2])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Amat')
end

u=A*x';

figure;
plot(x,'b')
hold on
plot(u,'k')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwuSmplot')
end

% matrix version
%printfigs=1;
figure;
imagesc(repmat(u,[1,4]),[5,15])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','uIm')
end

EAx=A*mu*ones(n,1);

AAt=A*A';

figure;
imagesc(AAt,[0,6/16])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAt')
end

R=diag(1./sqrt(diag(AAt)))*AAt*diag(1./sqrt(diag(AAt)));
R(1:10,1:10)

figure;
imagesc(R,[0,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','R')
end

Ainv=pinv(A);

figure;
imagesc(Ainv,[-10,10])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ainv')
end

figure;
imagesc(Ainv*A,[-1,1])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AinvA')
end

v=Ainv*w';

figure;
plot(x,'b')
hold on
plot(w,'r')
plot(v,'color',[0.4660 0.6740 0.1880])
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwvplot')
end


figure;
plot(v,'color',[0.4660 0.6740 0.1880])
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','vplot')
end

figure;
imagesc(repmat(v,[1,4]),[5,15])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','vIm')
end



figure;
imagesc(Ainv*A,[-1,1])
colormap(gray), axis image, axis off


%%%%%%%%%

% sample autocorrelation
numlags=20;
lagcorx=zeros(numlags,1); lagcovx=zeros(numlags,1);
lagcorw=zeros(numlags,1); lagcovw=zeros(numlags,1);
for t=1:numlags
    xx=circshift(x,t);
    temp=corrcoef(x,xx);
    lagcorx(t,1)=temp(1,2);
    temp=cov(x,xx);
    lagcovx(t,1)=temp(1,2);
    
    ww=circshift(w,t);
    temp=corrcoef(w,ww);
    lagcorw(t,1)=temp(1,2);
    temp=cov(w,ww);
    lagcovw(t,1)=temp(1,2);
end

[round((1:numlags)',0),lagcorx,lagcorw,lagcovx,lagcovw]
