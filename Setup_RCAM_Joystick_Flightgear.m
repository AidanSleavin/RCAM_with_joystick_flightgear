clear all; close all; clc;

%% using trim values
load trim_values
x0=xSolve%initial state condition
u0=uSolve
TF=60%simulation time

%setup curvature of earth WGS84 model
a=6378137.0;
e=0.08181919084622

%initial lat long height
% lat=21.315603*pi/180;%honolulu
% long=-157.858093*pi/180;
lat=47.608013*pi/180;%seattle
long=-122.335167*pi/180;
h=700;

%% run
sim('RCAM_Simulation.slx')