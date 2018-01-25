clear
filename='PerfectSlabRelaxed.vasp';
%filename='PerfectRelaxedTS.vasp';
%%%%filename='TS_Rigid.vasp';
%filename='NEB_TS.vasp';
%filename='PerfectSlabRelaxedSlipSF.vasp';
%filename='StackingFaultRelaxed.vasp';
%filename='test3.vasp';
debug=0;
plotNumber=0;
plotStructure=0;
plotDistribution=1;
mode=2;  % 1:csym 2:sumation
% load the structure
%[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR('NEB_TS.vasp');
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename);
originalCellLength=[a1 b1 c1];                  % save the original cell length and atom position for later use
originalCell=coordinate1;
constK=9e-2;                                    % nN*A^2*C^-2
atomCharge=[-5.64/3 1.64 4];                    % atom charge 
atomPair1=[1 2 1 2];                            % atom pairs need to be calculated
atomPair2=[1 2 2 1];
%atomPair1=[1 2];                            % atom pairs need to be calculated
%atomPair2=[2 1];
coordinateNumber=[6 6 3 9];
% coordinateNumber=[9];
%atomPair1=[1 2 3 1 2 1 3 2 3];
%atomPair2=[1 2 3 2 1 3 1 3 2];
cutOff=8;                                       % cutoff radius
HistRes=0.05;                                   % resolution
DisDistribution=zeros(size(0:HistRes:cutOff,2),size(atomPair1,2)); % initialization of length distribution matrix
dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;   % calculate the number of mirror image
% create the supercell of mirror image
if(dimension>0)
    [ coordinate1,a1, b1, c1, atom1, atom2, atom3 ]=createSuperCell(filename,dimension,[]);
end
%Etot=0;
atom(1)=0;                                      % the last serial number of atom i-1
atom(2)=atom1;
atom(3)=atom2+atom(2);
atom(4)=atom3+atom(3);
csym=zeros(size(coordinate1,1),1);

%selectHi=[a1,b1,c1];
%selectLo=[0 0 0]; 
selectHi=[originalCellLength(1),originalCellLength(2),originalCellLength(3)]; % Define the region in mode4
selectLo=[0 0 0];

% Display the calculation information
disp('----------Conditions-----------')
disp('File name:')
disp(filename)
disp('CutOff(A):')
disp(cutOff)
disp('Interaction pairs:')
disp(atomPair1)
disp(atomPair2)
disp('Charge on atoms')
disp(atomCharge)
disp('Region:')
selectHi
selectLo
disp('-------------------------------')
disp('Calculating...')

