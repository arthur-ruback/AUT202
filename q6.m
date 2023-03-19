clc;
clear;
close all;

T = 2; % secondes de simulation

set_param('q5/Integrator_x1', 'InitialCondition', '0');
set_param('q5/Integrator_x2', 'InitialCondition', '0');
set_param('q5/Integrator_x3', 'InitialCondition', '0');
set_param('q5/Integrator_x4', 'InitialCondition', '0');
options = simset('MaxStep',0.01);
out = sim("q5.slx",T, options);

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