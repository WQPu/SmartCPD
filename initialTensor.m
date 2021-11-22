function [ Setups ] = initialTensor( )
%INITIALTENSOR Summary of this function goes here
%   Detailed explanation goes here
%   Settings for generating tensor data

size_tens = [1 1 1]*5e1; % tensor size
n = length(size_tens); % tensor dimension
R = 5; % rank
Alevel = 1; % scaling for latent matrix, Aij~uniform [0,Alevel]

Imean = mean(size_tens); % mean In
size_cprod = cumprod(size_tens); % calculate J

sd_pct = 0.00; % percentage of Aij ~ uniform [0,10*Alevel]; c.f. Section V-A-2
size_pct = round(size_tens*sd_pct); % total number

avg_nofiber = round(mean(size_cprod(end)./size_tens));
%% save as struct
Setups.size_tens = size_tens;
Setups.n = n;
Setups.R = R;
Setups.Imean = Imean;
Setups.size_cprod = size_cprod;
Setups.Alevel = Alevel;
Setups.sd_pct = sd_pct;
Setups.size_pct = size_pct;
Setups.avg_nofiber = avg_nofiber;
end

