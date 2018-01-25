% Compare the rotation angle of (CO3)2- ions. Needs to run
% StructureDifference.m first.


clear
StructureDifference
clc
cutOffCO3=1.5;
fileName1='PerfectSlabRelaxedSlipSF.vasp';
fileName2='StackingFaultRelaxed.vasp';
% Load files
[coordinate1,ONumber,CaNumber,CNumber,a1,b1,c1]=loadPOSCAR(fileName1);
[coordinate2,~,~,~]=loadPOSCAR(fileName2);
co3Angle1=zeros(size(coordinate1,1),3,3);    %co3Angle(ONumber,C-O bond #,xyzAngle)
co3Angle2=co3Angle1;
OSerial=1:ONumber;
CaSerial=ONumber+1:ONumber+CaNumber;
CSerial=ONumber+CaNumber+1:ONumber+CaNumber+CNumber;
CO3Coordinate1=CorrelateCO3(coordinate1,ONumber,CaNumber,CNumber,a1,b1,c1,cutOffCO3);  %Correlate the C and O atoms in CO3
coordinate1Old=coordinate1;
coordinate2Old=coordinate2;
coordinate1=adjustBoundary(coordinate1,CO3Coordinate1,a1,b1,c1);
coordinate2=adjustBoundary(coordinate2,CO3Coordinate1,a1,b1,c1);
CO3Normal1=zeros(size(coordinate1));
CO3Normal2=zeros(size(coordinate2));
flatFactor1=zeros(size(coordinate1,1),1);
flatFactor2=zeros(size(coordinate2,1),1);

% Calculate the rotation angle and plane normal
for i=CSerial
    for j=1:3
        %i
        %j;
        %norm(coordinate1(i,:)-coordinate1(j,:))
        currentAngle1=angleProjection([coordinate1(i,:);coordinate1(CO3Coordinate1(i,j),:)]);
        currentAngle2=angleProjection([coordinate2(i,:);coordinate2(CO3Coordinate1(i,j),:)]);
        co3Angle1(CO3Coordinate1(i,j),1,:)=currentAngle1;
        co3Angle2(CO3Coordinate1(i,j),1,:)=currentAngle2;
        co3Angle1(i,j,:)=currentAngle1;
        co3Angle2(i,j,:)=currentAngle2;

%         if(j==32&&i==116)
%             co3Angle1(j,:,3)
%             co3Angle2(j,:,3)
%             [coordinate1(i,:);coordinate1(j,:)]
%             [coordinate2(i,:);coordinate2(j,:)]
%         end
    end
        [CO3Normal1(i,:),flatFactor1(i)]=CO3Normal([coordinate1(i,:);coordinate1(CO3Coordinate1(i,1),:);coordinate1(CO3Coordinate1(i,2),:);coordinate1(CO3Coordinate1(i,3),:)]);
        [CO3Normal2(i,:),flatFactor2(i)]=CO3Normal([coordinate2(i,:);coordinate2(CO3Coordinate1(i,1),:);coordinate2(CO3Coordinate1(i,2),:);coordinate2(CO3Coordinate1(i,3),:)]);
end
angleDifference=co3Angle1-co3Angle2;
angleDifference((angleDifference<-350))=angleDifference((angleDifference<-350))+360;
angleDifference((angleDifference>350))=angleDifference((angleDifference>350))-360;
normalDifference=CO3Normal2-CO3Normal1;



%{

subplot(4,1,1)
hold on
grid on
axis equal
%caxis([-7 7])
axis([0 a1 0 b1 0 c1]);
coordinate1=coordinate1Old;
coordinate2=coordinate2Old;
scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),100*ones(size(OSerial,1),1),angleDifference(OSerial,1,1),'filled','MarkerEdgeColor','k')
C0=colorbar;
scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),'ko')
colorAxis1=caxis;
xlabel('a');
ylabel('b');
zlabel('c');

