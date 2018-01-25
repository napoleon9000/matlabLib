clear
clc
R=str2num(input('Pls input R:\n','s'));
nO2max=str2num(input('Pls input # of O2 molecules:\n','s'));    % # of O2 molecule
filenameInput=(input('Pls input filename:\n','s'));    % # of O2 molecule
disp('loading structure...')



nO2max=nO2max*2;% # of O atom
[commentLine,scallingFactor,cellLength,elementName,atomNum, Position ]=readPOSCAR(filenameInput);
Dimension=[norm(cellLength(1,:)) norm(cellLength(2,:)) norm(cellLength(3,:))];
%%
i=1;
digits(6);
Position=[Position;zeros(nO2max,3)];
randPosition=[Dimension(1)*rand(nO2max,1) Dimension(2)*rand(nO2max,1) Dimension(3)*rand(nO2max,1)];
%Odistance=5;
% while(i<size(Position,1))
%     Length=norm([Position(i,1)-Dimension(1)*0.5 Position(i,2)-Dimension(2)*0.5]);
%     if(Length>=R)
%         Position(i,:)=[];
%     else
%         i=i+1;
%     end
% end
disp('calculating...')
nO2=1;
for i=1:size(randPosition,1)
    if(norm([randPosition(i,1:2)]-0.5*[Dimension(1) Dimension(2)])>R)
        Position(nO2+size(Position,1)-nO2max,:)=randPosition(i,:)-[0 0 0.6];
        Position(nO2+1+size(Position,1)-nO2max,:)=randPosition(i,:)+[0 0 0.6];
        nO2=nO2+2;
    end
    if(nO2>nO2max)
        break
    end
end

disp('writing structure...')
filenameOutput=['O2_' filenameInput];
elementName=[elementName ' ' 'O'];
atomNum=[atomNum nO2-1];
writePOSCAR(filenameOutput,commentLine,scallingFactor,cellLength,elementName,atomNum, Position );

disp(nO2-1);
disp('Finished')