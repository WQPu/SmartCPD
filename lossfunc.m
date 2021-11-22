function [ fv, fv_tab ] = lossfunc( X, M, ftype )
%LOSSFUNC Summary of this function goes here
%   Detailed explanation goes here
epsilon = 1e-9;

% [Fn,In] = size(X);

if ~isempty(strfind(ftype,'Beta'))
    
    beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
    beta = str2double(beta);
    
    
    if beta >2
            fv = (M.^beta)/beta - X.*(M.^(beta-1))/(beta - 1);
    elseif beta == 2
            fv = ((X-M).^2)/2;
    elseif beta == 1
            fv = M - X.*log(M + epsilon);
    elseif  beta == 0
            fv = X./(M+epsilon)  + log(M + epsilon);
    else
            fv = ((M+epsilon).^beta)/beta - X.*((M+epsilon).^(beta-1))/(beta - 1);
    end
    
else
    
    switch ftype
        
        case 'Gaussian'
            fv = ((X - M).^2)/2;
        case 'Poisson-I'
            fv = M - X.*log(M + epsilon);
        case 'Poisson-II'
            fv = exp(M) - X.*M;
        case 'Gamma'
            fv = X./(M+epsilon)  + log(M + epsilon);
        case 'Bernoulli-I'
            fv = log(M + 1) - X.*log(M + epsilon);
        case 'Bernoulli-II'
            fv = log(1 + exp(M)) - X.*M;

    end
    
end
fv_tab = fv(:);
fv = sum(fv_tab)/length(fv(:));

end

