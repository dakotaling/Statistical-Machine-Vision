% Generate a Gaussian Kernel from Binomial
% usage is gk=kernelB(k,p)
% k=kernal size, p=probability, gk=kernel

function gk=kernelB(k,p);

% form the unweighted kernel
n=k-1; m=n;
x=(0:n);
y=(0:n);
[X,Y]=meshgrid(x,y);
% form weighted kernel
gk=(p.^X).*((1-p).^(n-X)).*(factorial(n)./(factorial(n-X).*factorial(X)))...
    .*(p.^Y.*(1-p).^(m-Y)).*(factorial(m)./(factorial(m-Y).*factorial(Y)))

% form unweighted integerized kernel
gk=round(gk/gk(1,1));

% integer normalizing constant
c=sum(sum(gk));

% normalized final kernel
gk=gk/c;


