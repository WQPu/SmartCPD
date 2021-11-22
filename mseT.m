function [ mse ] = mseT( M, M_gt, datatype )
%MSET Summary of this function goes here
%   Detailed explanation goes here

m = M(:);
mgt = M_gt(:);
% n = length(m);
switch datatype
    case 'Continuous'
            mse = mean((m - mgt).^2);
    case 'Binary-I'
            mse = mean((m./(1+m) - mgt./(1+mgt)).^2);
    case 'Binary-II'
            mse = mean((exp(m)./(1+exp(m)) - exp(mgt)./(1+exp(mgt))).^2);
    case 'Count-I'
            mse = mean((m - mgt).^2);
    case 'Count-II'
            mse = mean((exp(m) - exp(mgt)).^2);
end
mse = mean((m - mgt).^2);
end

