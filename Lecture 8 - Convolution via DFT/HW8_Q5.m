clear all
close all

%% Question 5: Make up your own homework problem and solve it
% HOMEWORK PROBLEM:
% You are given a noisy signal that contains:
% 1) A useful low-frequency signal (mix of sines/cosines)
% 2) High-frequency noise at a specific frequency
% 3) Your task is to:
%    a) Identify the noise frequency using FFT
%    b) Remove the noise using frequency domain filtering
%    c) Apply smoothing using convolution
%    d) Compare all stages: original, noisy, denoised, and smoothed

% Create the original "clean" signal
n=96; % number of time points
dt=2.5; %seconds between time points
t=(1:n)'; % sampled time points

A1=10; A2=5; A3=3; % amplitudes
nu1=2/(dt*n); nu2=4/(dt*n); nu3=8/(dt*n); % frequencies
clean_signal = A1*cos(2*pi*nu1*(t-1)*dt) + ...
               A2*sin(2*pi*nu2*(t-1)*dt) + ...
               A3*cos(2*pi*nu3*(t-1)*dt);

figure;
plot(t,clean_signal,'k','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
title('Original Clean Signal')

% Add high-frequency noise
A_noise = 4; % noise amplitude
nu_noise = 30/(dt*n); % high frequency noise
noise = A_noise * sin(2*pi*nu_noise*(t-1)*dt);

noisy_signal = clean_signal + noise;

figure;
plot(t,noisy_signal,'r','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
title('Noisy Signal (Clean + High-Freq Noise)')

% Part (a): Identify noise frequency using FFT
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;
ft_noisy=fftshift(fft(fftshift(noisy_signal)));

% Plot FFT to identify frequencies
figure;
plot(nu,2*real(ft_noisy)/n,'r','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('FFT of Noisy Signal - Real Part')

figure;
plot(nu,2*abs(imag(ft_noisy))/n,'b','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])
set(gca,'xtick',round(nu(1:n/8:n),2))
title('FFT of Noisy Signal - Imaginary Part')

% Identify noise frequency (should be peak in imaginary part at nu_noise)
[max_val, max_idx] = max(2*abs(imag(ft_noisy))/n);
identified_freq = nu(max_idx);

% Part (b): Remove noise using frequency domain filtering
ft_denoised = ft_noisy;

% Find indices for noise frequency (positive and negative)
[~, idx_pos] = min(abs(nu - nu_noise));
[~, idx_neg] = min(abs(nu + nu_noise));

ft_denoised(idx_pos) = 0;
ft_denoised(idx_neg) = 0;
denoised_signal = fftshift(ifft(fftshift(ft_denoised)));

figure;
plot(t,real(denoised_signal),'g','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
title('Denoised Signal (Noise Frequency Removed)')

% Part (c): Apply smoothing using convolution (from ftConvTS.m)
kernel=[1/4,1/2,1/4]; % smoothing kernel
k=length(kernel);

% Direct convolution
yw=[real(denoised_signal(n-(k-1)/2+1:n));real(denoised_signal);real(denoised_signal(1:(k-1)/2))];
smoothed_signal=zeros(n,1);
for j=1:n
    smoothed_signal(j,1)=kernel*yw(j:j+(k-1),1);
end
clear yw j

figure;
plot(t,smoothed_signal,'m','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
title('Final Smoothed Signal')

% Part (d): Compare all stages
figure;
subplot(2,2,1)
plot(t,clean_signal,'k','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/4:n))
title('1. Original Clean')

subplot(2,2,2)
plot(t,noisy_signal,'r','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/4:n))
title('2. Noisy Signal')

subplot(2,2,3)
plot(t,real(denoised_signal),'g','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/4:n))
title('3. Denoised')

subplot(2,2,4)
plot(t,smoothed_signal,'m','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/4:n))
title('4. Final Smoothed')

% Overlay comparison
figure;
plot(t,clean_signal,'k','LineWidth',2)
hold on
plot(t,noisy_signal,'r:','LineWidth',1.5)
plot(t,real(denoised_signal),'g--','LineWidth',1.5)
plot(t,smoothed_signal,'m-.','LineWidth',1.5)
xlim([0,n])
set(gca,'xtick',(0:n/8:n))
legend('Original Clean','Noisy','Denoised','Final Smoothed')
title('Signal Processing Pipeline Comparison')