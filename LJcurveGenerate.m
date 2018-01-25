clear
clc
cdir=pwd;
dirName='move';
linuxDir='//mnt/research/msce/jialin/vaspwork/Aragnite/cal/StackingFault';          % Change this accordingly
filename='CaCO3Relaxed.vasp';
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ] = loadPOSCAR( filename );
moveDirection=coordinate1(5,:)-coordinate1(2,:);
normMoveDirection=moveDirection/norm(moveDirection);
moveDistance=-1:0.05:5;
oriCa=coordinate1(4,:);
for i=moveDistance
    coordinate1(4,:)=oriCa+i;
end