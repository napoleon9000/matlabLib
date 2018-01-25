clear
load('Distribution1.mat');
load('bondRecord1.mat');
bondRecord1=bondRecord;
load('Distribution4.mat');
load('bondRecord4.mat');
bondRecord2=bondRecord;
filename1='PerfectSlabRelaxed.vasp';
filename2='PerfectSlabRelaxedSlipSF.vasp';
addE1=0;
leftE1=0;
transferE1=0;
addE2=0;
leftE2=0;
transferE2=0;
calE=1;   % 1:Distribution 2: Count at Plot (Bugs not fixed)

for index=1:size(bondRecord1,1)
    %index=56;
load('Distribution1.mat');     %%% Change
load('bondRecord1.mat');     %%% Change
bondRecord1=bondRecord;
load('Distribution2.mat');     %%% Change
load('bondRecord2.mat');     %%% Change
bondRecord2=bondRecord;
filename1='PerfectSlabRelaxed.vasp';     %%% Change
filename2='PerfectRelaxedTS.vasp';     %%% Change
D1=Distribution1;           %%% Change
D2=Distribution2;           %%% Change
Distribution1=D1;
Distribution2=D2;

%filename='PerfectSlabRelaxed.vasp';
%filename='PerfectRelaxedTS.vasp';
%%%%filename='TS_Rigid.vasp';
%filename='NEB_TS.vasp';
%filename='PerfectSlabRelaxedSlipSF.vasp';
%filename='StackingFaultRelaxed.vasp';
retrive=1;
pauseFlag=0;
inverseMatchTransfer=0;
selectFlag=0;

if(bondRecord1(index,1,1)==0)
    continue    % Jump to the next length
