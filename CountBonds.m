clear
filename='PerfectSlabRelaxed.vasp';
filename='TS_Rigid.vasp';
filename='NEB_TS.vasp';
filename='PerfectSlabRelaxedSlipSF.vasp';
filename='StackingFaultRelaxed.vasp';
%filename='test.vasp';
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename);
originalCellLength=[a1 b1 c1];                  % save the original cell length and atom position for later use
originalCell=coordinate1;
slipPlane=19;
HistRes=0.05;                                   % resolution
atomPair1=[1 2 3 1 1 2 2 3 3];
atomPair2=[1 2 3 2 3 3 1 1 2];
cutOff=5;                                       % cutoff radius
DisDistribution=zeros(size(0:HistRes:cutOff,2),size(atomPair1,2)); % initialization of length distribution matrix
dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;   % calculate the number of mirror image
atom(1)=0;                                      % the last serial number of atom i-1
atom(2)=atom1;
atom(3)=atom2+atom(2);
atom(4)=atom3+atom(3);
selectHi=[24.1,originalCellLength(2),originalCellLength(3)]; % Define the region in mode4
selectLo=[14.2 0 0];
% Display the calculation information
disp('----------Conditions-----------')
disp('File name:')
disp(filename)
disp('CutOff(A):')
disp(cutOff)
disp('Interaction pairs:')
disp(atomPair1)
disp(atomPair2)
disp('Region:')
selectHi
selectLo
disp('Histogram resolution')
disp(HistRes)
disp('-------------------------------')
disp('Calculating...')
bondRecord=zeros(size(0:HistRes:cutOff,1),100,2);% initialize the bond pair matrix
pointer=zeros(size(0:HistRes:cutOff,2),1);       % The pointer used to record the position of atom pairs in bondRecord
distanceX=0:HistRes:cutOff;                      % Different distances
NumOfBonds=zeros(size(atomPair1,2),1);
% Main loop
for i=1:size(atomPair1,2)                        % atom pairs
    disp(i/size(atomPair1,2));                   % progress bar
    atomIndex1=atomPair1(i);                     % get the current atom index
    atomIndex2=atomPair2(i);
    pair1Serial=atom(atomIndex1)+1:atom(atomIndex1+1); % get the serial number of atoms needed to be calculated
    pair2Serial=atom(atomIndex2)+1:atom(atomIndex2+1);
    for j=pair1Serial
        for k=pair2Serial
            condition1=(coordinate1(j,1)<selectHi(1))&&(coordinate1(j,2)<selectHi(2))&&(coordinate1(j,3)<selectHi(3));
            condition2=(coordinate1(j,1)>selectLo(1))&&(coordinate1(j,2)>selectLo(2))&&(coordinate1(j,3)>selectLo(3));
            condition3=(coordinate1(k,1)<selectHi(1))&&(coordinate1(k,2)<selectHi(2))&&(coordinate1(k,3)<selectHi(3));
            condition4=(coordinate1(k,1)>selectLo(1))&&(coordinate1(k,2)>selectLo(2))&&(coordinate1(k,3)>selectLo(3));
            if((j~=k)&&((condition1&&condition2)||(condition3&&condition4)))
                distanceVector=coordinate1(k,:)-coordinate1(j,:);
                distanceVector=distanceVector-[a1 b1 c1].*fix((2*distanceVector.*[1/a1 1/b1 1/c1]));
%                 if(abs(distanceVector(1))>0.5*a1)
%                     disp('Wrong')
%                     pause
%                 end
                bondLength=norm(distanceVector);
                NumOfBonds(i)=NumOfBonds(i)+0.5;
                DistributeIndex=round(bondLength/HistRes)+1;
                if(DistributeIndex>size(DisDistribution,1))
                    DisDistribution(DistributeIndex,i)=0;
                end
                DisDistribution(DistributeIndex,i)=DisDistribution(DistributeIndex,i)+0.5;
            end
        end
    end
end
NumOfPair=size(atomPair1,2);
NumOfSamePair=sum((atomPair1-atomPair2)==0);
NumOfDifferentPair=(NumOfPair-NumOfSamePair)/2;
DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))=DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))+DisDistribution(:,(NumOfSamePair+NumOfDifferentPair+1):end);
NumOfBonds((NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))=NumOfBonds((NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))+NumOfBonds((NumOfSamePair+NumOfDifferentPair+1):end);
aBondLength=zeros(1,NumOfSamePair+NumOfDifferentPair);
Length=0:HistRes:(size(DisDistribution,1)-1)*HistRes;
for i=1:NumOfSamePair+NumOfDifferentPair
    aBondLength(i)=sum(Length.*DisDistribution(:,i)')/NumOfBonds(i);
end
aBondLength