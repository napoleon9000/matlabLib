clear
filename='PerfectSlabRelaxed.vasp';
%filename='PerfectRelaxedTS.vasp';
%filename='NEB_TS.vasp';
%filename='PerfectSlabRelaxedSlipSF.vasp';
%filename='StackingFaultRelaxed.vasp';
%filename='test2.vasp';

% load the structure
%[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR('NEB_TS.vasp');
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename);
originalCellLength=[a1 b1 c1];                  % save the original cell length and atom position for later use
originalCell=coordinate1;
mode=4;        %1:net force   2:absolute force interaction   3: norm(net force)  4:bond length distribution   5: bond crossing the slip plane 6. Assign E on atoms
slipPlane=3;
slipPlane=19;
HistRes=0.05;                                   % resolution in mode4
constK=9e-2;                                    % nN*A^2*C^-2
%constK=1;
atomCharge=[-5.64/3 1.64 4];                    % atom charge
%atomCharge=[1 1 1];  
atomPair1=[1 2 1 2];                            % atom pairs need to be calculated
atomPair2=[1 2 2 1];
%atomPair1=[1 2 3 1 1 2 2 3 3];
%atomPair2=[1 2 3 2 3 3 1 1 2]; 
%atomPair1=[1 2];
%atomPair2=[2 1];
bondsRatio=[    0.3452
    0.0447
    0.0377
    0.2553
    0.2321
    0.0851];
cutOff=6;                                       % cutoff radius
DisDistribution=zeros(size(0:HistRes:cutOff,2),size(atomPair1,2)); % initialization of length distribution matrix
dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;   % calculate the number of mirror image

% create the supercell of mirror image
if(dimension>0)
    [ coordinate1,a1, b1, c1, atom1, atom2, atom3 ]=createSuperCell(filename,dimension);
end
%Etot=0;
atom(1)=0;                                      % the last serial number of atom i-1
atom(2)=atom1;
atom(3)=atom2+atom(2);
atom(4)=atom3+atom(3);


%selectHi=[a1,b1,c1];
%selectLo=[0 0 0];
selectHi=[24.1,originalCellLength(2),originalCellLength(3)]; % Define the region in mode4
selectLo=[14.2 0 0];
selectHi=[originalCellLength(1),originalCellLength(2),originalCellLength(3)]; % Define the region in mode4
selectLo=[0 0 0];
force=zeros(size(coordinate1));                 % initialize the force matrix
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
if(mode==4)
    disp('Region:')
    selectHi
    selectLo
    disp('Histogram resolution')
    disp(HistRes)
end
disp('-------------------------------')
disp('Calculating...')
count=0;
bondRecord=zeros(size(0:HistRes:cutOff,1),100,2);% initialize the bond pair matrix
pointer=zeros(size(0:HistRes:cutOff,2),1);       % The pointer used to record the position of atom pairs in bondRecord
distanceX=0:HistRes:cutOff;                      % Different distances
atomE=zeros(size(coordinate1,1),1);  
% Main loop
for i=1:size(atomPair1,2)                        % atom pairs
    disp(i/size(atomPair1,2));                   % progress bar
    atomIndex1=atomPair1(i);                     % get the current atom index
    atomIndex2=atomPair2(i);
    pair1Serial=atom(atomIndex1)+1:atom(atomIndex1+1); % get the serial number of atoms needed to be calculated
    pair2Serial=atom(atomIndex2)+1:atom(atomIndex2+1);
    for j=pair1Serial
%         if(mod(j,200)==0)
%             disp(j/size(pair1Serial,2)); 
%         end
        for k=pair2Serial
            if(j~=k)
                distanceVector=coordinate1(k,:)-coordinate1(j,:);
                %distanceVector=distanceVector-[a1 b1 c1].*floor(abs(2*distanceVector.*[1/a1 1/b1 1/c1])).*distanceVector./abs(distanceVector);
                if(norm(distanceVector)<=cutOff)
                    f1=-constK*atomCharge(atomIndex1)*atomCharge(atomIndex2)/(norm(distanceVector).^3)*distanceVector;
                    f2=-f1;
                    
%                     k
                    f1n=norm(f1);
