function [xdot]=RCAM_model_D(x,u)
    xdot=zeros(length(x),1);%sets structure for xdot
    %%%%% calculating indeterminate variables
    Va=sqrt(x(1)^2+x(2)^2+x(3)^2);%airspeed
    alpha=atan2(x(3),x(1));%angle of attack
    beta=asin(x(2)/Va);%sideslip angle
    roh=1.225;%air density, assuming sea level
    Q=1/2*roh*Va^2;%Dynamic pressure
    wbe=[x(4);x(5);x(6)];
    Vb=[x(1);x(2);x(3)];

    %%%%% solving for FA to use in the next step
    [CL,CD,CY]=RCAM_model_A(x,u);
    S=260;
    FA_s=[-CD*Q*S;CY*Q*S;-CL*Q*S];
    Cbs=[cos(alpha),0,-sin(alpha);...
         0,1,0;...
         sin(alpha),0,cos(alpha)];
    FA_b=Cbs*FA_s;

    %%%%% solving for total forces
    [FE_b,MEcg_b,Fg_b]=RCAM_model_C(x,u);
    F_b=Fg_b+FE_b+FA_b;

    %%%%% solving for first three terms of xdot
    m=120000;
    xdot(1:3)=1/m*F_b-cross(wbe,Vb);

    %%%%% solving for terms 4-6 of xdot
    [MAcg_b]=RCAM_model_B(x,u);
    Mcg_b=MEcg_b+MAcg_b;
    I_b=m*[40.07,0,-2.0923;...%%note this is not the value from the RCAM document but from prof Lum's video RCAM uses 2.098 instead of -2.0923
           0,64,0;...
           -2.0923,0,99.92;];
    xdot(4:6)=inv(I_b)*(Mcg_b-cross(wbe,(I_b*wbe)));


    %%%%% solving for terms 7-9 of xdot
    phi=x(7);
    th=x(8);
    xdot(7:9)=[1,sin(phi)*tan(th),cos(phi)*tan(th);...
               0,cos(phi),-sin(phi);...
               0,sin(phi)/cos(th),cos(phi)/cos(th)]*wbe;
end