subplot(4,1,2)
hold on
grid on
axis equal
%caxis(colorAxis1)
axis([0 a1 0 b1 0 c1]);
scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),100*ones(size(OSerial,1),1),angleDifference(OSerial,1,2),'filled','MarkerEdgeColor','k')
C1=colorbar;
scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),'ko')
caxis([-6 6]);
xlabel('a');
ylabel('b');
zlabel('c');


subplot(4,1,3)
%}


%coordinate rotation
%
% coordinate1_backup=coordinate1;
% dcoordinate_backup=dcoordinate;
% coordinate1(:,1)=coordinate1_backup(:,3);
% coordinate1(:,2)=coordinate1_backup(:,1);
% coordinate1(:,3)=coordinate1_backup(:,2);
% 
% dcoordinate(:,1)=dcoordinate_backup(:,3);
% dcoordinate(:,2)=dcoordinate_backup(:,1);
% dcoordinate(:,3)=dcoordinate_backup(:,2);

clf
hold on

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
%
set(H,'Color','k');
% Readjust the boundary
coordinate1=coordinate1Old;
coordinate2=coordinate2Old;





hold on
grid on
axis equal
ArrowWidth=2;
caxis([-6 6]);
%axis([0 a1 0 b1 0 c1]);
scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),100*ones(size(OSerial,1),1),angleDifference(OSerial,1,3),'filled','MarkerEdgeColor','k')
C2=colorbar;
scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),'filled','k')
scatter3(coordinate1(CaSerial,1),coordinate1(CaSerial,2),coordinate1(CaSerial,3),'filled','o')
H=quiver3([coordinate1(atom1+1:atom1+atom2,1);1],[coordinate1(atom1+1:atom1+atom2,2);1],[coordinate1(atom1+1:atom1+atom2,3);1],...
        [dcoordinate(atom1+1:atom1+atom2,1);0],[dcoordinate(atom1+1:atom1+atom2,2);.1],[dcoordinate(atom1+1:atom1+atom2,3);0],0.4,'r','linewidth',1);
set(H,'LineWidth',ArrowWidth)
xlabel('[1 1 0]','FontWeight','demi','FontSize',14);
ylabel('[1 -1 0]','FontWeight','demi','FontSize',14);
zlabel('[0 0 -1]','FontWeight','demi','FontSize',14);



% subplot(4,1,4)
hold on 
grid on
axis equal
axis([0 24 0 b1 0 c1]);

%scatter3(coordinate1(OSerial,1),coordinate1(OSerial,2),coordinate1(OSerial,3),'b')
scatter3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),'filled','k')
%quiver3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),CO3Normal1(CSerial,1),CO3Normal1(CSerial,2),CO3Normal1(CSerial,3));
%quiver3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),CO3Normal2(CSerial,1),CO3Normal2(CSerial,2),CO3Normal2(CSerial,3));
%quiver3(coordinate1(CSerial,1),coordinate1(CSerial,2),coordinate1(CSerial,3),normalDifference(CSerial,1),normalDifference(CSerial,2),normalDifference(CSerial,3),'b');
H=quiver3([coordinate1(atom1+atom2+1:atom1+atom2+atom3,1);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,2);2],[coordinate1(atom1+atom2+1:atom1+atom2+atom3,3);2],...
        [dcoordinate(atom1+atom2+1:atom1+atom2+atom3,1);0],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,2);.1],[dcoordinate(atom1+atom2+1:atom1+atom2+atom3,3);0],0.3,'k','linewidth',1);
set(H,'LineWidth',ArrowWidth)
% Create label
% xlabel('[0 0 -1]','FontWeight','demi','FontSize',14);
% ylabel('[1 1 0]','FontWeight','demi','FontSize',14);
% zlabel('[1 -1 0]','FontWeight','demi','FontSize',14);

% C-O bond


% axis rotation
%axis([0 c1 0 a1 0 b1]);
box on
%text(1,1,'Projection from [1 -1 0]','rotation',90);


