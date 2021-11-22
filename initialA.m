function [ A0, Ap, Lambda ] = initialA( Ten )
%INITIALA Summary of this function goes here
%   Detailed explanation goes here
options.Real = @rand;
A0 = cpd_rnd(Ten.size_tens,Ten.R,options);
for i = 1:length(Ten.size_tens)
    A0{i} = Ten.Alevel*(A0{i});
end

% for probability tensor, make sum(A,1) = 1\
Ap = A0;
Lambda  = ones(1,Ten.R);
for i = 1:length(Ten.size_tens)
    ltmp  = sum(Ap{i},1);
    Lambda = Lambda.*ltmp;
    Ap{i} = Ap{i}./(ones(Ten.size_tens(i),1)*ltmp);
end
Lambda = Lambda/sum(Lambda);

end