end
%length=2.6;
%index=0;
cutOff=8; 
HistRes=0.05;
constK=9e-2;                                    % nN*A^2*C^-2
atomCharge=[-5.64/3 1.64 4];                    % atom charge 
atomPair1=[1 2 1 2];                            % atom pairs need to be calculated
atomPair2=[1 2 2 1];
distanceX=0:HistRes:cutOff;
pEX=((atomCharge(atomPair1).*atomCharge(atomPair2))'*(constK./distanceX))';
% Calculate total energy of the two structure
E1=Distribution1.*pEX;
E1tot=sum(sum(E1(2:end,1:3)));
E2=Distribution2.*pEX;
E2tot=sum(sum(E2(2:end,1:3)));
%%
if(index==0)
    index=find(abs(distanceX-length)<1e-6);
end

% Reading file 1
[ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename1);
originalCell=coordinate1;
originalCell1=originalCell;

if(retrive==1)
    atomChargeMatrix=[atomCharge(1)*ones(1,atom1) atomCharge(2)*ones(1,atom2) atomCharge(3)*ones(1,atom3)];
    atomIndexMatrix=[1*ones(1,atom1) 2*ones(1,atom2) 3*ones(1,atom3)];
elseif(retrive==0)
    atomChargeMatrix=[atomCharge(1)*ones(1,atom1*27) atomCharge(2)*ones(1,atom2*27) atomCharge(3)*ones(1,atom3*27)];
    atomIndexMatrix=[1*ones(1,atom1*27) 2*ones(1,atom2*27) 3*ones(1,atom3*27)];
end

dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;
if(dimension>0)
    [ coordinate1,~, ~, ~, ~, ~, ~ ]=createSuperCell(filename1,dimension,[]);
end

% coordianteExpand=coordinate1;

% for i=1:size(coordinate1,1)
%     coordinate1(i,:)=coordinate1(i,:)-[a1 b1 c1].*floor((coordinate1(i,:).*[1/a1 1/b1 1/c1]));
% end   
    
    
% retriveAtoms1=zeros(size(coordinate1,1),1);
% for i=1:size(originalCell,1)
%     list1=find(abs(coordinate1(:,1)-originalCell(i,1))<1e-3);
%     list2=list1(find(abs(coordinate1(list1,2)-originalCell(i,2))<1e-3));
%     list3=list2(find(abs(coordinate1(list2,3)-originalCell(i,3))<1e-3));
%     retriveAtoms1(list3)=i;
% end

% coordinate1=coordianteExpand;
%%

% Reading file 2
[ coordinate2,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename2);
originalCell=coordinate2;
originalCell2=originalCell;

dimension=ceil(cutOff/min([a1 b1 c1])+0.5)-1;
if(dimension>0)
    [ coordinate2,~, ~, ~, ~, ~, ~ ]=createSuperCell(filename2,dimension,[]);
end



% retriveAtoms2=zeros(size(coordinate2,1),1);
% for i=1:size(originalCell,1)
%     list1=find(abs(coordinate2(:,1)-originalCell(i,1))<1e-3);
%     list2=list1(find(abs(coordinate2(list1,2)-originalCell(i,2))<1e-3));
%     list3=list2(find(abs(coordinate2(list2,3)-originalCell(i,3))<1e-3));
%     retriveAtoms2(list3)=i;
% end


DiffDistributation=Distribution2-Distribution1;   

%% construct retrive matrix
[ allRetrive,~, ~, ~, ~, ~, ~ ]=createSuperCell(filename2,dimension,[1:120]'*[1 1 1]);
allRetrive(:,2:3)=[];
% This matrix can also be loaded
% load('allRetrive.mat')

if(retrive==1)
    %Retrive the original atom number
    for i=1:size(bondRecord1,1)
        for j=1:size(bondRecord1,2)
            for k=1:size(bondRecord1,3)
                if(bondRecord1(i,j,k)~=0)
                    bondRecord1(i,j,k)=allRetrive(bondRecord1(i,j,k));
                end
            end
        end
    end

    for i=1:size(bondRecord2,1)
        for j=1:size(bondRecord2,2)
            for k=1:size(bondRecord2,3)
                if(bondRecord2(i,j,k)~=0)
                    bondRecord2(i,j,k)=allRetrive(bondRecord2(i,j,k));
                end
            end
        end
    end
    
end

addBond=zeros(size(bondRecord1));
leftBond=addBond;
transferBondLeft=addBond;         % Bonds that left from [leftBond]. The number in the matrix is index in [addBond]
transferBondAdd=addBond;
for i=1:size(DiffDistributation,1)
    if(DiffDistributation(i,1)~=0||DiffDistributation(i,2)~=0||DiffDistributation(i,3)~=0)      
        % get pairs to compare and delete 0 in the matrix
        currentPair1=[];
        currentPair2=[];
        currentPair1(:,1)=bondRecord1(i,:,1)';
        currentPair1(:,2)=bondRecord1(i,:,2)';
        currentPair1(currentPair1(:,1)==0,:)=[];
        currentPair2(:,1)=bondRecord2(i,:,1)';
        currentPair2(:,2)=bondRecord2(i,:,2)';
        currentPair2(currentPair2(:,1)==0,:)=[];
        n=1;
        while(n<=size(currentPair1,1))
            m=1;
            while(m<=size(currentPair2,1))
                if((currentPair1(n,1)==currentPair2(m,1)&&currentPair1(n,2)==currentPair2(m,2))||...
                   (currentPair1(n,1)==currentPair2(m,2)&&currentPair1(n,2)==currentPair2(m,1)))
                    currentPair1(n,:)=[];
                    currentPair2(m,:)=[];
                    m=m-1;
                    n=n-1;
                    break
                end
                m=m+1;
            end
            n=n+1;
        end
    leftBond(i,1:size(currentPair1,1),1)=currentPair1(:,1)';
    leftBond(i,1:size(currentPair1,1),2)=currentPair1(:,2)';
    addBond(i,1:size(currentPair2,1),1)=currentPair2(:,1)';
    addBond(i,1:size(currentPair2,1),2)=currentPair2(:,2)';    
    end
end

%%

% Find transfer bonds
for i=1:size(leftBond,1)
    for j=1:size(leftBond,2)
        if(leftBond(i,j,1)~=0)
            if(i==61)
                %disp('i=61')
                %pause
            end
            [list1R,list1C]=find(addBond(:,:,1)==leftBond(i,j,1));
            [list2R,list2C]=find(diag(addBond(list1R,list1C,2))==leftBond(i,j,2));
            Result=[list1R(list2R) list1C(list2R)];
%             if(size(Result,1)>1)
%                     disp('R>1')
%                     pause
%             end
            if(~isempty(Result))
                for k=1:size(Result,1)
                    transferBondLeft(i,j,:)=Result(1,:);
                    transferBondAdd(Result(k,1),Result(k,2),:)=[i j];
                end
            end
        end
    end
end
if(inverseMatchTransfer==1)
    for i=1:size(leftBond,1)
        for j=1:size(leftBond,2)
            if(leftBond(i,j,1)~=0)
    %             if(i==61)
    %                 %disp('i=61')
    %                 %pause
    %             end
                [list1R,list1C]=find(addBond(:,:,1)==leftBond(i,j,2));
                [list2R,list2C]=find(diag(addBond(list1R,list1C,2))==leftBond(i,j,1));
                Result=[list1R(list2R) list1C(list2R)];
                if(size(Result,1)>1)
                    disp('R>1')
                    pause
                end

                if(~isempty(Result))
    %                 if(Result(1,:)==[61 5])
    %                     disp('Found result');
    %                     %pause
    %                 end
                    transferBondLeft(i,j,:)=Result(1,:);
                    transferBondAdd(Result(1),Result(2),:)=[i j];
                end
            end
        end
    end
end
%%
if(retrive==1)
coordinate1=originalCell1;
coordinate2=originalCell2;
end


%%
%index=76;

%%plot
subplot(2,1,1)
%pause
hold on
grid on
box on
axis equal
axis([0 a1 0 b1 0 c1]);
start=[0 0 0];
finish=start;

for i=1:size(leftBond,2)

    if(leftBond(index,i,1)==0)
        continue
    end
    selectCondition=atomIndexMatrix(leftBond(index,i,1))==2&&atomIndexMatrix(leftBond(index,i,2))==2;
    if(~selectCondition&&selectFlag)
        continue
    end
    start=coordinate1(leftBond(index,i,1),:);
    finish=coordinate1(leftBond(index,i,2),:);
    arrow=finish-start;
    arrow=arrow-[a1 b1 c1].*fix((2*arrow.*[1/a1 1/b1 1/c1]));
    
    %pause
    %quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'r');
    if(transferBondLeft(index,i,1)==0)
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'r');
        if(pauseFlag==2)
        pause
        end
        if(calE==2)
        leftE1=leftE1+constK*atomChargeMatrix(leftBond(index,i,1))*atomChargeMatrix(leftBond(index,i,2))./norm(arrow);
        end
    else
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'k');
        if(calE==2)
        transferE1=transferE1+constK*atomChargeMatrix(leftBond(index,i,1))*atomChargeMatrix(leftBond(index,i,2))./norm(arrow);
        end
    end
    if(pauseFlag==1)
        pause
    end
