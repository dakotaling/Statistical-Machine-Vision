% Code inspired by Professor Daniel Rowe Lecture 01
clear; clc;

A = imread("FrMarquette.jpg");

figure;
imagesc(A)
axis image, axis off

I = rgb2gray(A);

figure; 
imagesc(I)
axis image, axis off
colormap("copper")

imwrite(I, 'CopperMarquette.jpg');

save('HW1_Question3')