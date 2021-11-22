function [ options ] = speOPSforgndl(A, A0,ftype )
%SPEOPSFORGNLB Summary of this function goes here
%   Detailed explanation goes here


options = {};

% Large scale options
options.LargeScale = true; % Use large-scale variant -- set to false to solve JZJp =-g exactly
options.CGMaxIter = 50; % Maximal number of CG iterations
options.M = 'block-Jacobi'; % Preconditioner (alternative for non-LS cost: 'jacobi')
options.CompressD = 5; % Compression factor of second order information

% Set stopping criteria
options.MaxIter = 200; % Maximal number of iterations
options.TolFun = 1e-10; % Relative function value change
options.TolX = 1e-10; % Relative model change

% Choose optimization algorithm
options.Algorithm = @nlsb_gndl; % or @nlsb_gncgs

% Specify that Hessian approximation is positive semi-definite to use CG
options.PosDef = 1;

% Set print options
options.Display = 10; % Print progress after x iterations

% Specify upper and lower bounds (default: 0 and inf, respectively)
lb = cellfun(@(u) zeros(size(u)), A0, 'UniformOutput', false);
ub = cellfun(@(u) inf(size(u)), A0, 'UniformOutput', false);
options.UpperBound = ub;
options.LowerBound = lb;

options.A_gt = A;
% refer testgenfunc.m
options.PosDef = 0;
beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
beta = str2double(beta);
options.bt = beta;
end

