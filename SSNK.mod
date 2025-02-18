var
y
p
R
x
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
rhoR = 85e-2;
rhog = 99e-2;
rhoz = 50e-2;
rA = 50e-2;
pA = 70e-1;
gammaQ = 40e-2;
sigR1e2 = 40e-2;
sigg1e2 = 10e-1;
sigz1e2 = 50e-2;

model(linear);
#beta = 1/(1+rA/4e2);
x = y - g;
y = y(+1) - (R - p(+1) - z(+1))/tau + g - g(+1);
p = beta * p(+1) + kappa * (y - g);
R = rhoR * R(-1) + (1 - rhoR) * (psi1 * p + psi2 * (y - g)) + eR/1e2;
g = rhog * g(-1) + eg/1e2;
z = rhoz * z(-1) + ez/1e2;
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
INT = pA+rA+4*gammaQ;
end;

estimated_params;
rA,gamma_pdf,1.00,0.50;
pA,gamma_pdf,7.00,2.00;
gammaQ,normal_pdf,0.40,0.20;
tau,gamma_pdf,2.00,0.50;
kappa,beta_pdf,0.50,0.25;
psi1,gamma_pdf,1.50,0.25;
psi2,gamma_pdf,0.50,0.25;
rhoR,beta_pdf,0.50,0.25;
rhog,beta_pdf,0.50,0.25;
rhoz,beta_pdf,0.50,0.25;
stderr eR,inv_gamma_pdf,0.40,10.00;
stderr eg,inv_gamma_pdf,1.00,10.00;
stderr ez,inv_gamma_pdf,0.50,10.00;
end;

varobs
YGR
INFL
INT
;

estimation(datafile='obs.csv',mode_compute=4,mode_check,mh_replic=50000,mh_drop=0.25,mh_tune_jscale=.33,consider_all_endogenous,bayesian_irf,smoother);