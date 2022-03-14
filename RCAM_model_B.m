function [MAcg_b]=RCAM_model_B(x,u)
    %%%%% calculating indeterminate variables
    Va=sqrt(x(1)^2+x(2)^2+x(3)^2);%airspeed
    alpha=atan2(x(3),x(1));%angle of attack
    beta=asin(x(2)/Va);%sideslip angle
    roh=1.225;%air density, assuming sea level
    Q=1/2*roh*Va^2;%Dynamic pressure
    wbe=[x(4);x(5);x(6)];
    Vb=[x(1);x(2);x(3)];

    %%%%% solving for moment coefficiant CMac
    c=6.6;
    lt=24.8; %how far back the tail is
    St=64; %planform area of tail
    S=260; %planform area of wing
    alpha0=-11.5*pi/180;
    epsilon=0.25*(alpha-alpha0);%calculates espilon
    eta=[-1.4*beta;...%calculates eta
        -0.59-3.1*St*lt/(S*c)*(alpha-epsilon);...
        (1-alpha*180/(15*pi))*beta];

    dCMdx=[-11,0,5;...
        0,-4.03*St*(lt^2)/(S*(c^2)),0;...
        1.7,0,-11.5;]*c/Va;
    dCMdu=[-0.6,0,0.22;...
        0,-3.1*St*lt/(S*c),0;...
        0,0,-0.63;];

    CMac=eta+dCMdx*wbe+dCMdu*[u(1);u(2);u(3)];
    
    %%%%% solving for the moment about AC MAac_b
    MAac_b=CMac*Q*S*c;
    
    %%%%% solving for FA to use in the next step
    [CL,CD,CY]=RCAM_model_A(x,u);
    FA_s=[-CD*Q*S;CY*Q*S;-CL*Q*S];
    Cbs=[cos(alpha),0,-sin(alpha);...
         0,1,0;...
         sin(alpha),0,cos(alpha)];
    FA_b=Cbs*FA_s;
    %%%%% solving for the moment about CG MAcg_b
    rcg_b=[0.23*c;0;0.1*c];
    rac_b=[0.12*c;0;0];
    MAcg_b=MAac_b+cross(FA_b,(rcg_b-rac_b));








end