bondRecord=zeros(size(0:HistRes:cutOff,2),100,2);% initialize the bond pair matrix
pointer=zeros(size(0:HistRes:cutOff,2),1);       % The pointer used to record the position of atom pairs in bondRecord
distanceX=0:HistRes:cutOff;                      % Different distances
atomE=zeros(size(csym));
% Main loop
for i=1:size(atomPair1,2)
    disp(i/size(atomPair1,2));                   % progress bar
    atomIndex1=atomPair1(i);                     % get the current atom index
    atomIndex2=atomPair2(i);
    pair1Serial=(atom(atomIndex1)+1):atom(atomIndex1+1); % get the serial number of atoms needed to be calculated
    pair2Serial=(atom(atomIndex2)+1):atom(atomIndex2+1);
    currentCooridinateNumber=coordinateNumber(i);
    neighbourList=zeros(size(pair1Serial,2),currentCooridinateNumber+1);  %j k1 k2 k3....kn
    pairNeighbourList=neighbourList;
    m=1;
    for j=pair1Serial
        atomDistance=zeros(size(pair2Serial,2),6);  %j k positions normDistance
        l=1;
        for k=pair2Serial
            vAtomDistance=coordinate1(j,:)-coordinate1(k,:);
            vAtomDistance=vAtomDistance-[a1 b1 c1].*fix((2*vAtomDistance.*[1/a1 1/b1 1/c1]));
            if(norm(vAtomDistance)~=0)
                atomDistance(l,:)=[j k vAtomDistance norm(vAtomDistance)];
                l=l+1;
            else
                atomDistance(end,:)=[];
            end
        end
        [~,sortIndex]=sort(atomDistance(:,6));
        neighbourList(m,:)=[j atomDistance(sortIndex(1:currentCooridinateNumber),2)'];
        m=m+1;
   end
   for n=1:size(neighbourList,1)
       currentNeighbour=neighbourList(n,:);
       pairNeighbourList(n,1)=currentNeighbour(1);
       p=2;
       switch(mode)
           case 1
                while(size(currentNeighbour,2)>1)
                   addDistanceVector=[coordinate1(currentNeighbour(2),:)'*ones(1,size(currentNeighbour,2)-1)+coordinate1(currentNeighbour(2:end),:)'-2*coordinate1(currentNeighbour(1),:)'*ones(1,size(currentNeighbour,2)-1)];
                   normDistanceVector=[addDistanceVector(1,:).^2+addDistanceVector(2,:).^2+addDistanceVector(3,:).^2].^0.5;
                   normDistanceVector(1)=999;
                   [minPair,minPairIndex]=min(normDistanceVector);
                   if(minPairIndex==1)
                       disp('Pair matching wrong!')
                   end
                   csym(neighbourList(n))=csym(neighbourList(n))+minPair;
                   pairNeighbourList(n,p)=currentNeighbour(2);
                   pairNeighbourList(n,p+1)=currentNeighbour(minPairIndex+1);
                   currentNeighbour(2)=[];
                   currentNeighbour(minPairIndex)=[];
                   p=p+2;
               
                end
           case 2
               vectorsSurrounding=coordinate1(currentNeighbour(2:end),:)'-coordinate1(currentNeighbour(1),:)'*ones(1,size(currentNeighbour,2)-1);
               currentE=0;
               for s=1:size(vectorsSurrounding,2)
                    vectorsSurrounding(:,s)=(vectorsSurrounding(:,s)'-[a1 b1 c1].*fix((2*vectorsSurrounding(:,s)'.*[1/a1 1/b1 1/c1])))';
                    currentE=currentE+constK*atomCharge(atomIndex1)*atomCharge(atomIndex2)./norm(vectorsSurrounding(:,s));
                    condition1=(coordinate1(currentNeighbour(1),1)<selectHi(1))&&(coordinate1(currentNeighbour(1),2)<selectHi(2))&&(coordinate1(currentNeighbour(1),3)<selectHi(3));
                    condition2=(coordinate1(currentNeighbour(1),1)>selectLo(1))&&(coordinate1(currentNeighbour(1),2)>selectLo(2))&&(coordinate1(currentNeighbour(1),3)>selectLo(3));
                    if(condition1&&condition2)
                        bondLength=norm(vectorsSurrounding(:,s));
                        DistributeIndex=round(bondLength/HistRes)+1;
                        DisDistribution(DistributeIndex,i)=DisDistribution(DistributeIndex,i)+0.5;
                        freePosition=pointer(DistributeIndex)+1;
                        bondRecord(DistributeIndex,freePosition,1)=currentNeighbour(1);
                        bondRecord(DistributeIndex,freePosition,2)=currentNeighbour(s+1);
                        pointer(DistributeIndex)=pointer(DistributeIndex)+1;
                    end
               end
               atomE(neighbourList(n))=atomE(neighbourList(n))+currentE;
               sumNeighbour=norm(sum(vectorsSurrounding,2));
               csym(neighbourList(n))=sumNeighbour;
               
           otherwise
                   disp('Mode wrong!')
       end
       %csym(neighbourList(n))=csym(neighbourList(n))/currentCooridinateNumber;
       if((debug~=0)&&(coordinate1(neighbourList(n),1)>30)&&(coordinate1(neighbourList(n),2)>0)&&(coordinate1(neighbourList(n),3)>0)&&(coordinate1(neighbourList(n),1)>0)&&(coordinate1(neighbourList(n),1)<35)&&(coordinate1(neighbourList(n),2)<9.4694)&&(coordinate1(neighbourList(n),3)<5.8144))
           neighbourList(n)
           coordinate1(neighbourList(n),:)
           csym(neighbourList(n))
       end       
   end
   %sum(atomE)
 
 
end
%%

n=0;
conCellPosition=zeros(size(coordinate1,1)/((2*dimension+1)^3),size(coordinate1,2));
concsym=zeros(size(conCellPosition,1),1);
conE=zeros(size(conCellPosition,1),1);
pickAtoms=concsym;
a1=a1/((2*dimension+1));
b1=b1/((2*dimension+1));
c1=c1/((2*dimension+1));
atom1=atom1/((2*dimension+1)^3);
atom2=atom2/((2*dimension+1)^3);
atom3=atom3/((2*dimension+1)^3);
% Pick the atoms in the orginal slab

for i=1:size(coordinate1,1)
    if(coordinate1(i,1)>=0&&coordinate1(i,1)<a1&&coordinate1(i,2)>0&&coordinate1(i,2)<b1&&coordinate1(i,3)>0&&coordinate1(i,3)<c1)
        n=n+1;
        conCellPosition(n,:)=coordinate1(i,:);
        concsym(n,:)=csym(i,:);
        conE(n)=atomE(i);
        pickAtoms(n)=i;
    end
end 

% add distributation with same pairs
NumOfPair=size(atomPair1,2);
NumOfSamePair=sum((atomPair1-atomPair2)==0);
NumOfDifferentPair=(NumOfPair-NumOfSamePair)/2;
DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))=DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))+DisDistribution(:,(NumOfSamePair+NumOfDifferentPair+1):end);

% save the original positions
oriCoordinate=coordinate1;
%% Plot


