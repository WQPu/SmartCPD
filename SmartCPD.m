function [ A, MSE_T , MSE_A , FVAL, TIME_A] = SmartCPD(X, ops)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SmartCPD Algorithm (Tensor decomposition using randomized block selection + fiber sampling + mirror descent + adaptive step size)
% ============== input =====================================
%   X  : data tensor
%   ops: algorithm parameters
%   o 'b0'                  - adagrad parameter
%   o 'eta'                 - stepsize parameter
%   o 'n_mb'                - Number of fibers
%   o 'max_it'              - Maximum number of iterations
%   o 'A_ini'               - Latent factor initializations
%   o 'losstype'          - loss function type
%   o 'stype'               - step size type, i.e., 'jensen', 'constant', 'adagrad' 
%   o 'phitype'             - phi type in Bregman divergence
%   o 'datatype'             - data type, i.e., 'count', 'binary',
%   o 'constraint'             - constraint type
%   o 'eta'                 - constant step size (for stype == 'constant')
%   o 'A_gt'                - Ground truth latent factors (for MSE computation only)
% =============================================================
% ============= output ========================================
% A: the estimated factors
% MSE_A : the MSE of A at different iterations
% MSE_T : the MSE of  tensor at different iterations
% FVAL : loss funtion value
% TIME_A: the walltime at different iterations
% =============================================================
% Coded by Wenqiang Pu, Shahana Ibrahim, Xiao Fu email: wenqiangpu@cuhk.edu.cn, (xiao.fu,ibrahish)@oregonstate.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Code
% Get the algorithm parameters
A       = ops.A_ini;
b0      = ops.b0;
n_mb    = ops.n_mb;
max_it  = ops.max_it;
A_gt    = ops.A_gt;

eta     = ops.eta;
nin     = ops.nin;

losstype = ops.losstype;
Ltype = ops.stype;
ptype = ops.phitype;
datatype = ops.datatype;
constype = ops.constraint;
if contains(Ltype,'jensen')
    ptype = jensentype( losstype ); % specify default choice of phi for 'jensen' step size rule
end
%% Get the initial parameters

XX = tensor(X);
dim = length(size(X)); % to decide the order of the tensor
dim_vec = size(X);
dim_cump = cumprod(dim_vec);

avg_fibers = round(mean(dim_cump(end)./dim_vec));

M_gt = cpdgen(A_gt);
M = cpdgen(A);

Gt_sq = cell(dim,1);
Lt_sq = cell(dim,1);
for nnn=1:dim
    Gt_sq{nnn}=b0;
    Lt_sq{nnn}=b0;
end
eta_out = 1; 
%% metrics at intial interation
FVAL(1) = lossfunc( X, M, losstype );
MSE_T(1) = mseT( M, M_gt, datatype );
MSE_A(1) = mseA( A, A_gt);


% count time
tt = tic;
TIME_A(1) = toc(tt);
% Lambda = ones(1,R);
%% Run the algorithm until the stopping criterion
mmm = 1;
for ite = 1:max_it
    % randomly permute the dimensions
    block_vec = randperm(dim);
    % select the block variable to update.
    d_update = block_vec(1);
    
    % sampling fibers
    [tensor_idx, factor_idx] = sample_fibers(n_mb, dim_vec, d_update);
    % reshape the tensor from the selected samples
    X_sample = reshape(XX(tensor_idx), dim_vec(d_update), [])';
    
    % perform a sampled khatrirao product
    ii=1;
    for i=[1:d_update-1,d_update+1:dim]
        A_unsel{ii}= A{i};
        ii=ii+1;
    end
    

    
    H = sampled_kr(A_unsel, factor_idx);
    for init = 1:nin
        %% Compute the gradient in the current iteration
        Gt = sampGrad( X_sample, H, A{d_update}, losstype );
        %% Calculate step size, Lt = 1/eta for constant step size
        [Lt,  Gt_sq{d_update}, Lt_sq{d_update}] = ...
            sampL( X_sample, H,  A{d_update}, Gt, Gt_sq{d_update}, Lt_sq{d_update}, eta, losstype, Ltype );
        
        %% Solve approximate subproblem
        % diminshing step size (optional)
%         eta_out = 1/it^0.02;

        A{d_update} = solvesubp( A{d_update}, Gt',  eta_out*Lt', ptype, constype{d_update} );
    end
    % compute MSE after each MTTKRP
    if mod(ite,(avg_fibers/n_mb))==0
        TIME_A(mmm+1) = TIME_A(mmm)+toc(tt);
        MSE_A(mmm+1) = mseA( A, A_gt);
        
        M = cpdgen(A);
        FVAL(mmm+1) = lossfunc( X, M, losstype );
        MSE_T(mmm+1) = mseT( M, M_gt, datatype );
        
        
        disp(['SMDCPD at epoch ',num2str(mmm+1),' and the MSE_A is ',num2str(MSE_A(mmm+1))])
        disp(['SMDCPD at epoch ',num2str(mmm+1),' and the FVAL is ',num2str(FVAL(mmm+1))])
        
        disp('====')
        mmm = mmm + 1;
        
        
        tt=tic;
    end
end
end
