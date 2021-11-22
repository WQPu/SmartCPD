function [ Ten ] = gentensor( Setups, type, noisetype, noisedb )
%GENTENSOR Summary of this function goes here
%   Detailed explanation goes here

%% local parameters
Alevel = Setups.Alevel;
size_tens = Setups.size_tens;
R  = Setups.R;

options.Real = @rand;
A = cpd_rnd(size_tens,R,options); % Aij ~ unifom [0,1]
%% scaling 
if Setups.sd_pct>0
    for i = 1:length(A)
        for j = 1:R
            tmp_idx = randperm(size_tens(i));
            idx = tmp_idx(1:Setups.size_pct(i));
            A{i}(idx,j) = A{i}(idx,j)*10; % Aij ~ unifom [0,10]
        end
    end
end
% only for probability tensor
Ap = A;
Lambda  = ones(1,R);
%% generating data according to data type
switch type
    case 'Continuous'
        % scaling by Alevel
        [A] = scaleA_pos(A, Alevel, size_tens);
        
        % only for probability tensor, make sum(A,1) = 1
        for i = 1:length(size_tens)
            ltmp  = sum(Ap{i},1);
            Lambda = Lambda.*ltmp;
            Ap{i} = Ap{i}./(ones(size_tens(i),1)*ltmp);
        end
        Lambda = Lambda/sum(Lambda);
%         M = cpdgen(Ap); %probability tensor
        
        M = cpdgen(A);
        X = M;
        switch noisetype
            
            case 'Gaussian'
                %% Add additive Gaussian noise with certain SNR
                %                 ratio_m = sqrt(mean(M(:).^2));
                ns = randn(size(M));
                %                 ratio_n = sqrt(mean(ns(:).^2));
                ns = 10^(-noisedb/20)*ns/sqrt(mean(ns(:).^2))*sqrt(mean(M(:).^2));
                %                 ns = 10^(-noisedb/20)*ns;
                X = M + ns;
            case 'Gamma'
                %% Add mulitplicative Gamma noise with certain SNR
                ns = gamrnd(10^(noisedb/10)*ones(size(M)),10^(-noisedb/10)*ones(size(M)));
                X = M.*ns;
                %                 10*log(sqrt(mean(M(:).^2))/sqrt(mean((M(:)-X(:)).^2)))
        end
        
    case 'Binary-I' % theta = m/(1+m)
        [A] = scaleA_pos(A, Alevel, size_tens);
        M = cpdgen(A);
        
        Tmp = M./(1+M);
        X = binornd(1,Tmp,size_tens);
        
    case 'Binary-II' % theta = e^m/(1+e^m)
        [A] = scaleA_pn(A, Alevel, size_tens);
        M = cpdgen(A);
        
        Tmp = exp(M)./(1+exp(M));
        X = binornd(1,Tmp,size_tens);
        
    case 'Count-I' % theta = m
        [A] = scaleA_pos(A, Alevel, size_tens);
        M = cpdgen(A);
        
        Tmp = M;
        X = random('poisson',Tmp,size_tens);
        
    case 'Count-II' % theta = e^m
        [A] = scaleA_pn(A, Alevel, size_tens);
        M = cpdgen(A);
        
        Tmp = exp(M);
        X = random('poisson',Tmp,size_tens);
        
        
end

Ten.A = A;
Ten.M = M;
Ten.X = X;
Ten.Ap = Ap;
Ten.Lambda = Lambda;
end

function [A] = scaleA_pos(A, level, size_tens)
% scaling and shifting
for i = 1:length(size_tens)
    A{i} = level*(A{i});
end
end

function [A] = scaleA_pn(A, level, size_tens)
% scaling and shifting
for i = 1:length(size_tens)
    A{i} = level*(A{i} - 0.5);
end
end

