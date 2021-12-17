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
r = [3;6];

v0 = r0;
Kappa = 100;


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
constr.A = [1,0;
            -1,0;
            0,1;
            0,-1;
            -1,-1];
constr.b = [10;10;10;10;4];



zeta = 2;
delta = 0;
eta = 1;


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
v = out.v.Data;

figure
plot(tu,u1)
hold on
plot(tu,u2)
hold off
grid on
title('Control Inputs')

figure
% scatter(x,y,[],t,'.')
% scatter(v(1,:),v(2,:),[],t,'.')
plot(v(1,:),v(2,:))
axis([0,10,0,10])
xlabel('x pos')
ylabel('y pos')
grid on
xline(10,'r--')
xline(10-delta,'y--')
xline(10-zeta,'g--')
yline(10,'r--')
yline(10-delta,'y--')
yline(10-zeta,'g--')
line([4;0],[0;4],'linestyle','--','color','r')
line([4;0],[0;4],'linestyle','--','color','r')
title('v')

r
[x(end) y(end)]
[v(1,end) v(2,end)]


return

% %
% % symplectic euler
% %
% x0 = 0;
% dx0 = 0;
% eul.x = [x0];
% eul.dx = [dx0];
% for k = 1:10
%     eul.x(:,k) = 
% end


