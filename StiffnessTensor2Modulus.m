function [YoungsModulus, BulkModulus, poissonsRatio] = StiffnessTensor2Modulus(C)
% C =   [258.9738  167.6379  180.0756    0.3421    6.8672    1.1527
%   174.7336  262.1635  183.5734    3.5748   -3.2099   -2.3276
%   184.8392  180.1117  261.8567    0.9509    2.4809   -0.9869
%    -0.3582    1.1462   -0.2730   68.1014   -4.6319   -3.5357
%     8.4397   -5.5091    2.5546   -5.3808   67.5559    1.4563
%    -4.6572   -4.8194   -2.3948   -4.6827    1.0869   46.2433];

S = inv(C);
YoungsModulus = [1/S(1,1),1/S(2,2),1/S(3,3)];
strainB = 0.01;
strainB = [ones(1,3).*strainB zeros(1,3)]';
stressB = C*strainB;
BulkModulus = mean(stressB(1:3))/((strainB(1)+1)^3-1);
E = YoungsModulus;
K = BulkModulus;
poissonsRatio = (3*K-E)/(6*K);


