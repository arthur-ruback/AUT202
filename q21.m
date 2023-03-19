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

T = 10; % secondes de simulation
% position de réference
% vecteur d'entré será interpolé pendent le temps de simulation
sampleTime = 0.01; 
numSteps = T/sampleTime + 1;
time = sampleTime*(0:numSteps-1)';
% fixed trajectory
% data1 = [zeros(ceil(numSteps/2),1)] + 0;
% data2 = [zeros(ceil(numSteps/2)-1,1)] + 0.1;
% data = [data1; data2];
% sinusoidal trajectory
data = 0.4*sin(pi/2*time);
Rref = [time,data];

% gain de retroaction
%K = place(A,B,P);
%K = [0 0 0 0]
Q = eye(1);
R = eye(4);
K = lqr(A,B,R,Q)
%  eig(A-B*K)
%  SYS = ss(A-B*K,B,zeros(4,4),[0; 0; 0; 0]);
%  figure(2)
% pzmap(SYS)

PL = [-omega,-3*omega,-2*omega+1i*omega,-2*omega-1i*omega];
L = place(A',C',PL)';
% eig(A'-C'*L)/omega
% SYS = ss((A'-C'*L),B,zeros(4,4),[0; 0; 0; 0]);
% figure(2)
% pzmap(SYS)


% valeurs initiaux systeme
set_param('simul_observ/Integrator_x1', 'InitialCondition', '0.0');
set_param('simul_observ/Integrator_x2', 'InitialCondition', '0');
set_param('simul_observ/Integrator_x3', 'InitialCondition', '0');
set_param('simul_observ/Integrator_x4', 'InitialCondition', '0');
% valeurs initiaux observateur
set_param('simul_observ/Integrator_x1_obs', 'InitialCondition', '0.02');
set_param('simul_observ/Integrator_x2_obs', 'InitialCondition', '0');
set_param('simul_observ/Integrator_x3_obs', 'InitialCondition', '0');
set_param('simul_observ/Integrator_x4_obs', 'InitialCondition', '0');
% simulation parametres
options = simset('MaxStep',sampleTime);

out = sim("simul_observ.slx",T, options);

% traitment output
figure(1)
subplot(4,1,1)
plot(out.tout,out.yout(:,1), out.tout,out.yout(:,6), Rref(:,1),Rref(:,2))
legend('real','estime','reference')
title('X1')
subplot(4,1,2)
plot(out.tout,out.yout(:,2), out.tout,out.yout(:,7))
title('X2')
subplot(4,1,3)
plot(out.tout,out.yout(:,3),out.tout,out.yout(:,8))
title('X3')
subplot(4,1,4)
plot(out.tout,out.yout(:,4),out.tout,out.yout(:,9))
title('X4')
control_effort = (sum(abs(out.yout(:,5))))/size(out.yout,1);
control_max = max(abs(out.yout(:,5)));
dim = [0.02 0.68 .3 .3];
str = strcat("Effort de contrôle moyen : ",num2str(control_effort));
annotation('textbox',dim,'String',str,'FitBoxToText','on');
dim = [0.74 0.68 .3 .3];
str = strcat("Effort max : ",num2str(control_max));
annotation('textbox',dim,'String',str,'FitBoxToText','on');


Observ = [C; C*A; C*A*A; C*A*A*A];
ctrb(A',C')';
rang = rank(Observ)
