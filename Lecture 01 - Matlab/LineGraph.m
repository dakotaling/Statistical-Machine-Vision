T=128; 
t=(1:T);
A=5;
y=A*sin(2*pi/T*t);

figure;
plot(t,y,'r.-')
xlim([1,T]), ylim([-A,A])
set(gca,'xtick',[0:16:T])
set(gca,'ytick',[-A:1:A])