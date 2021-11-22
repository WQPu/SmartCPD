function [ L,  G_sq, L_sq] = sampL( X, H, A, G, G_sq, L_sq, eta, ftype, Ltype )
%SAMPLT Summary of this function goes here
%   Detailed explanation goes here

% epsilon = 1e-9;

% X \approx H*A';
[Fn,In] = size(X);

x = sum(abs(X),2);

idx = find(x == 0);
if ~isempty(idx)
X(idx,:) = [];
Fn = Fn - length(idx);

H(idx,:) = [];
end

switch Ltype
    
    case 'jensen' % calculate L based on Jesense's inequality
        
        Xm = H*A';
        
        %% compute Lt
        if ~isempty(strfind(ftype,'Beta'))
            
            beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
            beta = str2double(beta);
            
            if beta == 2
                L = H'*Xm./(A')/2;
            elseif beta == 1
                L = A' .* (H'*(X./Xm));
            elseif  beta == 0
                L = A'.^2 .* (H'*(X./Xm.^2));
            elseif beta >1
                L = (H'*(Xm.^(beta-1)))./(A'.^(beta-1))/beta;
            elseif beta<1
                L = (H'*(X .* (Xm.^(beta-2))))./(A'.^(beta-2))/(1-beta);
            else
                
            end
            L = L/Fn/In;
        else
            
            switch ftype
                
                case 'Gaussian'
                    L = H'*Xm./(A')/2;
                    L = L/Fn/In;
                case 'Poisson-I'
                    L = A' .* (H'*(X./Xm));
                    L = L/Fn/In;
                    
%                     L_sq = L.^2 + L_sq;
%                     L = sqrt(L_sq);
                case 'Gamma'
                    L = A' .* (H'*(X./Xm.^2));
                    L = L/Fn/In;
                case 'Bernoulli-I'
                    L = A' .* (H'*(X./Xm));
                    L = L/Fn/In;
                    

            end
            
        end
                

    case 'adagrad'
        G_sq = G.^2 + G_sq;
        L = sqrt(G_sq);
        
    case 'constant'
        L = 1/eta;
        
        


end



