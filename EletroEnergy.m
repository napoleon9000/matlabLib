clear
%----------------------------
% Define file names
filename1='1PS.vasp';
%%%%filename='TS_Rigid.vasp';
filename2='3SF.vasp';
filename3='4TwinNEB.vasp';
filename=char(filename1,filename2,filename3);

% Define parameters


fileNum=1:3;       
atomCharge=[-5.64/3 1.64 4];                    % atom charge 
atomPair1=[1 2 2];                            % atom pairs need to be calculated
atomPair2=[1 2 1];
coordinateNumber=[6 6 9];
cutoff=[0 3;0 4.3;2.4 3.4];
region=[0 1;0 1;0 1];

for i=fileNum
    [ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename(i,:));
    coordinate1=InsertAtomInfo(coordinate1,atom1,atom2,atom3);    
    dimension(1)=ceil(cutOff(1,2)/a1+0.5)-1;   % calculate the number of mirror image
    dimension(2)=ceil(cutOff(2,2)/b1+0.5)-1;
    dimension(3)=ceil(cutOff(3,2)/c1+0.5)-1;
    imageMove=GenerateImageMatrix( dimension );
    
    
    
    
    
    
    
end




