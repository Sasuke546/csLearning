% GAUSAS Generation of multivariate Gaussian data.
% 
% X = gausas(n,C,M)
% Generation of n    p-dimensional Gaussian distributed vectors
% with covariance matrix C (size k*k) and with mean M (size 1*k).

function X = gausas(n,C,M)
[V D] = eig(C);
V = real(V);D = real(D);p=size(C,1);
X = randn(n,p)*sqrt(D)*V' + ones(n,1) * reshape(M,1,p);
return
