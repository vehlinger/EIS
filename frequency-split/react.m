function rate = react(j,C,params,op_cond)
% Function for handling homoegenous reactions
ii1 = 1; iv1 = 2; ii2 = 3; iv2 = 4; iyO2 = 5; iNO2 = 6;

T = op_cond(2); p = op_cond(5); Tref = 303.15; 

% physical constants
R = 8.314;  % J/mol K
F = 96485;  % C/mol
FRT = F/(R*T);

alpha = params(3); a12 = params(6);    
% exchange current density (A/cm2)
i0ORR = 1e-7*exp((73269/R)*(1/Tref-1/T)); 
U0 = 4.1868*(70650+8*T*log(T)-92.84*T)/(2*F); % standard potential (V)
rate = (a12/(4*F))*i0ORR*p*C(j,iyO2)*...
    exp(-alpha*FRT*(C(j,iv1)-C(j,iv2)-U0));

end