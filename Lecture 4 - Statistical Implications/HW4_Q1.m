% Code inspired by Professor Daniel Rowe
clear; clc;
printfigs=0;

n=10^6;
mu=100; sigma2=4;

x=sqrt(sigma2)*randn([n,1])+mu;
xbar=mean(x)
s2x=var(x)

figure;
histogram(x,50)
xlim([90,110])
title('Original Distribution (mean=100, variance=4)')
xlabel('Value')
ylabel('Frequency')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xHistogram')
end

y=7*x;
ybar=mean(y)
s2y=var(y)

figure;
histogram(y,50)
xlim([670,730])
title('Multiplied Distribution (original × 7)')
xlabel('Value')
ylabel('Frequency')
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','yHistogram')
end