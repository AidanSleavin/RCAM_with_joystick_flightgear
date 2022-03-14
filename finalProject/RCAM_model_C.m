function [FE_b,MEcg_b,Fg_b]=RCAM_model_C(x,u)
    %%%%% calculating indeterminate variables
    Va=sqrt(x(1)^2+x(2)^2+x(3)^2);%airspeed
    alpha=atan2(x(3),x(1));%angle of attack
    beta=asin(x(2)/Va);%sideslip angle
    roh=1.225;%air density, assuming sea level
    Q=1/2*roh*Va^2;%Dynamic pressure
    wbe=[x(4);x(5);x(6)];
    Vb=[x(1);x(2);x(3)];

    %%%%% calculating thrust from aircraft FE_b
    m=120000;%mass of aircraft
    g=9.81;%gravity
    F1=u(4)*m*g;%forces from each engine
    F2=u(5)*m*g;
    FE1_b=[F1;0;0];
    FE2_b=[F2;0;0];
    FE_b=FE1_b+FE2_b;%force vector

    %%%%% calculating propulsive/engine moment about body frame MEcg_b
    c=6.6;
    XAPT1=0;  YAPT1=-7.94;  ZAPT1=-1.9;%defining application points
    XAPT2=0;  YAPT2=7.94;   ZAPT2=-1.9;
    Xcg=0.23*c; Ycg=0; Zcg=0.1*c;
    u1=[Xcg-XAPT1;YAPT1-Ycg;Zcg-ZAPT1];%calculating mew matrix
    u2=[Xcg-XAPT2;YAPT2-Ycg;Zcg-ZAPT2];

    MEcg1_b=cross(u1,FE1_b);%solving for mements from each thruster
    MEcg2_b=cross(u2,FE2_b);
    
    MEcg_b=MEcg1_b+MEcg2_b;


    %%%%% calculating gravity effects
 
    %now rotate to Fb
    Fg_b=m*[-g*sin(x(8));...
            g*cos(x(8))*sin(x(7));...
            g*cos(x(8))*cos(x(7));];
    %note that Fg_b=Cbe*Fg_e and this is quicker to write as 
    %Fg_e=[0;0;g]*m and the zeros knock a lot of values out and dont
    %warrent wrigint the entire rotation matrix out

end