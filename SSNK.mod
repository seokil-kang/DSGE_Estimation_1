var
y
p
R
g
z
YGR
INFL
INT
;

varexo
eR
eg
ez
;

parameters
tau kappa psi1 psi2 rhoR rhog rhoz rA pA gammaQ sigR1e2 sigg1e2 sigz1e2
;
tau = 20e-1;
kappa = 50e-2;
psi1 = 15e-1;
psi2 = 50e-2;
rhoR = 50e-2;
rhog = 50e-2;
rhoz = 50e-2;
rA = 50e-2;
pA = 70e-1;
gammaQ = 40e-2;
sigR1e2 = 40e-2;
sigg1e2 = 10e-1;
sigz1e2 = 50e-2;

model;
#beta = 1/(1+rA/4e2);
y = y(+1) - (R - p(+1) - z(+1))/tau + g - g(+1);
p = beta * p(+1) + kappa * (y - g);
R = rhoR * R(-1) + (1 - rhoR) * (psi1 * p + psi2 * (y - g)) + eR;
g = rhog * g(-1) + eg;
z = rhoz * z(-1) + ez;
YGR = gammaQ + 1e2 * (y - y(-1) + z);
INFL = pA + 4e2*p;
INT = pA + rA + 4*gammaQ + 4e2 * R;
end;

steady_state_model;
y = 0;
p = 0;
R = 0;
g = 0;
z = 0;
YGR = gammaQ;
INFL = pA;
INT = pA + rA + 4*gammaQ;
end;

shocks;
var eR; stderr sigR1e2/1e2;
var eg; stderr sigg1e2/1e2;
var ez; stderr sigz1e2/1e2;
end;

stoch_simul(order=1)
YGR
INFL
INT
;