function [ phitype ] = jensentype( ftype )
%JENSENTYPE Summary of this function goes here
%   Detailed explanation goes here
%% default choice for phi(x)
        % ----- Beta(c) -----
        % beta > 1        phitype: x^(beta), e.g., beta = 2.5, x^(2.5)
        % beta = 1        phitype: -logx
        % beta < 1        phitype: x^(beta-1), e.g., beta = 0, x^(-1)
        % ----- Gaussian -----
        % phitype: x^2
%% specify phitype 
if ~isempty(strfind(ftype,'Beta'))
    
    beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
    beta = str2double(beta);
    
    
    if beta >1
            phitype = ['x^',num2str(beta)];
    elseif beta == 1
            phitype = '-logx';
    else
            phitype = ['x^',num2str(beta-1)];
    end
    
else
    
    switch ftype
        
        case 'Gaussian'
            phitype = 'x^2';
        case 'Poisson-I'
            phitype = '-logx';
%         case 'Poisson-II'
%            phitype = 'x^2';
        case 'Gamma'
            phitype = 'x^-1';
        case 'Bernoulli-I'
            phitype = '-logx';
%         case 'Bernoulli-II'
%             phitype = 'x^2';

    end
    
end

end

