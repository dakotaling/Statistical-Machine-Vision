% Code inspired by PRofessor Daniel Rowe
% Based on ftConvTS.m
clear all
close all

% time series (same as Question 1)
n=96; % number of time points
dt=2.5; %seconds between time points
t=(1:n)'; % sampled time points

A1=8; A2=3; A3=4; A4=2; % frequency amplitudes
nu1=0/(dt*n); nu2=6/(dt*n); % cosine frequencies
nu3=12/(dt*n); nu4=24/(dt*n); % sine frequencies
y=zeros(n,1); % preallocate y
y=A1*cos(2*pi*nu1*(t-1)*dt)...
 +A2*cos(2*pi*nu2*(t-1)*dt)...
 +A3*sin(2*pi*nu3*(t-1)*dt)...
 +A4*sin(2*pi*nu4*(t-1)*dt);

figure;
plot(t,y,'k','LineWidth',1.5)
xlim([0,n]), ylim([min(y)-1,max(y)+1])
set(gca,'xtick',(0:n/8:n))
title('Original Time Series')

% perform convolution smoothing in time domain
kernel=[1/4,1/2,1/4];
k=length(kernel);

tic
yw=[y(n-(k-1)/2+1:n);y;y(1:(k-1)/2)];% even kernel
ysm=zeros(n,1);
for j=1:n
    ysm(j,1)=kernel*yw(j:j+(k-1),1);
end
toc
clear yw j

figure;
plot(t,ysm,'b','LineWidth',1.5)
xlim([0,n]), ylim([min(y)-1,max(y)+1])
set(gca,'xtick',(0:n/8:n))
title('Smoothed Time Series (Direct Convolution)')

% center kernel
kerncenter=[zeros(n/2-(k-1)/2,1);kernel';zeros(n/2-(k-1)/2-1,1)];

figure;
plot(kerncenter,'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([0,n]), ylim([0,.5])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(0:.1:.5))
title('Centered Kernel')

% FFT of time series and centered kernel
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;
fty=fftshift(fft(fftshift(y)));
ftk=fftshift(fft(fftshift(kerncenter)));

% Plot FFT of time series
figure;
plot(nu,2*real(fty)/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('FFT of Time Series - Real Part')

figure;
plot(nu,2*abs(imag(fty))/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('FFT of Time Series - Imaginary Part')

% Plot FFT of kernel
figure;
plot(nu,real(ftk),'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,1])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('FFT of Kernel - Real Part')

figure;
plot(nu,abs(imag(ftk)),'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,max(abs(imag(ftk)))*1.1])
set(gca,'xtick',round(nu(1:n/8:n),2))
if max(abs(imag(ftk))) > 0.01
    set(gca,'ytick',[0,max(abs(imag(ftk)))/2,max(abs(imag(ftk)))])
else
    set(gca,'ytick',[0,.005,.01])
end
title('FFT of Kernel - Imaginary Part')

% Pointwise multiply

ftyTftk=fty.*ftk;

figure;
plot(nu,2*real(ftyTftk)/n,'b-','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('Pointwise Multiplication - Real Part')

figure;
plot(nu,2*abs(imag(ftyTftk))/n,'b-','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('Pointwise Multiplication - Imaginary Part')

% Inverse discrete Fourier transform

ysmFT=fftshift(ifft(fftshift(ftyTftk)));

figure;
plot(t,ysm,'r','LineWidth',1.5)
hold on
plot(t,real(ysmFT),'b:','LineWidth',1.5,'MarkerSize',5)
xlim([0,n]), ylim([min(y)-1,max(y)+1])
set(gca,'xtick',(0:n/8:n))
legend('Direct Convolution','FFT Convolution')
title('Convolution Comparison: Direct vs FFT')

figure;
plot(t,ysm-real(ysmFT),'k','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8`:n))
title('Difference: Direct - FFT Convolution')