clear all
close all

% time series %
n=96; % number of time points
dt=2.5; %seconds between time points
t=(1:n)'; % sampled time points

A1=10; A2=1; A3=3; A4=1; % frequency amplitudes
nu1=0/(dt*n); nu2=4/(dt*n); % cosine frequencies
nu3=8/(dt*n); nu4=32/(dt*n); % sine frequencies
y=zeros(n,1); % preallocate y
y=A1*cos(2*pi*nu1*(t-1)*dt)...
 +A2*cos(2*pi*nu2*(t-1)*dt)...
 +A3*sin(2*pi*nu3*(t-1)*dt)...
 +A4*sin(2*pi*nu4*(t-1)*dt);

figure;
plot(t,y,'k','LineWidth',1.5)
xlim([0,n]), ylim([5,15])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TS')
figure;
plot(t,y,'r-o','LineWidth',1.5,'MarkerSize',5)
xlim([0,n]), ylim([5,15])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TScircRed')

% figure;
% imagesc(repmat(real(y),[1,n/16]),[5,15])
% axis image, colormap(gray), axis off
% figure;
% imagesc(repmat(abs(imag(y)),[1,n/16]),[0,1])
% axis image, colormap(gray), axis off

% perform convolution smoothing in time domain
%kernel=[1/16,4/16,6/16,4/16,1/16];
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
plot(t,ysm,'k','LineWidth',1.5)
xlim([0,n]), ylim([5,15])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TSconv')
figure;
plot(t,ysm,'b-o','LineWidth',1.5,'MarkerSize',5)
xlim([0,n]), ylim([5,15])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TSconvcircBlue')

%fft of convolved
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;
fty=fftshift(fft(fftshift(y)));
ftysm=fftshift(fft(fftshift(ysm)));

figure;
plot(nu,2*real(fty)/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,20])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyR')
figure;
plot(nu,2*abs(imag(fty))/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,3.1])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyI')

figure;
plot(nu,2*real(fty)/n,'r','LineWidth',1.5)
hold on
plot(nu,2*real(ftysm)/n,'b--','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,20])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyftysmR')
figure;
plot(nu,2*abs(imag(fty))/n,'r','LineWidth',1.5)
hold on
plot(nu,2*abs(imag(ftysm))/n,'b--','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,3.1])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyftysmI')

% figure;
% imagesc(repmat(real(ftysm),[1,n/16]),[0,n]) %A1*n
% axis image, colormap(gray), axis off
% figure;
% imagesc(repmat(abs(imag(ftysm)),[1,n/16]),[0,A3*n/2])
% axis image, colormap(gray), axis off

% center kernel
kerncenter=[zeros(n/2-(k-1)/2,1);kernel';zeros(n/2-(k-1)/2-1,1)];
figure;
plot(kerncenter,'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([0,n]), ylim([0,.5])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(0:.1:.5))
%print(gcf,'-dtiffn','-r100','kerncenter')

% figure;
% imagesc(repmat(real(kerncenter),[1,n/16]),[0,1/2])
% axis image, colormap(gray), axis off
% %print(gcf,'-dtiffn','-r100','kcentR')
% figure;
% imagesc(repmat(abs(imag(kerncenter)),[1,n/16]),[0,1])
% axis image, colormap(gray), axis off
% %print(gcf,'-dtiffn','-r100','kerncenter')

% convolution via FFT
fty=fftshift(fft(fftshift(y)));
ftk=fftshift(fft(fftshift(kerncenter)));

figure;
plot(nu,real(ftk),'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,1])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyftysmR')
figure;
plot(nu,abs(imag(ftk)),'color',[0.4660,0.6740,0.1880],'LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,.01])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',[0,.005,.01])
%print(gcf,'-dtiffn','-r100','ftyftysmI')


% figure;
% imagesc(repmat(real(fty),[1,n/16]),[0,1/2])
% axis image, colormap(gray), axis off
% print(gcf,'-dtiffn','-r100','ftyR')
% figure;
% imagesc(repmat(abs(imag(fty)),[1,n/16]),[0,1])
% axis image, colormap(gray), axis off
% print(gcf,'-dtiffn','-r100','ftyI')
% figure;
% imagesc(repmat(real(ftk),[1,n/16]),[0,1])
% axis image, colormap(gray), axis off
% print(gcf,'-dtiffn','-r100','ftkR')
% figure;
% imagesc(repmat(abs(imag(ftk)),[1,n/16]),[0,1])
% axis image, colormap(gray), axis off
% print(gcf,'-dtiffn','-r100','ftkI')

ftyTftk=fty.*ftk;
ysmFT=fftshift(ifft(fftshift(ftyTftk)));

figure;
plot(nu,2*real(ftyTftk)/n,'b-','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,20])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyTftkR')
figure;
plot(nu,2*abs(imag(ftyTftk))/n,'b-','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,3.1])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','ftyTftkI')

figure;
plot(t,ysm,'r','LineWidth',1.5)
hold on
plot(t,ysmFT,'b:','LineWidth',1.5,'MarkerSize',5)
xlim([0,n]), ylim([5,15])
set(gca,'xtick',(0:n/8:n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TSconv')

figure;
plot(t,y-ysmFT,'k','LineWidth',1.5)


figure;
plot(t,ysm-ysmFT,'k','LineWidth',1.5)





