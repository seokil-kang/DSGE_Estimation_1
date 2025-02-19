function z = invgamrnd(mu,sigma,N1,N2)
% draw a random variable for inverse gamma distribution
% a random variable Z from the inverse gamma distribution with mean mu and standard deviation sigma
% Z ~ IG(a,b) where 
a = (mu/sigma)^2+2;
b = (a-1)*mu;
% This is equivalent to draw 1/Z from the following gamma distribution,
% 1/Z ~ G(a,1/b)
z = 1./gamrnd(a,1/b,N1,N2);
end