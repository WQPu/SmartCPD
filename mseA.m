function [ mse ] = mseA( A_m,A_gt)
%MSEA Summary of this function goes here
%   Detailed explanation goes here
dim = length(A_m);
R = size(A_m{1},2);
mse = 0;
for bl = 1:dim
    mse = mse + MSE_measure(A_m{bl},A_gt{bl});
end
mse = mse/R;
end

