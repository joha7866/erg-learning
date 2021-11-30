close all; clc; clear

%
% Time
%
Ts = 0.1;
TT = 10;


%
% System Model
%

% %1d double int
% A = [0,1;0,0];
% B = [0;1];
% C = [1,0];
% D = [0];
% sys = ss(A,B,C,D);

%2d double int with 2 ctrls
A = [0,0,1,0
     0,0,0,1
     0,0,0,0
     0,0,0,0];
B = [0,0
     0,0
     1,0
     0,1];
C = [1,0,0,0
     0,1,0,0];
D = [0,0
     0,0];
sys = ss(A,B,C,D);


%
% Reference
%
r0 = zeros(2,1);
r = [11;9.9];

v0 = r0;


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
%constraint
constr_A = [1,0,0,0;
            -1,0,0,0;
            0,1,0,0;
            0,-1,0,0;
            0,0,0,0;
            0,0,0,0;
            0,0,0,0;
            0,0,0,0;];
constr_B = zeros(8,2);
constr = [10;10;0;0;0;0;0;0];


zeta = 2;
delta = 1;
eta = delta;

%
% sim
%
out = sim("erg");

tu = out.u.Time;
t = out.x.Time;
u1 = out.u.Data(1,:);
u2 = out.u.Data(2,:);
x = out.x.Data(1,:)';
y = out.x.Data(2,:)';

figure
plot(tu,u1)
hold on
plot(tu,u2)
hold off
grid on
title('Control Inputs')

figure
scatter(x,y,[],t)
xlabel('time')
ylabel('x pos')
zlabel('y pos')
grid on
xline(constr(1),'r--')
xline(constr(1)-delta,'y--')
xline(constr(1)-zeta,'g--')
yline(constr(2),'r--')
yline(constr(2)-delta,'y--')
yline(constr(2)-zeta,'g--')
title('X,Y Coords')


