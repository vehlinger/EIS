function NL = fluxleft_fsplit(j,i,C,C_ss,params,op_cond,dx)
% Calculates the flux exiting the box to the left of point j
% Variable Identifiers  
    ii1 = 1; iv1 = 2; ii2 = 3; iv2 = 4; iyO2 = 5; iNO2 = 6;
    n = params(1);
    
% Flux in the box to the left
if i == ii2 || i == ii2+n
    flux = C(j-1,i);
elseif i == iNO2 || i == iNO2+n
    flux = C(j,i);
end

% Reaction terms
F = 96845;
st = zeros(2*n,2);
st(ii2,:) = [-4*F 0]; st(iNO2,:) = [-1 0];
st(ii2+n,:) = [0 -4*F]; st(iNO2+n,:) = [0 -1];
rate = react_fsplit(j,C,params,op_cond,C_ss);
if j ~= 1
    rateL = react_fsplit(j-1,C,params,op_cond,C_ss);
else
    rateL = rate;
end
w = 0.5;
gen  = sum(st(i,:).*(w*rate+(1-w)*rateL)*dx/2);

a = params(6); Cdl = params(7); omega = op_cond(6);
if i == ii2 
    if j == 1
        dVdt = -a*Cdl*omega*(C(j,iv1+n)-C(j,iv2+n));
    else
        dVdt = -0.5*a*Cdl*omega*(C(j,iv1+n)-C(j,iv2+n))-...
            0.5*a*Cdl*omega*(C(j-1,iv1+n)-C(j-1,iv2+n));
    end
    acc = dVdt*dx/2;
elseif i == ii2+n
    if j == 1
        dVdt = a*Cdl*omega*(C(j,iv1)-C(j,iv2));
    else
        dVdt = 0.5*a*Cdl*omega*(C(j,iv1)-C(j,iv2))+...
            0.5*a*Cdl*omega*(C(j-1,iv1)-C(j-1,iv2));
    end
    acc = dVdt*dx/2;
elseif i == iNO2 
    R = 83.14; % cm3 bar / mol K
    T = op_cond(2); p = op_cond(5); CT = p/(T*R);
    if j == 1
       dcdt = -omega*CT*C(j,iyO2+n);
    else
        dcdt = -0.5*omega*CT*C(j,iyO2+n)-0.5*omega*CT*C(j-1,iyO2+n);
    end
    acc = dcdt*dx/2;
elseif i == iNO2+n
    R = 83.14; % cm3 bar / mol K
    T = op_cond(2); p = op_cond(5); CT = p/(T*R);
    if j == 1
        dcdt = omega*CT*C(j,iyO2);
    else
        dcdt = 0.5*omega*CT*C(j,iyO2)+0.5*omega*CT*C(j-1,iyO2);
    end
   acc = dcdt*dx/2;
end

NL = flux + gen - acc;
end