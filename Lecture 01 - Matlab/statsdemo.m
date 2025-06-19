n=10^6;
mu=100; sigma2=25; 
x=sqrt(sigma2)*randn(n,1)+mu;

xbar=mean(x)
s2=var(x)
figure;
histogram(x,100)
print(gcf,'-dtiffn','-r100',['demoHist'])