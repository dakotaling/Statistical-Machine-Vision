% Code inspired by Professor Daniel Rowe
% Based on ftConvTS.m
clear all
close all

% time series parameters (from ftConvTS.m)
n=96; % number of time points
dt=2.5; %seconds between time points
t=(1:n)'; % sampled time points

% Define my own frequency components
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
title('Time Series with Sines and Cosines')

% Part (a): Forward discrete Fourier transform to discover frequencies

% Setup frequency vector (from ftConvTS.m)
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;
fty=fftshift(fft(fftshift(y)));

% Plot Fourier coefficients - real part (cosines)
figure;
plot(nu,2*real(fty)/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,max(2*real(fty)/n)*1.1])
set(gca,'xtick',round(nu(1:n/8:n),3))
title('Fourier Coefficients - Real Part (Cosines)')

% Plot Fourier coefficients - imaginary part (sines)
figure;
plot(nu,2*abs(imag(fty))/n,'b','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,max(2*abs(imag(fty))/n)*1.1])
set(gca,'xtick',round(nu(1:n/8:n),3))
title('Fourier Coefficients - Imaginary Part (Sines)')

% Combined plot
figure;
plot(nu,2*real(fty)/n,'r','LineWidth',1.5)
hold on
plot(nu,2*abs(imag(fty))/n,'b','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),3))
legend('Real (Cosines)','Imaginary (Sines)')
title('All Fourier Coefficients')

% Part (b): Set coefficients for one frequency to zero and inverse transform

% Remove the nu3 sine component (A3*sin term)
fty_modified = fty;
target_freq = nu3;

% Find indices for positive and negative frequencies
[~, idx_pos] = min(abs(nu - target_freq));
[~, idx_neg] = min(abs(nu + target_freq));

fty_modified(idx_pos) = 0;
fty_modified(idx_neg) = 0;

y_reconstructed = fftshift(ifft(fftshift(fty_modified)));

figure;
plot(t,y,'k','LineWidth',1.5)
hold on
plot(t,real(y_reconstructed),'r--','LineWidth',1.5)
xlim([0,n]), ylim([min(y)-1,max(y)+1])
set(gca,'xtick',(0:n/8:n))
legend('Original','Reconstructed (freq removed)')
title('Original vs Reconstructed Signal')

% Plot the removed component
figure;
plot(t,y-real(y_reconstructed),'g','LineWidth',1.5)
hold on
plot(t,A3*sin(2*pi*nu3*(t-1)*dt),'k:','LineWidth',2)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
legend('Removed component','Original A3*sin term')
title('Removed Frequency Component')