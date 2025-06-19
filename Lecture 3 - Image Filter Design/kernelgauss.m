% set the kernel array size
k=11;
% set the spread of the kernel
sigma2=2%0.5
%sigma2=8*log(2)*fwhm^2;

% form the unweighted kernel
x=(-(k-1)/2:(k-1)/2);
y=(-(k-1)/2:(k-1)/2);
[X,Y]=meshgrid(x,y);
gk=exp(-X.^2/(2*sigma2)).*exp(-Y.^2/(2*sigma2))

% form unweighted integerized kernel
gk=round(gk/gk(1,1))

% integer normalizing constant
c=sum(sum(gk))

% normalized final kernel
gk=gk/c

% figure;
% surf(X,Y,gk)
% axis image
