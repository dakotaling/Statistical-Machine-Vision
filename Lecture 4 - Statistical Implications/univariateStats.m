printfigs=0;

n=10^6;
mu=10; sigma2=1;

x=sqrt(sigma2)*randn([n,1])+mu;
xbar=mean(x)
s2x=var(x)

figure;
histogram(x,50)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','xHistogram')
end

y=2*x;
ybar=mean(y)
s2y=var(y)

figure;
histogram(y,100)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','yHistogram')
end

w=y/2;
xxbar=mean(w)
s2y=var(w)

figure;
histogram(w,50)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','wHistogram')
end








