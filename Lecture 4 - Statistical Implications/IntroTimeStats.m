% time series statistics
rng('default')
printfigs=0;

n=512; mu=100; sigma2=20;
limMin=0; limMax=250; 

N=sqrt(sigma2)*randn([n,n]);
I=mu+N; x=I(n/2+1,:);

figure;
imagesc(I,[limMin,limMax])
axis image, axis off, colormap(gray)
line([0,n+.5]     ,[n/2+.5,n/2+.5]    ,'Color',[0,0,1],'LineWidth',.01)
line([0,n+.5]     ,[n/2+1+.5,n/2+1+.5],'Color',[0,0,1],'LineWidth',.01)
line([0+1/2,0+1/2],[n/2+.5,n/2+1+.5]  ,'Color',[0,0,1],'LineWidth',.01)
line([n+.5,n+.5]  ,[n/2+.5,n/2+1+.5]  ,'Color',[0,0,1],'LineWidth',.01)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Iplot')
end

figure;
plot(x,'b')
xlim([0,n]),ylim([limMin,limMax])
set(gca,'xtick',[0:n/8:n]),set(gca,'ytick',[0:limMax/10:limMax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xplot')
end

xbar=mean(x), s2x=var(x)

figure;
histogram(x,25)
xlim([limMin,limMax]),ylim([0,60])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xHistogram')
end

y=2*x;

ybar=mean(y)
y2y=var(y)

figure;
plot(x,'b')
hold on
plot(y,'r')
xlim([0,n]),ylim([limMin,limMax])
set(gca,'xtick',[0:n/8:n]),set(gca,'ytick',[0:50:limMax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xsplot')
end

figure;
histogram(y,50)
xlim([limMin,limMax]),ylim([0,60])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','yHistogram')
end

%
limMax=125;
kernel=[1/4,1/2,1/4];

ywrap=[x(1,n),x,x(1,1)];
w=zeros(1,n+2);
for i=2:n+1
    w(1,i)=sum(ywrap(1,i-1:i+1).*kernel);
end
w=w(1,2:n+1);

wbar=mean(w),s2w=var(w)

figure;
plot(x,'b')
hold on
plot(w,'r')
xlim([0,n]),ylim([limMin,limMax])
set(gca,'xtick',[0:n/8:n]),set(gca,'ytick',[0:25:limMax])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwSmplot')
end

figure;
histogram(w,(1:limMax))
xlim([limMin,limMax]),ylim([0,80])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wHistogram')
end

figure;
histogram(x,(1:limMax))
xlim([limMin,limMax]),ylim([0,80])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xHistogram2')
end

figure;
autocorr(x)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xAutoCorr')
end
figure;
autocorr(w)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wAutoCorr')
end

% autocorrelation
numlags=20;

% using matlab functions
[cx,lags] = xcov(x,20,'unbiased');
figure;
stem(lags(numlags+1:end),cx(numlags+1:end))
[cw,lags] = xcov(w,20,'unbiased');
figure;
stem(lags(numlags+1:end),cw(numlags+1:end))

% caclulating directly
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
[[0;round((1:numlags)',0)],[1;lagcorx],[1;lagcorw],[s2x;lagcovx],[s2w;lagcovw]]

k=length(kernel)
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

AAt=A*A';

figure;
imagesc(AAt,[0,6/16])
colormap(gray), axis image, axis off
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAt')
end

AAt(1:5,1:5)

