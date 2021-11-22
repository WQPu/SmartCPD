function [ type ] = converttypeforgcp( ftype )
%CONVERTTYPEFORGCP Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(strfind(ftype,'Beta'))
    
    beta = regexp( ftype, '-?\d*\.?\d*', 'match' );
    beta = str2double(beta);
    type = ['Beta (',num2str(beta),')'];
    
    if beta == 2
        type = 'normal';
    elseif beta == 1
        type =  'count';
    end

else
    
    switch ftype
        
        case 'Gaussian'
            type = 'normal';
        case 'Poisson-I'
            type =  'count';
        case 'Poisson-II'
            type = 'poisson-log';
        case 'Gamma'
            type = 'gamma';
        case 'Bernoulli-I'
            type = 'binary';
        case 'Bernoulli-II'
            type = 'bernoulli-logit';

    end
    
end

end

