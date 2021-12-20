r = [7;11];
v = [7;10.25];

zeta = 2;
delta = -1;
eta = 1;

constr.A = [ 0 -1 ];
constr.b = [10];

ci = constr.A*v + constr.b;
Dci = constr.A'/norm(constr.A)

rho_att = (r-v) / max([norm(r-v), eta])
rho_rep_wall = min([max([(zeta-ci)/(zeta), 0]), 0.99]) * Dci
rho_rep_corr = max([0.99 - Dci'*((v-r)/norm(v-r)), 0]) * Dci