%                     if(abs(coordinate1(j,:)-[18.3 6.811 2.089])<0.1)
%                         j;
%                         k;
%                         norm(distanceVector)
%                         atomCharge(atomIndex1);
%                         atomCharge(atomIndex2);
%                         f1
%                         f1n
%                     end
%                     atomCharge(atomIndex1)
%                     atomCharge(atomIndex2)
%                     norm(distanceVector)

                    % Consider C-O in CO3
                    if(((atomPair1(i)==3&&atomPair2(i)==1)||(atomPair1(i)==1&&atomPair2(i)==3))&&norm(distanceVector)<1.4)
                        f1=0;
                        f2=0;
                        f1n=0;
                    end
                    interOO=0;
                    if(((atomPair1(i)==1&&atomPair2(i)==1))&&norm(coordinate1(k,1:2)-coordinate1(j,1:2))<2.26&&abs(coordinate1(k,3)-coordinate1(j,3))<1)
                        f1=0;
                        f2=0;
                        f1n=0;
                        interOO=0;    %% O-O in CO3 is ignored   0:intra molecular 1:in molecule
                    end                        
                    switch mode
                        case 1
                            force(j,:)=force(j,:)+0.5*f1; 
                            force(k,:)=force(k,:)+0.5*f2;
                        case 2
                            force(j,:)=force(j,:)+0.5*[f1n 0 0]; 
                            force(k,:)=force(k,:)+0.5*[f1n 0 0];
                            %force(j,:)=force(j,:)+0.5*abs(f1); 
                            %force(k,:)=force(k,:)+0.5*abs(f2);
                        case 3
                            force(j,:)=force(j,:)+0.5*f1; 
                            force(k,:)=force(k,:)+0.5*f2;  
                        case 4
                            condition1=(coordinate1(j,1)<selectHi(1))&&(coordinate1(j,2)<selectHi(2))&&(coordinate1(j,3)<selectHi(3));
                            condition2=(coordinate1(j,1)>selectLo(1))&&(coordinate1(j,2)>selectLo(2))&&(coordinate1(j,3)>selectLo(3));
                            condition3=(coordinate1(k,1)<selectHi(1))&&(coordinate1(k,2)<selectHi(2))&&(coordinate1(k,3)<selectHi(3));
                            condition4=(coordinate1(k,1)>selectLo(1))&&(coordinate1(k,2)>selectLo(2))&&(coordinate1(k,3)>selectLo(3));
                            if(((condition1&&condition2)||(condition3&&condition4))&&interOO==0) %% O-O in CO3 is ignored
                                bondLength=norm(distanceVector);
                                DistributeIndex=round(bondLength/HistRes)+1;
                                DisDistribution(DistributeIndex,i)=DisDistribution(DistributeIndex,i)+0.5;
                                freePosition=pointer(DistributeIndex)+1;
                                bondRecord(DistributeIndex,freePosition,1)=j;
                                bondRecord(DistributeIndex,freePosition,2)=k;
                                pointer(DistributeIndex)=pointer(DistributeIndex)+1;
                            end
                        case 5
                            condition1=(coordinate1(j,1)<selectHi(1))&&(coordinate1(j,2)<selectHi(2))&&(coordinate1(j,3)<selectHi(3));
                            condition2=(coordinate1(j,1)>selectLo(1))&&(coordinate1(j,2)>selectLo(2))&&(coordinate1(j,3)>selectLo(3));
                            condition3=(coordinate1(k,1)<selectHi(1))&&(coordinate1(k,2)<selectHi(2))&&(coordinate1(k,3)<selectHi(3));
                            condition4=(coordinate1(k,1)>selectLo(1))&&(coordinate1(k,2)>selectLo(2))&&(coordinate1(k,3)>selectLo(3));
                            condition5=((coordinate1(k,1)>slipPlane)&&(coordinate1(j,1)<slipPlane))||((coordinate1(j,1)>slipPlane)&&(coordinate1(k,1)<slipPlane));
                            if(((condition1&&condition2)||(condition3&&condition4))&&interOO==0&&condition5) %% O-O in CO3 is ignored
%                                 j
%                                 k 
%                                 if(j==14&&k==41)                                    
%                                 coordinate1(j,:)
%                                 coordinate1(k,:)
%                                 bondLength=norm(distanceVector)
%                                 end
                                bondLength=norm(distanceVector);
                                DistributeIndex=round(bondLength/HistRes)+1;
                                DisDistribution(DistributeIndex,i)=DisDistribution(DistributeIndex,i)+0.5;
                                freePosition=pointer(DistributeIndex)+1;
                                bondRecord(DistributeIndex,freePosition,1)=j;
                                bondRecord(DistributeIndex,freePosition,2)=k;
                                pointer(DistributeIndex)=pointer(DistributeIndex)+1;
                            end
                        case 6
                            Ek=0.25*constK*atomCharge(atomIndex1)*atomCharge(atomIndex2)/(norm(distanceVector));
                            Ej=Ek;
                            atomE(j)=atomE(j)+Ej;
                            atomE(k)=atomE(k)+Ek;
