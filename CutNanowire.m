clear
clc
R=20;
Filename=['Alnw' num2str(R) '.vasp'];

disp('loading structure...')
[commentLine,scallingFactor,cellLength,elementName,atomNum, Position ]=readPOSCAR('Al25_25_25.vasp');
Dimension=[norm(cellLength(1,:)) norm(cellLength(2,:)) norm(cellLength(3,:))];
digits(6);
disp('calculating...')
for i=1:size(Position,1)
    Length=norm([Position(i,1)-Dimension(1)*0.5 Position(i,2)-Dimension(2)*0.5]);
    if(Length>=R)
        Position(i,:)=[0 0 0];
    end
end
Position(Position(:,1)==0,:)=[];
atomNum=size(Position,1);
disp('writing structure...')
writePOSCAR(Filename,commentLine,scallingFactor,cellLength,elementName,atomNum, Position );