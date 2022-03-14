clear all; close all; clc;
%% define constants
x0=[150;...%u
    0;...%v
    0;...%w
    0;...%p
    0;...%q
    0;...%r
    0;...%phi
    0.05;...%theta
    0;];%psi

u=[0;...%aileron
   -0.05;...%tail
   0;...%rudder
   0.3;...%throttle minimum for throttles are 0.5*pi/180 = 0.0087
   0.3;];%throttle



TF=150;%simulation time
% 
% load('XU_data.mat')
% load('hw6_p1_part_a.mat')
% x0=simX.signals.values(1,:)';%comment out if this is not the initial state to be used
% TF=simU.time(end)%uncomment when using simulated data rather than constant
%u
%% using trim values
load trim_values
x0=xSolve;
u=uSolve;
TF=300

%% using linear analysis trim values found in HW 8
load op_trim1.mat
x0=op_trim1.States.x
for i=1:5
    u(i,1)=op_trim1.Inputs(i,1).u;
end
TF=300



%% run the model

sim=sim('RCAM_Simulation.slx')
t=sim.tout;
x=(sim.xSim.signals.values)';
u=(sim.uSim.signals.values)';

%% plotting inputs
subplot(3,2,1)
plot(t,u(1,:)); title('aileron')

subplot(3,2,3)
plot(t,u(2,:)); title('stabilizer')

subplot(3,2,5)
plot(t,u(3,:)); title('rudder')

subplot(3,2,2)
plot(t,u(4,:)); title('throtle 1')

subplot(3,2,4)
plot(t,u(5,:)); title('throtle 2')

%% plotting states

subplot(3,3,1)
plot(t,x(1,:)); title('u')

subplot(3,3,4)
plot(t,x(2,:)); title('v')

subplot(3,3,7)
plot(t,x(3,:)); title('w')

subplot(3,3,2)
plot(t,x(4,:)); title('p')

subplot(3,3,5)
plot(t,x(5,:)); title('q')

subplot(3,3,8)
plot(t,x(6,:)); title('r')

subplot(3,3,3)
plot(t,x(7,:)); title('phi')

subplot(3,3,6)
plot(t,x(8,:)); title('theta')

subplot(3,3,9)
plot(t,x(9,:)); title('psi')

%% plotting states against those given

subplot(3,3,1)
plot(t,x(1,:)); title('u');hold on
plot(simX.time,simX.signals.values(:,1),'r')

subplot(3,3,4)
plot(t,x(2,:)); title('v');hold on
plot(simX.time,simX.signals.values(:,2),'r')

subplot(3,3,7)
plot(t,x(3,:)); title('w');hold on
plot(simX.time,simX.signals.values(:,3),'r')

subplot(3,3,2)
plot(t,x(4,:)); title('p');hold on
plot(simX.time,simX.signals.values(:,4),'r')

subplot(3,3,5)
plot(t,x(5,:)); title('q');hold on
plot(simX.time,simX.signals.values(:,5),'r')

subplot(3,3,8)
plot(t,x(6,:)); title('r');hold on
plot(simX.time,simX.signals.values(:,6),'r')

subplot(3,3,3)
plot(t,x(7,:)); title('phi');hold on
plot(simX.time,simX.signals.values(:,7),'r')

subplot(3,3,6)
plot(t,x(8,:)); title('theta');hold on
plot(simX.time,simX.signals.values(:,8),'r')

subplot(3,3,9)
plot(t,x(9,:)); title('psi');hold on
plot(simX.time,simX.signals.values(:,9),'r')