%                             if(k==14||j==14)
%                                 count=count+1
%                                 norm(distanceVector)
%                                 atomE(14)
%                             end
                        otherwise
                            disp('Wrong mode');
                    end
                end
            end
        end
    end    
end
%%


n=0;
conCellPosition=zeros(size(coordinate1,1)/((2*dimension+1)^3),size(coordinate1,2));
conE=zeros(size(conCellPosition,1),1);
conForce=conCellPosition;
a1=a1/((2*dimension+1));
b1=b1/((2*dimension+1));
c1=c1/((2*dimension+1));
atom1=atom1/((2*dimension+1)^3);
atom2=atom2/((2*dimension+1)^3);
atom3=atom3/((2*dimension+1)^3);

%% Pick the atoms in the orginal slab
for i=1:size(coordinate1,1)
    if(coordinate1(i,1)>=0&&coordinate1(i,1)<a1&&coordinate1(i,2)>0&&coordinate1(i,2)<b1&&coordinate1(i,3)>0&&coordinate1(i,3)<c1)
        n=n+1;
        conCellPosition(n,:)=coordinate1(i,:);
        conForce(n,:)=force(i,:);
        conE(n)=atomE(i);
    end
end 

if(mode==3)
    for i=1:size(force,1)
        force(i,1)=norm(force(i,:));
    end
end

%conForce(:,1)=zeros(120,1);
%conForce(:,2)=zeros(120,1);
%% Plot 


scale1=.4;
scale2=.4;
scale3=.1;
scalebar=.05;

if(mode==1||mode==2||mode==3)
    plotQuiver3(conCellPosition,conForce,atom1,atom2,atom3,a1,b1,c1,scalebar,scale1,scale2,scale3);
    axis([0 originalCellLength(1) 0 originalCellLength(2) 0 originalCellLength(3)]);
