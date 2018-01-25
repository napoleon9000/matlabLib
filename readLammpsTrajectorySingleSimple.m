function [timeStep,atomNum,atomElement,Coordinates] = readLammpsTrajectorySingleSimple(filename,inputFrame, fPosition)

% Read lammps file v1.1
% [timeStep,atomNum,atomElement,Coordinates] =
% readLammpsTrajectorySingleSimple(filename,inputFrame, fPosition);


FID = fopen(filename);
% lineFeedCharacter = '\n';
lineFeedCharacter = '\r';
% lineFeedCharacter = '\r\n';
elementFormat = '%f';

fseek(FID,fPosition(inputFrame),'bof');
frame = 1;
try
%ftell(FID)
%FID
[header,~] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
%ftell(FID)
%[header,position1] = textscan(FID,'%s %s\n%d\n%s %s %s %s\n%d\n%s %s %s %s %s %s\n%f %f\n%f %f\n%f %f\n%s %s %s %s %s %s %s %s ',1);
%header{:}
timeStep(frame) = header{3};

catch
    try
        lineFeedCharacter = '\r';
        fseek(FID,fPosition(inputFrame),'bof');
        [header,~] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
        timeStep(frame) = header{4};
        atomNum(frame) = header{1};
    catch
        lineFeedCharacter = '\r\n';
        fseek(FID,fPosition(inputFrame),'bof');
        [header,~] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
        header{:}
        timeStep(frame) = header{4};
        atomNum(frame) = header{1};
    end
end
atomNum(frame) = header{1};
% cellLength(:,frame)= [header{15:20}];
% ftell(FID)
% filePointerPosition = ftell(FID);
% try
[dataCell,~] = textscan(FID,['%d %f %f %f' lineFeedCharacter]);
%ftell(FID)
dataMat = cell2mat(dataCell);
% catch
%     clear dataMat
%     elementFormat = '%s';
%     fseek(FID,filePointerPosition,-1);
%     [dataCell,~] = textscan(FID,['%d %f %f %f' lineFeedCharacter]);
%     dataMat(:,1) = cell2mat(dataCell(:,1));
%     for i = 1:size(dataCell{1},1)
%         if(strcmp(dataCell{2}(i),'Al'))
%             dataMat(i,2) = 2;
%         elseif(strcmp(dataCell{2}(i),'O'))
%             dataMat(i,2) = 1;
%             %disp 'O'
%         else
%             dataMat(i,2) = 0;
%             %disp 'Else'
%         end
%     end
%     dataMat(:,3:6) = cell2mat(dataCell(:,3:6));
% end

%atomIdx(:,frame) = dataMat(:,1);
atomElement(:,frame) = dataMat(:,1);
%atomElement(3,frame)
Coordinates(:,1:3,frame) = dataMat(:,2:4);
%atomCharge(:,frame) = dataMat(:,6);
%atomCharge = 0;    
%ftell(FID)
    



fclose(FID);
% clc
end