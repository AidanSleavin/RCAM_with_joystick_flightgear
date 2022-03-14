function [CL,CD,CY]=RCAM_model_A(x,u)
    %%%%% calculating indeterminate variables
    Va=sqrt(x(1)^2+x(2)^2+x(3)^2);%airspeed
    alpha=atan2(x(3),x(1));%angle of attack
    beta=asin(x(2)/Va);%sideslip angle
    roh=1.225;%air density, assuming sea level
    Q=1/2*roh*Va^2;%Dynamic pressure
    wbc=[x(4);x(5);x(6)];
    Vb=[x(1);x(2);x(3)];
    
    %%%%% calculating lift from wing CLwb
    alpha0=-11.5*pi/180;
    n=5.5;
    if alpha<14.5*pi/180%calculating CLwb as a piecewise
        CLwb=n*(alpha-alpha0);
    else
        a3=-768.5;
        a2=609.2;
        a1=-155.2;
        a0=-15.212;
        CLwb=a3*alpha^3+a2*alpha^2+a1*alpha*a0;
    end
    
    %%%%% calculating lift from tail CLt
    epsilon=0.25*(alpha-alpha0);%calculates espilon
    lt=24.8; %how far back the tail is
    alphaT=alpha-epsilon+u(2)+1.3*x(5)*lt/Va;%calculates AoA of the tail
    St=64; %planform area of tail
    S=260; %planform area of wing
    CLt=3.1*St/S*alphaT;

    %%%%% total lift coefficiant CL
    CL=CLwb+CLt;

    %%%%% total drag coeficiant CD
    CD=0.13+0.07*(5.5*alpha+0.654)^2;
    
    %%%%% total sideforce coefficient CY
    CY=-1.6*beta+0.24*u(3);
    
end