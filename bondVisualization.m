clear
clc
load('Distribution2.mat');
load('bondRecord2.mat');
%filename='PerfectSlabRelaxed.vasp';
filename='PerfectRelaxedTS.vasp';
%%%%filename='TS_Rigid.vasp';
%filename='NEB_TS.vasp';
%filename='PerfectSlabRelaxedSlipSF.vasp';
%filename='StackingFaultRelaxed.vasp';
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename);
% cutOffCO3=1.5;
% ONumber=atom1;
% CaNumber=atom2;
% CNumber=atom3;
% OSerial=1:ONumber;
% CaSerial=ONumber+1:ONumber+CaNumber;
% CSerial=ONumber+CaNumber+1:ONumber+CaNumber+CNumber;
% CO3Coordinate1=CorrelateCO3(coordinate1,ONumber,CaNumber,CNumber,a1,b1,c1,cutOffCO3);
% coordinate1=adjustBoundary(coordinate1,CO3Coordinate1,a1,b1,c1);
originalCell=coordinate1;
length=2.05;
index=0;
range=1:2;
cutOff=8; 
HistRes=0.05;
distanceX=0:HistRes:cutOff;

if(index==0)
    index=find(abs(distanceX-length)<1e-6);
end
dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;
if(dimension>0)
    [ coordinate1,~, ~, ~, ~, ~, ~ ]=createSuperCell(filename,dimension);
end


hold on
grid on
box on
axis equal
axis([0 a1 0 b1 0 c1]);
for i=range
    start=coordinate1(bondRecord(index,i,1),:);
    finish=coordinate1(bondRecord(index,i,2),:);
    arrow=finish-start;
    quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0);
end


plot3(originalCell(1:atom1,1),originalCell(1:atom1,2),originalCell(1:atom1,3),'r*');
plot3(originalCell(atom1+1:atom1+atom2,1),originalCell(atom1+1:atom1+atom2,2),originalCell(atom1+1:atom1+atom2,3),'g*');
plot3(originalCell(atom2+atom1+1:atom2+atom1+atom3,1),originalCell(atom2+atom1+1:atom2+atom1+atom3,2),originalCell(atom2+atom1+1:atom2+atom1+atom3,3),'k*');
