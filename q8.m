clc;
clear;
close all;

T = 2; % secondes de simulation
% position de réference
% vecteur d'entré será interpolé pendent le temps de simulation
Rref = [0.1 0.1]; 
% gain de retroaction
K=[0 0 0 0];
% valeurs initiaux
set_param('simul/Integrator_x1', 'InitialCondition', '0.1');
set_param('simul/Integrator_x2', 'InitialCondition', '0');
set_param('simul/Integrator_x3', 'InitialCondition', '0.1');
set_param('simul/Integrator_x4', 'InitialCondition', '0');
% simulation parametres
options = simset('MaxStep',0.01);

out = sim("simul.slx",T, options);

% traitment output
figure(1)
subplot(4,1,1)
plot(out.tout,out.yout(:,1))
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