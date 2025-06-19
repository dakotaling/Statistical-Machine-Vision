% Code inspired by Professor Daniel Rowe Lecture 01
clear; clc;

% Part a)
% Load cat image data
A = imread('cat.jpg');
A = imrotate(A, -90); % Need to rotate because of Apple images
[n,p] = size(A);

% Convert to grayscale
I = rgb2gray(A);
[n,p] = size(I);

figure;
imagesc(I)
axis image, colormap(gray)
set(gca,'xtick',[1:500:p])
set(gca,'ytick',[1:500:n])
title('Cat Image')
print(gcf,'-dtiffn','-r100','CatScene')

% Part b)
% Extract cat as distinct feature
cat = I(2200:3200, 2300:3200);
figure;
imagesc(cat)
axis image, colormap(gray), axis off
print(gcf,'-dtiffn','-r100','cat_face')

% Save cat face pixel data into an excel spreadsheet
filename = 'cat_face_data.xlsx';
writematrix(cat, filename, 'Sheet', 1, 'Range', 'A1')

% Part c)
% Load in 2nd image
B = imread('water_bottle.jpg');
B = imrotate(B, -90);
J = rgb2gray(B);

[m,q] = size(J);
figure;
imagesc(J)
axis image, colormap(gray)
set(gca,'xtick',[0:500:q])
set(gca,'ytick',[0:500:m])
title('Water Bottle Image')
print(gcf,'-dtiffn','-r100','WaterBottleScene')

% Part d)
% Average the two images together
avg_of_images = (double(I) + double(J)) / 2;
avg_of_images = uint8(avg_of_images);

% Part e) 
% Display the averaged image
figure;
imagesc(avg_of_images)
axis image, colormap(gray)
set(gca,'xtick',[0:500:p])
set(gca,'ytick',[0:500:n])
title('Average of Images')
print(gcf,'-dtiffn','-r100','AveragedImages')

% Save the averaged image
imwrite(avg_of_images, 'AverageofImages.jpg');

% Save the entire workspace
save('HW1_Question4')

