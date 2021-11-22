function [ ops ] = specSMDops( A0, Ten, Setups,  losstype, constype, datetype)
%SPECSDMOPS Summary of this function goes here
%   Detailed explanation goes here


% specify constraints type
for i = 1:Setups.n
    ops.constraint{i} = constype; %nonnegative, unconstrained
end

% important settings
ops.n_mb = max(2*Setups.R,20); % number of fibers
ops.nin= 1; % number of inner iterations
ops.max_it = (Setups.avg_nofiber/ops.n_mb)*200; % maximum number of iteration
ops.A_ini = A0; % initial A0
ops.A_gt = Ten.A; % use the ground truth value for MSE computation
ops.tol= 1e-10; % numerical precision


ops.losstype = losstype;
ops.datatype = datetype;

end

