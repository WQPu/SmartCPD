function [ A] = solvesubp( A, G,  L,  phitype, constype )
%SAMPLT Summary of this function goes here
%   Detailed explanation goes here

epsilon = 1e-9;

switch constype
    
    case 'nonnegative' % constraint type
        if ~isempty(strfind(phitype,'x^'))
            
            c = regexp( phitype, '-?\d*\.?\d*', 'match' );
            c = str2double(c);
            
            if c == 2
                % subproblem: min <G, A> + L .* \| A - At \|^2
                A = max(A - G./L/2, epsilon);
            elseif c >1
                % subproblem: min <G, A> + L .* ( A^c - At^c -(cAt^(c-1), A - At) )
                A = max( (A.^(c-1) - G./L/c ).^(1/(c-1)), epsilon );
            elseif c<0
                % subproblem: min <G, A> + L .* ( A^c - At^c -(cAt^(c-1), A - At) )
                A = max( (A.^(c-1) - G./L/c ).^(1/(c-1)), epsilon );
            else
                disp('Wrong choie of the polynomial power! x^c  with 0<=c<=1 is not convex!')
            end
            
        else
            switch phitype
                
                case '-logx' % subproblem: min <G,A> + L .* (-logA + logAt + <1./At, A-At>)
                    A = max(A./(G.*A./L + 1), epsilon);
                    
                case 'xlogx' % subproblem: min <G,A> + L .* (AlogA - <logAt+1, A-At>)
                    A = max(A.*exp(-G./L), epsilon);
                    
                    % ====================== need to check ==========================
                    %
                case 'e^x' % subproblem: min <G,A> + L .* (e.^A - <e.^At, A - At>)
                    A = ones(size(A)) * epsilon;
                    idx = find(G./L - exp(A) <=-epsilon);
                    A(idx) = log(exp(A(idx)) - G(idx)./L(idx));
                    %                 case 'log(1+e^x)' % subproblem min <G,A> + L .* (log(1+e^A) - <e^At/(1+e^At), A - At>)
                    %                     eAt = exp(A);
                    %                     GAt = G.*(1+eAt);
                    %                     idx = find(G./L + 1/2 - eAt./(1+eAt) <=-epsilon);
                    %                     A = ones(size(A)) * epsilon;
                    %                     A(idx) = log( (L(idx).*eAt(idx) - GAt(idx)) ./ (GAt(idx) + L(idx)));
                    
                    
            end
        end
        
    case 'unconstrained' % constraint type
        if ~isempty(strfind(phitype,'x^'))
            
            c = regexp( phitype, '-?\d*\.?\d*', 'match' );
            c = str2double(c);
            
            if c == 2
                % subproblem: min <G, A> + L .* \| A - At \|^2m
                A = A - G./L/2;
            else
                disp('unconstrained: Other cases are not included in this version!');
            end
            
        else
            switch phitype
                case 'e^x' % subproblem: min <G,A> + L .* (e.^A - <e.^At, A - At>)
                    A = ones(size(A)) * epsilon;
                    idx = find(G./L - exp(A) <=-epsilon);
                    A(idx) = log(exp(A(idx)) - G(idx)./L(idx));
            end
        end
        
    case 'simplex'
        switch phitype
            
            case 'xlogx' % subproblem: min <G,A> + L .* (AlogA - <logAt+1, A-At>)
                A = max(A.*exp(-G./L), epsilon);
                A = A./(ones(size(A,1),1)*sum(A,1));
                
        end
        
        
    case 'l2ball' % constraint type
        disp('l2ball constraint: Not included in this version!');
        
    case 'l1ball' % constraint type
        disp('l1ball constraint: Not included in this version!');
        
end



