function f = invgampdf(z,mu,sigma)
% Compute the probability density function for inverse gamma distribution
% a random variable Z from the inverse gamma distribution with mean mu and standard deviation sigma
% Z ~ IG(a,b) where 
a = (mu/sigma)^2+2;
b = (a-1)*mu;
% This is equivalent to compute the pdf of 1/Z following the gamma distribution as
% 1/Z ~ G(a,1/b)
% therefore, its pdf becomes
% p_IG(Z) = p_G(1/Z)/Z^2
f = gampdf(1./z,a,1/b).*z.^(-2);
end