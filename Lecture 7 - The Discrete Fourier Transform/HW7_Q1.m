% Code inspired by Daniel Rowe
close all
clear all

% Based on sampleDFT1D.m
n=96; % number of time points
dt=2.5; % seconds between time points
t=((1:n)'-1)*dt; % sampled time points

% Define frequency components
A1=10; A2=1; A3=3; A4=1; % frequency amplitudes
nu1=0/(dt*n); nu2=4/(dt*n); % cosine frequencies
nu3=8/(dt*n); nu4=32/(dt*n); % sine frequencies
y1=zeros(n,1); y2=zeros(n,1); y3=zeros(n,1); y4=zeros(n,1); 
for j=1:n
    y1(j,1)=A1*cos(2*pi*nu1*(j-1)*dt);
    y2(j,1)=A2*cos(2*pi*nu2*(j-1)*dt);
    y3(j,1)=A3*sin(2*pi*nu3*(j-1)*dt);
    y4(j,1)=A4*sin(2*pi*nu4*(j-1)*dt);
end
y=y1+y2+y3+y4;

figure;
plot(t,y,'k','LineWidth',1.5)
xlim([0,dt*n]), ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
title('Original Time Series')
xlabel('Time (s)')
ylabel('Amplitude')

% compute with Matlab's functions
ff=fftshift(fft(fftshift(y)));

% frequency spectrum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;

% Plot real DFT
figure;
plot(nu,real(ff),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',(0:n/4:n))
title('Real Part of 1D DFT')
xlabel('Frequency (Hz)')
ylabel('Real Amplitude')

% Plot imaginary DFT
figure;
plot(nu,imag(ff),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
ylim([-n/2,n/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('Imaginary Part of 1D DFT')
xlabel('Frequency (Hz)')
ylabel('Imaginary Amplitude')

% Plot absolute value of imaginary
figure;
plot(nu,abs(imag(ff)),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',(0:n/4:n))
title('Absolute Value of Imaginary Part of 1D DFT')
xlabel('Frequency (Hz)')
ylabel('|Imaginary Amplitude|')