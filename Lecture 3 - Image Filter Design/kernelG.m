% Generate a Gaussian Kernel
% usage is gk=kernelG(k,sigma2)
% k=kernal size, sigma2=variance, gk=kernel

function gk=kernelG(k,sigma2);

% form the unweighted kernel
x=(-(k-1)/2:(k-1)/2);
y=(-(k-1)/2:(k-1)/2);
[X,Y]=meshgrid(x,y);
gk=exp(-X.^2/(2*sigma2)).*exp(-Y.^2/(2*sigma2));

% form unweighted integerized kernel
gk=round(gk/gk(1,1));

% integer normalizing constant
c=sum(sum(gk));

% normalized final kernel
gk=gk/c;


