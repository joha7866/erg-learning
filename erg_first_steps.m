close all; clc; clear

%
% Time
%
Ts = 0.01;
TT = 10;

%
% System Model
%

%2d double int with 2 ctrls
A = [0 0 1 0
     0 0 0 1
     0 0 0 0
     0 0 0 0];

B = [0 0
     0 0
     1 0
     0 1];

C = [1 0 0 0
     0 1 0 0];

D = [0 0
     0 0];

sys = ss(A,B,C,D);


%
% Reference
%
r0 = zeros(2,1);
r = [7;11];

v0 = zeros(2,1);
kappa = 100;


%
% Inner Control Design
%
%edit parameters
x0 = zeros(4,1);
zeta = 0.7;
umax = 20;

%calc gains
Kp = umax/max(r);
wn = sqrt(Kp);
Kd = 2*zeta*wn;


%
% Nav Fields
%

%constraint Av+b>=0
%for diagonal
%  A <- -1 -1
%  B <- x/y intercept
constr.A = [ 0 -1 ];

constr.b = [10];

zeta = 2; %influence margin
delta = -100; %static safety margin
eta = 1; %...


%
% sim
%
out = sim("erg");

data.tu = out.u.Time;
data.t = out.x.Time;
data.u1 = out.u.Data(1,:);
data.u2 = out.u.Data(2,:);
data.x = out.x.Data(1,:)';
data.y = out.x.Data(2,:)';
data.r = out.r.Data;
data.v = out.v.Data;
data.rho_att = out.rho_att.Data;
data.rho_rep_wall = out.rho_rep_wall.Data;
data.rho_rep_corr = out.rho_rep_corr.Data;

%Check Control Inputs
figure
plot(data.tu,data.u1)
hold on
plot(data.tu,data.u2)
hold off
grid on
title('Control Inputs')

%
figure
plot(data.r(:,1),data.r(:,2),'r*')
hold on
plot(data.v(1,:),data.v(2,:),'b.')
hold off
axis([0,12,0,12])
xlabel('x pos')
ylabel('y pos')
grid on, zoom on
% xline(10,'r--')
% % xline(10-delta,'y--')
% xline(10-zeta,'y--')
yline(10,'r--')
% yline(10-delta,'y--')
yline(10-zeta,'y--')
legend('r','v')
title('v')

%
norm_rho_att = [];
norm_rho_rep_wall = [];
norm_rho_rep_corr = [];
for i = 1:length(data.rho_att)
     norm_rho_att = [norm_rho_att norm(data.rho_att(:,i))];
     norm_rho_rep_wall = [norm_rho_rep_wall norm(data.rho_rep_wall(:,i))];
     norm_rho_rep_corr = [norm_rho_rep_corr norm(data.rho_rep_corr(:,i))];
end

figure
plot(data.t,norm_rho_att, data.t,norm_rho_rep_wall, data.t,norm_rho_rep_corr)
legend('\rho_{att}','\rho_{repwall}','\rho_{repcorr}')
title('rho vals over time')


%print some values for quick verification
[data.x(end) data.y(end)]
[data.v(1,end) data.v(2,end)]