end
for i=1:size(addBond,2)

    if(addBond(index,i,1)==0)
        continue
    end
    selectCondition=atomIndexMatrix(addBond(index,i,1))==2&&atomIndexMatrix(addBond(index,i,2))==2;
    if(~selectCondition&&selectFlag)
        continue
    end
    start=coordinate1(addBond(index,i,1),:);
    finish=coordinate1(addBond(index,i,2),:);
    arrow=finish-start;
    arrow=arrow-[a1 b1 c1].*fix((2*arrow.*[1/a1 1/b1 1/c1]));
    %quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'b');    
    if(transferBondAdd(index,i,1)==0)
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'b');
        if(pauseFlag==2)
            pause
        end
        if(calE==2)
        addE1=addE1+constK*atomChargeMatrix(addBond(index,i,1))*atomChargeMatrix(addBond(index,i,2))./norm(arrow);
        end
    else
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'k');
        if(calE==2)
        transferE1=transferE1+constK*atomChargeMatrix(addBond(index,i,1))*atomChargeMatrix(addBond(index,i,2))./norm(arrow);
        end
    end
    if(pauseFlag==1)
        pause
    end
end
title('Structure 1 connected bond:blue  broken bond:red');
plot3(originalCell1(1:atom1,1),originalCell1(1:atom1,2),originalCell1(1:atom1,3),'r*');
plot3(originalCell1(atom1+1:atom1+atom2,1),originalCell1(atom1+1:atom1+atom2,2),originalCell1(atom1+1:atom1+atom2,3),'g*');
plot3(originalCell1(atom2+atom1+1:atom2+atom1+atom3,1),originalCell1(atom2+atom1+1:atom2+atom1+atom3,2),originalCell1(atom2+atom1+1:atom2+atom1+atom3,3),'k*');



subplot(2,1,2)
hold on
grid on
box on
axis equal
axis([0 a1 0 b1 0 c1]);
start=[0 0 0];
finish=start;

