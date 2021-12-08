clc;clear;
%%====================== Read Me===========================
% This is a demo for SmartCPD, a stocastic mirror descent algorithm for low rank CPD with non-Euclidean losses.
% Reference: Pu, W., Ibrahim, S., Fu, X., & Hong, M. (2021). 
% Stochastic Mirror Descent for Low-Rank Tensor Decomposition Under Non-Euclidean Losses. arXiv preprint arXiv:2104.14562.
%
% Improtant parameters are explained below:
% Setups        ----        tensor size, rank, etc.
% datatype     ----        option for specifying tensor type, i.e.,  'Continuous', 'Binary-I', 'Count-I'
% losstype     ----        option for specifying loss type, i.e,'Gaussian', 'Beta(b)', 'Bernoulli-I', 'Poisson-I' 
% constype    ----        option for specifying constraint type, i.e., 'nonnegative', 'simplex'
% Ten             ----        struct variavle, includes generated data tensor and its latent matrices
% ops_smd    ----        algorithm parameters of SmartCPD
% SMDSet    ----         struct variavle, includes different algorithm parameters of SmartCPD
%
% 
% Coded by Wenqiang Pu, Shahana Ibrahim, Xiao Fu email: wenqiangpu@cuhk.edu.cn, (xiao.fu,ibrahish)@oregonstate.edu
%%====================== Read Me===========================
%% Setups 
[ Setups ] = initialTensor( ); % set tensor size, rank, etc

%% Generate Tensor
datatype = 'Count-I'; % 'Continuous' (for Beta Div.), 'Binary-I' (for Bernoulli), 'Count-I' (for Poisson)
noisetype = 'NoNoise'; % 'NoNoise', 'Gaussian', 'Gamma'
noisedb = 40; %SNR in dB

%% Problem Type
losstype = 'Beta(1)'; %'Gaussian', 'Beta(b)', 'Bernoulli-I', 'Poisson-I'
constype = 'nonnegative'; % 'nonnegative', 'simplex'

%% Simulation runs
seed_n = 1; % number of random seeds
Res = struct(); % store results

for cnt_seed = 1:seed_n
    %% Randomly Generate Data Tensor
    [ Ten ] = gentensor( Setups, datatype, noisetype, noisedb );
    %% Random Initialization
    A0  = initialA(Setups);
    F0 = lossfunc( Ten.X, Ten.M, losstype ); % loss for reference
    %%  Basic Settings of SmartCPD
    [ ops_smd ] = specSMDops( A0, Ten, Setups, losstype, constype, datatype );
    
    
    %% Different Alg. Parameters of SmartCPD
    [ SMDSet ] = specSMDAlgSet();
    
    for cnt = 1:length(SMDSet)
        ops_smd.b0 = SMDSet(cnt).b0;
        ops_smd.phitype = SMDSet(cnt).phitype;
        ops_smd.stype = SMDSet(cnt).stype;
        ops_smd.nin = SMDSet(cnt).nin;
        ops_smd.eta = SMDSet(cnt).eta;
        
        [ Res(cnt_seed).SMD(cnt).A,  Res(cnt_seed).SMD(cnt).mse_T,  Res(cnt_seed).SMD(cnt).mse_A, Res(cnt_seed).SMD(cnt).fv, Res(cnt_seed).SMD(cnt).time ] = ...
            SmartCPD(Ten.X, ops_smd);
    end
    
    
    %% GCP-OPT 
    Sampn = ops_smd.n_mb*Setups.Imean; % no. of samples
    [ typegcp ] = converttypeforgcp( losstype );
    [A_gcp,A0_gcp,info] = gcp_opt_mod(tensor(Ten.X), Ten.A, Setups.R,'type',typegcp,'opt','adam','init',A0,'gsamp',...
        Sampn,'ftype',losstype,'datatype',datatype);
    Res(cnt_seed).mse_A_gcp = info.mse_a_trace';
    Res(cnt_seed).mse_T_gcp = info.mse_t_trace';
    Res(cnt_seed).fv_gcp = info.fval_trace';
    Res(cnt_seed).time_gcp = info.time_trace';
    
end

%% mse figure

for i = 1:length(Res(cnt_seed).SMD)
    legend_str{i} = ['SmartCPD (',SMDSet(i).stype,', ',SMDSet(i).phitype,')'];
end
legend_str{i+1} = 'GCP-OPT (Adam)';


cst = 1e-12;
figure;
for i = 1:length(Res(cnt_seed).SMD)
    semilogy( Res(cnt_seed).SMD(i).time, Res(cnt_seed).SMD(i).mse_A+cst,'linewidth', 2);
    hold on;
end
semilogy( Res(cnt_seed).time_gcp, Res(cnt_seed).mse_A_gcp+cst,'g-','linewidth', 2);
grid on;
xlabel('Time [s]');
ylabel('MSE');
legend(legend_str,'location','best');
set(gca,'fontsize',18);
title(['Data: ',datatype,', Loss: ', losstype]);





