% Code inspired by Professor Daniel Rowe
% Based on TimeStatsToy.m and IntroTimeStats.m
clear; clc;

% time series statistics with convolution
rng('default')
printfigs=0;

n=200;
mu=10;
sigma2=1;

x=sqrt(sigma2)*randn([1,n])+mu;

xbar=mean(x)
s2x=var(x)

figure;
plot(x,'b')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
title('Original Time Series')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xplot')
end

figure;
histogram(x,25)
xlim([5,15]),ylim([0,25])
title('Histogram of Original Time Series')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xHistogram')
end

% 3-point kernel
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
title('Original (blue) and Convolved (red) Time Series')
legend('Original','Convolved')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwSmplot')
end

figure;
histogram(w,25)
xlim([5,15]),ylim([0,25])
title('Histogram of Convolved Time Series')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wHistogram')
end

% Matrix version of convolution (following TimeStatsToy.m approach)
a=[1/4,1/2,1/4,zeros(1,n-k)];
A=zeros(n,n);
for i=1:n
    A(i,:)=circshift(a,i-(k-1)/2-1);
end

figure;
imagesc(A,[0,1/2])
colormap(gray), axis image, axis off
title('Convolution Matrix A')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Amat')
end

% Matrix version
u=A*x';

figure;
plot(x,'b')
hold on
plot(w,'r')
plot(u,'k--')
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
title('Comparison: Direct (red) vs Matrix (black dashed) Convolution')
legend('Original','Direct Conv','Matrix Conv')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','convComparison')
end

% autocorrelation
numlags=20;

% Sample autocorrelation
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

% Display autocorrelation results
fprintf('\nAutocorrelation Results:\n')
fprintf('Lag\tCorr(x)\tCorr(w)\tCov(x)\tCov(w)\n')
for i=1:min(10,numlags)
    fprintf('%d\t%.4f\t%.4f\t%.4f\t%.4f\n', i, lagcorx(i), lagcorw(i), lagcovx(i), lagcovw(i))
end

figure;
plot(1:numlags, lagcorx, 'b-o', 'LineWidth', 2)
hold on
plot(1:numlags, lagcorw, 'r-s', 'LineWidth', 2)
xlim([1,numlags]), ylim([-0.2,1])
xlabel('Lag'), ylabel('Autocorrelation')
title('Autocorrelation Functions')
legend('Original x', 'Convolved w')
grid on
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','autocorr')
end

% Deconvolution
Ainv=pinv(A);

figure;
imagesc(Ainv,[-10,10])
colormap(gray), axis image, axis off
title('Deconvolution Matrix (pseudo-inverse of A)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','Ainv')
end


figure;
imagesc(Ainv*A,[-1,1])
colormap(gray), axis image, axis off
title('Ainv*A (should approximate identity)')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AinvA')
end

v=Ainv*w';

figure;
plot(x,'b', 'LineWidth', 2)
hold on
plot(w,'r', 'LineWidth', 2)
plot(v,'color',[0.4660 0.6740 0.1880], 'LineWidth', 2)
xlim([0,n]),ylim([5,15])
set(gca,'xtick',[0:n/8:n])
title('Time Series: Original, Convolved, and Deconvolved')
legend('Original x', 'Convolved w', 'Deconvolved v')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xwvplot')
end

vbar=mean(v)
s2v=var(v)

figure;
histogram(x,25,'FaceAlpha',0.5,'DisplayName','Original')
hold on
histogram(w,25,'FaceAlpha',0.5,'DisplayName','Convolved')
histogram(v,25,'FaceAlpha',0.5,'DisplayName','Deconvolved')
xlim([5,15])
title('Histogram Comparison')
legend
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','histComparison')
end

AAt=A*A';
fprintf('\nConvolution induces covariance structure:\n')
fprintf('AAt(1:5,1:5) =\n')
disp(AAt(1:5,1:5))

figure;
imagesc(AAt,[0,max(AAt(:))])
colormap(gray), axis image, axis off
title('Induced Covariance Matrix AA^T')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','AAt')
end