function [ G ] = sampGrad( X, H, A, ftype )
%LOSSFUNC Summary of this function goes here
%   Detailed explanation goes here
%   Compute the gradient w.r.t. A


epsilon = 1e-9;

% X \approx H*A';
[Fn,In] = size(X);

Xm = H*A';
if ~isempty(strfind(ftype,'Beta'))
    
    beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
    beta = str2double(beta);
    
    if beta >2
            G = (H'*(Xm.^(beta-2).*(Xm-X)));
    elseif beta == 2
            G = H'*(Xm-X);
    elseif beta == 1
            G = H'*(-(X./(Xm + epsilon)) + 1);
    elseif  beta == 0
            G = (H'*((Xm-X)./(Xm + epsilon).^2));
    else
            G = (H'*( ( (Xm ).^(beta-2) ) .* (Xm-X) ));
    end
    
else
    
    switch ftype
        
        case 'Gaussian'
            G = H'*(Xm-X);
        case 'Poisson-I'
            G = H'*(-(X./(Xm + epsilon)) + 1);
        case 'Poisson-II'
            G = H'*(exp(Xm) - X);
        case 'Gamma'
            G = H'*((Xm-X)./(Xm + epsilon).^2);
        case 'Bernoulli-I'
            G = H'*(1./(Xm + 1) - X./(Xm+ epsilon));
        case 'Bernoulli-II'
            G = H'*(exp(Xm)./(1+exp(Xm)) - X);
        case 'Rayleigh'
%             G = H'*(2./(Xm+ epsilon))

    end
    
end

G = G/Fn/In;

end

