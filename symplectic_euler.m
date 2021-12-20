close all; clear; clc;

% time
dt = 0.01;
T1 = 10;
TT = 0:dt:T1;

% system
m = 1
Kp = 3.3333;
Kd = 2.5560;

% xdot = dx
% dxdot = (-Kp/m)*(x-vbar) - (Kd/m)*(dx)

% symplectic euler
vbar =[10;10];

x0 = [0;0];
dx0 = [0;0];

eul.x = [x0];
eul.dx = [dx0];

for k = 1:length(TT)
    xk = eul.x(:,k);
    dxk = eul.dx(:,k);

    eul.dx(:,k+1) = eul.dx(:,k) + dt*( (-Kp/m)*(xk-vbar) - (Kd/m)*(dxk) );
    eul.x(:,k+1) = xk + dt*eul.dx(:,k+1);
end

figure
plot(eul.x(1,:),eul.x(2,:))
