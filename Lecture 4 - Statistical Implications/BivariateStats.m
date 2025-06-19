% bivariate statistics
rng('default')
printfigs=0;

n=10^6;

mu1=10;
sigma21=1;
mu2=15;
sigma22=1;

x1=sqrt(sigma21)*randn([1,n])+mu1;
x2=sqrt(sigma22)*randn([1,n])+mu2;

x1bar=mean(x1),s2x1=var(x1)
x2bar=mean(x2),s2x2=var(x2)

figure;
histogram(x1,50)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','x1Histogram')
end
figure;
histogram(x2,50)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','x2Histogram')
end

figure;
hist3([x1',x2'],[30,30],'CDataMode','auto',...
    'FaceColor','interp','EdgeColor',[0,0,0])
xlim([0,50]),ylim([0,50]), view(-37,30)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','x1x2Histogram')
end

y=[2,0;0,2]*[x1;x2];
y1=y(1,:);, y2=y(2,:);

y1bar=mean(y1),s2y1=var(y1)
y2bar=mean(y2),s2y2=var(y2)

figure;
histogram(y1,100)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','y1Histogram')
end
figure;
histogram(y2,100)
xlim([0,40])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','y2Histogram')
end

figure;
hist3([y1',y2'],[60,60],'CDataMode','auto',...
    'FaceColor','interp','EdgeColor',[0,0,0])
xlim([0,50]), ylim([0,50]), view(-37,30)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','y1y2Histogram')
end


A=[2,1;1,2];
D=A*A';
d=diag(1./sqrt(diag(D)))
R=d*D*d;

invD=inv(D)
1/invD(1,1)
1/invD(1,2)


w=A*[x1;x2];
w1=w(1,:); w2=w(2,:);

w1bar=mean(w1),s2w1=var(w1)
w2bar=mean(w2),s2w2=var(w2)

figure;
histogram(w1,100)
xlim([10,50])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','w1Histogram')
end
figure;
histogram(w2,100)
xlim([10,50])
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','w2Histogram')
end

figure;
hist3([w1',w2'],[50,50],'CDataMode',...
    'auto','FaceColor','interp','EdgeColor',[0,0,0])
xlim([0,50]), ylim([0,50]), view(-37,30)
if (printfigs==1)
    print(gcf,'-dtiffn','-r100','w1w2Histogram')
end




