
load F.mat

figure;
subplot(1,2,1)
imagesc(real(F))
axis image, axis off, colormap(gray)
subplot(1,2,2)
imagesc(imag(F)) 
axis image, axis off, colormap(gray)
figure;
subplot(1,2,1)
imagesc(abs(F))
axis image, axis off, colormap(gray)
subplot(1,2,2)
imagesc(angle(F),[-pi,pi]) 
axis image, axis off, colormap(gray)


Y=fftshift(ifft2(fftshift(F)));

figure;
subplot(1,2,1)
imagesc(real(Y),[-7.5,7.5])
axis image, colormap(gray), axis off
subplot(1,2,2)
imagesc(imag(Y),[-7.5,7.5])
axis image, colormap(gray), axis off
figure;
subplot(1,2,1)
imagesc(abs(Y),[0,7.5])
axis image, colormap(gray), axis off
subplot(1,2,2)
imagesc(angle(Y),[-pi,pi])
axis image, colormap(gray), axis off





