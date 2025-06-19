% Code inspired by Professor Daniel Rowe
% Based on TimeStatsToy.m
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
title('Original Time Series Histogram')
xlabel('Value')
ylabel('Frequency')
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
title('Convolved Time Series Histogram')
xlabel('Value')
ylabel('Frequency')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wHistogram')
end