end
hold on
if(mode==4)
    NumOfPair=size(atomPair1,2);
    NumOfSamePair=sum((atomPair1-atomPair2)==0);
    NumOfDifferentPair=(NumOfPair-NumOfSamePair)/2;
    DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))=DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))+DisDistribution(:,(NumOfSamePair+NumOfDifferentPair+1):end);
    plot([0:HistRes:cutOff],DisDistribution(:,1),'r')
    plot([0:HistRes:cutOff],DisDistribution(:,2),'k')
    plot([0:HistRes:cutOff],DisDistribution(:,3))
    legend('O-O','Ca-Ca','Ca-O')
    qForce=[];
    qForce(1,:)=atomCharge(atomPair1(1))*atomCharge(atomPair2(1))./([0:HistRes:cutOff].^2);
    qForce(2,:)=atomCharge(atomPair1(2))*atomCharge(atomPair2(2))./([0:HistRes:cutOff].^2);
    qForce(3,:)=atomCharge(atomPair1(3))*atomCharge(atomPair2(3))./([0:HistRes:cutOff].^2);
    FOO=sum(qForce(1,2:end).*DisDistribution(2:end,1)')
    FCaCa=sum(qForce(2,2:end).*DisDistribution(2:end,2)')
    FOCa=sum(qForce(3,2:end).*DisDistribution(2:end,3)')
    qE=[];
    qE(1,:)=atomCharge(atomPair1(1))*atomCharge(atomPair2(1))./([0:HistRes:cutOff]);
    qE(2,:)=atomCharge(atomPair1(2))*atomCharge(atomPair2(2))./([0:HistRes:cutOff]); 
    qE(3,:)=atomCharge(atomPair1(3))*atomCharge(atomPair2(3))./([0:HistRes:cutOff]);
    EOO=sum(qE(1,2:end).*DisDistribution(2:end,1)');
    ECaCa=sum(qE(2,2:end).*DisDistribution(2:end,2)');
    EOCa=sum(qE(3,2:end).*DisDistribution(2:end,3)');
    nOO=sum(DisDistribution(2:end,1));
    nCaCa=sum(DisDistribution(2:end,2));
    nOCa=sum(DisDistribution(2:end,3));
    aEOO=EOO/nOO;
    aECaCa=ECaCa/nCaCa;
    aEOCa=EOCa/nOCa;
    disp('E')
    disp([EOO ECaCa EOCa])
    disp('n')
    disp([nOO nCaCa nOCa])
    disp('aE')
    disp([aEOO aECaCa aEOCa])
    
end
%%
if(mode==5)
    NumOfPair=size(atomPair1,2);
    NumOfSamePair=sum((atomPair1-atomPair2)==0);
    NumOfDifferentPair=(NumOfPair-NumOfSamePair)/2;
    DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))=DisDistribution(:,(NumOfSamePair+1):(NumOfSamePair+NumOfDifferentPair))+DisDistribution(:,(NumOfSamePair+NumOfDifferentPair+1):end);
    plot([0:HistRes:cutOff],DisDistribution(:,1),'r')
    plot([0:HistRes:cutOff],DisDistribution(:,2),'ko')
    plot([0:HistRes:cutOff],DisDistribution(:,3))
    legend('O-O','Ca-Ca','Ca-O')
    qForce=[];
    qForce(1,:)=atomCharge(atomPair1(1))*atomCharge(atomPair2(1))./([0:HistRes:cutOff].^2);
    qForce(2,:)=atomCharge(atomPair1(2))*atomCharge(atomPair2(2))./([0:HistRes:cutOff].^2);
    qForce(3,:)=atomCharge(atomPair1(3))*atomCharge(atomPair2(3))./([0:HistRes:cutOff].^2);
    FOO=sum(qForce(1,2:end).*DisDistribution(2:end,1)')
    FCaCa=sum(qForce(2,2:end).*DisDistribution(2:end,2)')
    FOCa=sum(qForce(3,2:end).*DisDistribution(2:end,3)')
    qE=[];
    qE(1,:)=atomCharge(atomPair1(1))*atomCharge(atomPair2(1))./([0:HistRes:cutOff]);
    qE(2,:)=atomCharge(atomPair1(2))*atomCharge(atomPair2(2))./([0:HistRes:cutOff]); 
    qE(3,:)=atomCharge(atomPair1(3))*atomCharge(atomPair2(3))./([0:HistRes:cutOff]);
    EOO=sum(qE(1,2:end).*DisDistribution(2:end,1)');
    ECaCa=sum(qE(2,2:end).*DisDistribution(2:end,2)');
    EOCa=sum(qE(3,2:end).*DisDistribution(2:end,3)');
    nOO=sum(DisDistribution(2:end,1));
    nCaCa=sum(DisDistribution(2:end,2));
    nOCa=sum(DisDistribution(2:end,3));
    aEOO=EOO/nOO;
    aECaCa=ECaCa/nCaCa;
    aEOCa=EOCa/nOCa;
    disp('E')
    disp([EOO ECaCa EOCa])
    disp('n')
    disp([nOO nCaCa nOCa])
    disp('aE')
    disp([aEOO aECaCa aEOCa])
    axis([0 cutOff 0 40])
    E=zeros(1,NumOfSamePair+NumOfDifferentPair);
    aE=E;
    for i=1:NumOfSamePair+NumOfDifferentPair
        qE=atomCharge(atomPair1(i))*atomCharge(atomPair2(i))./([0:HistRes:cutOff]);
        E(i)=sum(qE(1,2:end).*DisDistribution(2:end,i)');
        aE(i)=E(i)/sum(DisDistribution(2:end,i));
    end
    E
    aE
    sum(E.*bondsRatio')
    sum(aE.*bondsRatio')
end

if(mode==6)
    title(filename);
    hold on
    grid on
    axis equal
    axis([0 a1 0 b1 0 c1]);
    Etot=sum(conE)
    
    %CO bond
    linewidth=3;
    linecolor=[0.5 0.5 0.5];
    
    expendedCell=coordinate1;
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
    
    
    h1=scatter3(conCellPosition(:,1),conCellPosition(:,2),conCellPosition(:,3),100*ones(size(conCellPosition,1),1),conE(:),'filled','MarkerEdgeColor','k');
    C2=colorbar;
    for i=1:size(conCellPosition,1)
        if(conE(i)~=0)
            text(conCellPosition(i,1)+0.2,conCellPosition(i,2),conCellPosition(i,3),num2str(conE(i)));
        end
    end
end

disp('Finished')