function [ SMDSet ] = specSMDAlgSet(  )
%SPECSDMALGSET Summary of this function goes here
%   Detailed explanation goes here
%   stype	--	 step size rule; i.e., 'jensen', 'adagrad', 'constant'; 
%   phitype	 --	  phi for Bregman divergence; i.e., -logx, xlogx, x^c (c>1 orc<0). c.f. Table IV,V
%   b0	 --	  constant for 'adagrad', c.f. E.q. (14)
%   nin   --	number of inner iteration
%   eta   --    constant step size
%   notice 'jensen' step size should use 'default' setting for phitype

% Recommend choice for different loss
% continuous data with beta-div.   ----    stype='jensen', phitype='default', b0, eta is not used in such setting
% count data with KL-div.   ----    stype='adagrad', phitype='xlogx', b0=1e-5, eta is not used in such setting
% binary data with log(m+1)-xlog(m)   ----    stype='adagrad', phitype='xlogx', b0=1e-5, eta is not used in such setting
% other losses   ----    stype='adagrad', phitype='x^2', b0=1e-5, eta is not used in such setting


SMDSet = struct();
cnt = 1;
SMDSet(cnt).stype = 'constant'; 
SMDSet(cnt).phitype = 'x^2';
SMDSet(cnt).b0 = 1e-4;
SMDSet(cnt).eta = 5;
SMDSet(cnt).nin = 1;

cnt = cnt + 1;
SMDSet(cnt).stype = 'constant';
SMDSet(cnt).phitype = 'xlogx';
SMDSet(cnt).b0 = 1e-4;
SMDSet(cnt).eta = 5;
SMDSet(cnt).nin = 1;


cnt = cnt + 1;
SMDSet(cnt).stype = 'adagrad';
SMDSet(cnt).phitype = 'xlogx';
SMDSet(cnt).b0 = 1e-6;
SMDSet(cnt).eta = 1;
SMDSet(cnt).nin = 1;


% cnt = cnt + 1;
% SMDSet(cnt).stype = 'jensen';
% SMDSet(cnt).phitype = ' ';
% SMDSet(cnt).b0 = 1e-4;
% SMDSet(cnt).eta = 10;
% SMDSet(cnt).nin = 1;


% cnt = cnt + 1;
% SMDSet(cnt).stype = 'constant';
% SMDSet(cnt).phitype = 'x^2';
% SMDSet(cnt).b0 = 1e-6;
% SMDSet(cnt).eta = 10;
% SMDSet(cnt).nin = 1;
% cnt = cnt + 1;
% SMDSet(cnt).stype = 'adam';
% SMDSet(cnt).phitype = 'x^2';
% SMDSet(cnt).b0 = 1e-3;
% SMDSet(cnt).nin = 1;



% cnt = cnt + 1;
% SMDSet(cnt).stype = 'adam';
% SMDSet(cnt).phitype = 'x^2';
% SMDSet(cnt).b0 = 1e-3;
% SMDSet(cnt).nin = 1;

% cnt = cnt + 1;
% SMDSet(cnt).stype = 'adam';
% SMDSet(cnt).phitype = 'x^2';
% SMDSet(cnt).b0 = 1e-3;
% SMDSet(cnt).nin = 1;
% cnt = cnt + 1;
% SMDSet(cnt).stype = 'adam';
% SMDSet(cnt).phitype = 'xlogx';
% SMDSet(cnt).b0 = 1e-2;
% SMDSet(cnt).nin = 1;

end

