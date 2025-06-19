% time series %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=96; % number of time points
dt=2.5; %seconds between time points
t=((1:n)'-1)*dt; % sampled time points

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
%print(gcf,'-dtiffn','-r100','TS')
figure;
plot(t,y,'k-o','LineWidth',1.5)
xlim([0,dt*n]), ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
%print(gcf,'-dtiffn','-r100','TScirc')


figure;
plot(t,y1,'k-o','LineWidth',1.5)
xlim([0,dt*n])%, ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
figure;
plot(t,y2,'k-o','LineWidth',1.5)
xlim([0,dt*n])%, ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
figure;
plot(t,y3,'k-o','LineWidth',1.5)
xlim([0,dt*n])%, ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
figure;
plot(t,y4,'k-o','LineWidth',1.5)
xlim([0,dt*n])%, ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))






figure;
imagesc(repmat(real(y),[1,n/16]),[5,15])
axis image, colormap(gray), axis off
%print(gcf,'-dtiffn','-r100','TSimgR')
figure;
imagesc(repmat(abs(imag(y)),[1,n/16]),[0,1])
axis image, colormap(gray), axis off
%print(gcf,'-dtiffn','-r100','TSimgI')

% frequency spectrum %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnu=1/(n*dt);
nu=((1:n)'-n/2-1)*dnu;

% DFT by matrix multiplication
OmegaC=zeros(n,n);
for k=1:n         
   for j=1:n
      OmegaC(k,j)=exp(-1i*2*pi*(k-(n/2+1))*(j-(n/2+1))/n);
   end
end

figure;
imagesc(real(OmegaC),[-1,1]);
axis image,colormap(gray), axis off
figure;
imagesc(imag(OmegaC),[-1,1]);
axis image,colormap(gray), axis off

f =(OmegaC*y);
figure;
plot(nu,2*real(f)/n,'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])%,ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
figure;
plot(nu,2*abs(imag(f))/n,'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),%ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))

figure;
plot(nu,2*real(f)/n,'k-o','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2])%,ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','FTreal')
figure;
plot(nu,2*abs(imag(f))/n,'k-o','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),%ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
%print(gcf,'-dtiffn','-r100','FTimag')



figure;
imagesc(repmat(real(f),[1,n/16]),[0,n]) %A1*n
axis image, colormap(gray), axis off
figure;
imagesc(repmat(abs(imag(f)),[1,n/16]),[0,A3*n/2])
axis image, colormap(gray), axis off

% IDFT by matrix multiplication
OmegaBarC=zeros(n,n);
for k=1:n         
   for j=1:n
      OmegaBarC(k,j)=exp(1i*2*pi*(k-(n/2+1))*(j-(n/2+1))/n);
   end
end
OmegaBarC=OmegaBarC/n;

figure;
imagesc(real(OmegaBarC),[-1/n,1/n]);
axis image,colormap(gray), axis off
figure;
imagesc(imag(OmegaBarC),[-1/n,1/n]);
axis image,colormap(gray), axis off

yhat =(OmegaBarC*f);

figure;
plot(t,real(yhat),'k','LineWidth',1.5)
xlim([0,dt*n]), ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
figure;
plot(t,imag(yhat),'k','LineWidth',1.5)
xlim([0,dt*n])
set(gca,'xtick',(0:dt*n/8:dt*n))

% compute with Matlab's functions
ff=fftshift(fft(fftshift(y)));
figure;
plot(nu,real(ff),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',(0:n/4:n))
figure;
plot(nu,abs(imag(ff)),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',(0:n/4:n))

yyhat=fftshift(ifft(fftshift(ff)));
figure;
plot(t,real(yyhat),'k','LineWidth',1.5)
xlim([0,dt*n]), ylim([5,15])
set(gca,'xtick',(0:dt*n/8:dt*n))
set(gca,'ytick',(5:2:15))
figure;
plot(t,imag(yyhat),'k','LineWidth',1.5)
xlim([0,dt*n])
set(gca,'xtick',(0:dt*n/8:dt*n))

figure;
plot(nu,log(1+abs(ff)),'k','LineWidth',1.5)
xlim([-1/dt/2,1/dt/2]),ylim([0,n])
set(gca,'xtick',round(nu(1:n/8:n),2))
set(gca,'ytick',(0:n/4:n))






