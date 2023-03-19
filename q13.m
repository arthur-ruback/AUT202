clc;
clear;
close all;

% declaration constants
J = 0.02; % kg.m^2
m = 0.6; % kg
sigma = 0.8; % adimentional
g = 9.81; % m/s^2

A = [0 1 0 0;
     0 0 -g/(1+sigma) 0
     0 0 0 1
     -m*g/J 0 0 0];

B = [0; 0; 0; 1/J];

C = [1 0 0 0;
     0 0 1 0];

omega = (m*g^2/((1+sigma)*J))^(1/4);
P = [-omega,-2*omega,-omega+1i*omega,-omega-1i*omega];

T = 5; % secondes de simulation
% position de réference
% vecteur d'entré será interpolé pendent le temps de simulation
sampleTime = 0.01; 
numSteps = T/sampleTime + 1;
time = sampleTime*(0:numSteps-1)';
% fixed trajectory
data = zeros(numSteps,1) + 0;
% sinusoidal trajectory
%data = 0.2*sin(pi/2*time);
Rref = [time,data];

% gain de retroaction
K = place(A,B,P);
%K = [0 0 0 0]
Q = eye(1);
R = eye(4);
%K = lqr(A,B,R,Q)
% eig(A-B*K)
% SYS = ss(A-B*K,B,zeros(4,4),[0; 0; 0; 0]);
% figure(2)
% pzmap(SYS)


% valeurs initiaux systeme
set_param('simul/Integrator_x1', 'InitialCondition', '0.1');
set_param('simul/Integrator_x2', 'InitialCondition', '0');
set_param('simul/Integrator_x3', 'InitialCondition', '0');
set_param('simul/Integrator_x4', 'InitialCondition', '0');
% simulation parametres
options = simset('MaxStep',sampleTime);

out = sim("simul.slx",T, options);

% traitment output
figure(1)
subplot(4,1,1)
plot(out.tout,out.yout(:,1), Rref(:,1),Rref(:,2))
title('X1')
subplot(4,1,2)
plot(out.tout,out.yout(:,2))
title('X2')
subplot(4,1,3)
plot(out.tout,out.yout(:,3))
title('X3')
subplot(4,1,4)
plot(out.tout,out.yout(:,4))
title('X4')
control_effort = (sum(abs(out.yout(:,5))))/size(out.yout,1);
control_max = max(abs(out.yout(:,5)));
dim = [0.02 0.68 .3 .3];
str = strcat("Effort de contrôle moyen : ",num2str(control_effort));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [0.74 0.68 .3 .3];
str = strcat("Effort max : ",num2str(control_max));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