for i=1:size(leftBond,2)
    
    if(leftBond(index,i,1)==0)
        continue
    end
    selectCondition=atomIndexMatrix(leftBond(index,i,1))==2&&atomIndexMatrix(leftBond(index,i,2))==2;
    if(~selectCondition&&selectFlag)
        continue
    end
    start=coordinate2(leftBond(index,i,1),:);
    finish=coordinate2(leftBond(index,i,2),:);
    arrow=finish-start;
    arrow=arrow-[a1 b1 c1].*fix((2*arrow.*[1/a1 1/b1 1/c1]));
    %quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'r');
    if(transferBondLeft(index,i,1)==0)
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'r');
        if(calE==2)
        leftE2=leftE2+constK*atomChargeMatrix(leftBond(index,i,1))*atomChargeMatrix(leftBond(index,i,2))./norm(arrow);
        end
        if(pauseFlag==2)
            pause
        end        
    else
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'k');
        if(calE==2)
        transferE2=transferE2+constK*atomChargeMatrix(leftBond(index,i,1))*atomChargeMatrix(leftBond(index,i,2))./norm(arrow);
        end
    end
    if(pauseFlag==1)
        pause
    end
end
for i=1:size(addBond,2)
    
    if(addBond(index,i,1)==0)
        continue
    end
    selectCondition=atomIndexMatrix(addBond(index,i,1))==2&&atomIndexMatrix(addBond(index,i,2))==2;
    if(~selectCondition&&selectFlag)
        continue
    end
    start=coordinate2(addBond(index,i,1),:);
    finish=coordinate2(addBond(index,i,2),:);
    arrow=finish-start;
    arrow=arrow-[a1 b1 c1].*fix((2*arrow.*[1/a1 1/b1 1/c1]));
    %quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'b');
    if(transferBondAdd(index,i,1)==0)
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'b');
        addE2=addE2+constK*atomChargeMatrix(addBond(index,i,1))*atomChargeMatrix(addBond(index,i,2))./norm(arrow);
        if(pauseFlag==2)
            pause
        end
    else
        quiver3(start(1),start(2),start(3),arrow(1),arrow(2),arrow(3),0,'k');
        transferE2=transferE2+constK*atomChargeMatrix(addBond(index,i,1))*atomChargeMatrix(addBond(index,i,2))./norm(arrow);
    end
    if(pauseFlag==1)
        pause
    end
end



title('Structure 2 connected bond:blue  broken bond:red');
plot3(originalCell2(1:atom1,1),originalCell2(1:atom1,2),originalCell2(1:atom1,3),'r*');
plot3(originalCell2(atom1+1:atom1+atom2,1),originalCell2(atom1+1:atom1+atom2,2),originalCell2(atom1+1:atom1+atom2,3),'g*');
plot3(originalCell2(atom2+atom1+1:atom2+atom1+atom3,1),originalCell2(atom2+atom1+1:atom2+atom1+atom3,2),originalCell2(atom2+atom1+1:atom2+atom1+atom3,3),'k*');

end
%%

% Analysize the distribution of add left and transfer bond
DistributionAdd=zeros(size(addBond,1),3);
DistributionLeft=DistributionAdd;
DistributionTransferAdd=DistributionAdd;
DistributionTransferLeft=DistributionAdd;
for i=1:size(addBond,1)
    for j=1:size(addBond,2)
        if(addBond(i,j,1)==0)
            continue
        elseif(transferBondAdd(i,j,1)~=0)
            if(atomIndexMatrix(addBond(i,j,1))==1&&atomIndexMatrix(addBond(i,j,2))==1)
                DistributionMatrixColoum=1;
            end
            if(atomIndexMatrix(addBond(i,j,1))==2&&atomIndexMatrix(addBond(i,j,2))==2)
                DistributionMatrixColoum=2;
            end
            if((atomIndexMatrix(addBond(i,j,1))==1&&atomIndexMatrix(addBond(i,j,2))==2)||(atomIndexMatrix(addBond(i,j,1))==2&&atomIndexMatrix(addBond(i,j,2))==1))
                DistributionMatrixColoum=3;
            end
            DistributionTransferAdd(i,DistributionMatrixColoum)=DistributionTransferAdd(i,DistributionMatrixColoum)+1;
        else
            if(atomIndexMatrix(addBond(i,j,1))==1&&atomIndexMatrix(addBond(i,j,2))==1)
                DistributionMatrixColoum=1;
            end
            if(atomIndexMatrix(addBond(i,j,1))==2&&atomIndexMatrix(addBond(i,j,2))==2)
                DistributionMatrixColoum=2;
            end
            if((atomIndexMatrix(addBond(i,j,1))==1&&atomIndexMatrix(addBond(i,j,2))==2)||(atomIndexMatrix(addBond(i,j,1))==2&&atomIndexMatrix(addBond(i,j,2))==1))
                DistributionMatrixColoum=3;
            end
            DistributionAdd(i,DistributionMatrixColoum)=DistributionAdd(i,DistributionMatrixColoum)+1;
        end   
    end
    
