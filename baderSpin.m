clear;clc

%spinUpFile = 'F:\SPG\LiCoO2\cluster\K1-re\clusterLi37Co6O26_V_SP\BCF_up.dat';
%spinDonwFile = 'F:\SPG\LiCoO2\cluster\K1-re\clusterLi37Co6O26_V_SP\BCF_down.dat';

%spinUpFile = 'F:\SPG\LiCoO2\cluster\K1-re-constrained\clusterLi37Co6O26_1+_SP\BCF_up.dat';
%spinDonwFile = 'F:\SPG\LiCoO2\cluster\K1-re-constrained\clusterLi37Co6O26_1+_SP\BCF_down.dat';
%structureFile = 'F:\SPG\LiCoO2\cluster\K1-re-constrained\clusterLi37Co6O26_1+_SP\POSCAR';
directory = 'F:\SPG\LiCoO2\cluster\K1-re\clusterLi37Co6O26_V_SP\';
spinUpFilename = 'BCF_up.dat';
spinDownFilename = 'BCF_down.dat';
structureFilename = 'POSCAR';

spinUpFile = [directory spinUpFilename];
spinDownFile = [directory spinDownFilename];
structureFile = [directory structureFilename];

[~,X1,Y1,Z1, CHARGE1, AtomIdx1, DISTANCE1] = importBCF(spinUpFile,3,70);
[~,X2,Y2,Z2, CHARGE2, AtomIdx2, DISTANCE2] = importBCF(spinDownFile,3,70);

[~, I1] = sort(AtomIdx1);
chargeSorted1 = CHARGE1(I1);
[~, I2] = sort(AtomIdx2);
chargeSorted2 = CHARGE2(I2);

plotPOSCAR(structureFile);



totalSpin = chargeSorted1-chargeSorted2;
sumSpin = sum(totalSpin)