coordinate1=conCellPosition;
cutOffCO3=1.5;
ONumber=atom1;
CaNumber=atom2;
CNumber=atom3;
OSerial=1:ONumber;
CaSerial=ONumber+1:ONumber+CaNumber;
CSerial=ONumber+CaNumber+1:ONumber+CaNumber+CNumber;
CO3Coordinate1=CorrelateCO3(coordinate1,ONumber,CaNumber,CNumber,a1,b1,c1,cutOffCO3);  %Correlate the C and O atoms in CO3
coordinate1=adjustBoundary(coordinate1,CO3Coordinate1,a1,b1,c1);
%
if(plotNumber~=0)
    subplot(5,1,plotNumber)
end

if(plotStructure==1)
    if(plotDistribution==1)
        subplot(2,1,1)
    end
    hold on
    grid on
    axis equal
    axis([0 a1 0 b1 0 c1]);
    ArrowWidth=2;
    C2=colorbar;
    %caxis([0.2 1.5]);
    box on

    %CO bond
    linewidth=3;
    linecolor=[0.5 0.5 0.5];


    for i=1:size(coordinate1,1)
        if(CO3Coordinate1(i,1)~=0)
            CIndex=i;
            O1Index=CO3Coordinate1(i,1);
            O2Index=CO3Coordinate1(i,2);
            O3Index=CO3Coordinate1(i,3);

            if(coordinate1(CIndex,3)>2.5)
                linestyle='-';
            else
                linestyle='--';
            end        
            H=line([coordinate1(CIndex,1) coordinate1(O1Index,1)],[coordinate1(CIndex,2) coordinate1(O1Index,2)],[coordinate1(CIndex,3) coordinate1(O1Index,3)]);
            set(H,'Color',linecolor,'LineWidth',linewidth,'LineStyle',linestyle);

            H=line([coordinate1(CIndex,1) coordinate1(O2Index,1)],[coordinate1(CIndex,2) coordinate1(O2Index,2)],[coordinate1(CIndex,3) coordinate1(O2Index,3)]);
            set(H,'Color',linecolor,'LineWidth',linewidth,'LineStyle',linestyle);

            H=line([coordinate1(CIndex,1) coordinate1(O3Index,1)],[coordinate1(CIndex,2) coordinate1(O3Index,2)],[coordinate1(CIndex,3) coordinate1(O3Index,3)]);
            set(H,'Color',linecolor,'LineWidth',linewidth,'LineStyle',linestyle);

        end
    end
    %set(H,'Color','k');


    %scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),100*ones(size(OSerial,1),1),angleDifference(OSerial,1,3),'filled','MarkerEdgeColor','k')
    if(concsym(OSerial(1))~=0)
        h1=scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),100*ones(size(OSerial,1),1),concsym(OSerial),'filled','MarkerEdgeColor','k');
    else
        h1=scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),'filled','o');
        set(h1,'MarkerFaceColor','r');
    end

    if(concsym(CSerial(1))~=0)
        h2=scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),100*ones(size(CSerial,1),1),concsym(CSerial),'filled','MarkerEdgeColor','k');
    else
        h2=scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),'filled','o');
        set(h2,'MarkerFaceColor','k');
    end

    if(concsym(CaSerial(1))~=0)
        h3=scatter3(coordinate1(CaSerial,1),coordinate1(CaSerial,2),coordinate1(CaSerial,3),100*ones(size(CaSerial,1),1),concsym(CaSerial),'filled','MarkerEdgeColor','k');
    else
        h3=scatter3(coordinate1(CaSerial,1),coordinate1(CaSerial,2),coordinate1(CaSerial,3),'filled','o');
        set(h3,'MarkerFaceColor','g');
    end

    for i=1:size(coordinate1,1)
        if(concsym(i)~=0)
            text(coordinate1(i,1)+0.2,coordinate1(i,2),coordinate1(i,3),num2str(concsym(i)));
        end
    end


    xlabel('a');
    ylabel('b');
    zlabel('c');
end

if(plotDistribution==1)
    if(plotStructure==1)
        subplot(2,1,2)
    end
    hold on
    %cutOff=5;
    if(sum(DisDistribution(:,1)==0)<size(DisDistribution,1))
        plot([0:HistRes:cutOff],DisDistribution(:,1),'r')
    end
    if(sum(DisDistribution(:,2)==0)<size(DisDistribution,1))
        plot([0:HistRes:cutOff],DisDistribution(:,2),'g')
    end
    if(sum(DisDistribution(:,3)==0)<size(DisDistribution,1))
        plot([0:HistRes:cutOff],DisDistribution(:,3),'b')
    end
    legend('O-O','Ca-Ca','Ca-O')
    axis([0 6 0 70])
    title(filename);
    

end
disp('E=')
disp(sum(conE))
coordinate1=oriCoordinate;