end


for i=1:size(leftBond,1)
    for j=1:size(leftBond,2)
        if(leftBond(i,j,1)==0)
            continue
        elseif(transferBondLeft(i,j,1)~=0)
            if(atomIndexMatrix(leftBond(i,j,1))==1&&atomIndexMatrix(leftBond(i,j,2))==1)
                DistributionMatrixColoum=1;
            end
            if(atomIndexMatrix(leftBond(i,j,1))==2&&atomIndexMatrix(leftBond(i,j,2))==2)
                DistributionMatrixColoum=2;
            end
            if((atomIndexMatrix(leftBond(i,j,1))==1&&atomIndexMatrix(leftBond(i,j,2))==2)||(atomIndexMatrix(leftBond(i,j,1))==2&&atomIndexMatrix(leftBond(i,j,2))==1))
                DistributionMatrixColoum=3;
            end
            DistributionTransferLeft(i,DistributionMatrixColoum)=DistributionTransferLeft(i,DistributionMatrixColoum)+1;
        else
            if(atomIndexMatrix(leftBond(i,j,1))==1&&atomIndexMatrix(leftBond(i,j,2))==1)
                DistributionMatrixColoum=1;
            end
            if(atomIndexMatrix(leftBond(i,j,1))==2&&atomIndexMatrix(leftBond(i,j,2))==2)
                DistributionMatrixColoum=2;
            end
            if((atomIndexMatrix(leftBond(i,j,1))==1&&atomIndexMatrix(leftBond(i,j,2))==2)||(atomIndexMatrix(leftBond(i,j,1))==2&&atomIndexMatrix(leftBond(i,j,2))==1))
                DistributionMatrixColoum=3;
            end
            DistributionLeft(i,DistributionMatrixColoum)=DistributionLeft(i,DistributionMatrixColoum)+1;
        end   
    end
    
end


%%
pEX2=pEX;
pEX2(:,4)=[];
pEX2(97:end,:)=[];
%%
Eadd=0.5*DistributionAdd.*pEX2;
EaddSep=sum(Eadd(2:end,:));
EaddTot=sum(EaddSep);


Eleft=0.5*DistributionLeft.*pEX2;
EleftSep=sum(Eleft(2:end,:));
EleftTot=-sum(EleftSep);

EtransferAdd=0.5*DistributionTransferAdd.*pEX2;
EtransferAddSep=sum(EtransferAdd(2:end,:));
EtransferAddTot=sum(EtransferAddSep);

EtransferLeft=0.5*DistributionTransferLeft.*pEX2;
EtransferLeftSep=sum(EtransferLeft(2:end,:));
EtransferLeftTot=sum(EtransferLeftSep);

Etransfer=EtransferAddTot-EtransferLeftTot;
%%
% DiffDistributation(:,4)=[];
% DiffDistributation(97:end,:)=[];
% sum(((DistributionLeft-DistributionAdd)'-sum(2*DiffDistributation,2))~=0)
%%
if(calE==2)
    disp('E1: add left transfer');
    disp([addE1/2 leftE1/2 transferE1/2]);
    disp('E2: add left transfer');
    disp([addE2/2 leftE2/2 transferE2/2]);
    E2tot-E1tot
    0.5*(transferE2+addE2-transferE1-leftE1)
end

if(calE==1)
    disp('------------')
    disp('File1:')
    disp(filename1)
    disp('File2:')
    disp(filename2)
    disp(' ')
    disp('E1 and E2:')
    disp([E1tot E2tot])
    disp('E2-E1')
    disp((Etransfer+EleftTot+EaddTot))
    if(abs((Etransfer+EleftTot+EaddTot)-E2tot+E1tot)>1e-4)
        disp('Energy mismatch!!!')
    end
    disp('Eadd Eleft Etransfer:')
    disp([EaddTot EleftTot Etransfer])
    disp('------------')
    disp('Energy change detail:')
    disp('1:O-O 2:Ca-Ca 3:O-Ca')
    disp(' ')
    disp('Eadd1 Eadd2 Eadd3')
    disp(EaddSep)
    disp('Eleft1 Eleft2 Eleft3')
    disp(-EleftSep)
    disp('Etransfer1 Etransfer2 Etransfer3')
    disp(EtransferAddSep-EtransferLeftSep)
end