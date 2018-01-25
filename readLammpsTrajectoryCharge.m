function [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectoryCharge(filename,readRange)

% Read lammps file v1.1
% [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectoryCharge(filename,readRange);


FID = fopen(filename);
frame = 1;
fseek(FID,0,'eof');
endPosition = ftell(FID);
frewind(FID);
lineFeedCharacter = '\n';
% lineFeedCharacter = '\r';
% lineFeedCharacter = '\r\n';
elementFormat = '%f';

while (ftell(FID)<(endPosition-10))  
    
%while(frame <= 1)    
    if(readRange~=0&&readRange<frame)
        break
    end
    frame
    try
    %ftell(FID)
    %FID
    commentLine =  fgetl(FID);
    [header,position1] = textscan(FID,['%d %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter lineFeedCharacter '%s' lineFeedCharacter lineFeedCharacter],1);
    cellLength(:,frame)= [header{6:7} header{10:11} header{14:15}]';
    catch
        try
            lineFeedCharacter = '\r';
            frewind(FID);
            commentLine =  fgetl(FID);
            [header,position1] = textscan(FID,['%d %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter lineFeedCharacter '%s' lineFeedCharacter lineFeedCharacter],1);
            cellLength(:,frame)= [header{6:7} header{10:11} header{14:15}]';
        catch
            lineFeedCharacter = '\r\n';
            frewind(FID);
            commentLine =  fgetl(FID); %#ok<*NASGU>
            [header,position1] = textscan(FID,['%d %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter lineFeedCharacter '%s' lineFeedCharacter lineFeedCharacter],1); %#ok<*ASGLU>
            cellLength(:,frame)= [header{6:7} header{10:11} header{14:15}]';
        end
    end
    timeStep(frame) = 0; %#ok<*AGROW>
    atomNum(frame) = header{1};
    cellLength(:,frame)= [header{6:7} header{10:11} header{14:15}]';
    % ftell(FID)
    filePointerPosition = ftell(FID);
    try
    [dataCell,position2] = textscan(FID,['%f ' elementFormat ' %f %f %f %f' lineFeedCharacter]);
    %ftell(FID)
    dataMat = cell2mat(dataCell);
    catch
        clear dataMat
        elementFormat = '%s';
        fseek(FID,filePointerPosition,-1);
        [dataCell,position2] = textscan(FID,['%f ' elementFormat ' %f %f %f %f' lineFeedCharacter]);
        dataMat(:,1) = cell2mat(dataCell(:,1));
        for i = 1:size(dataCell{1},1)
            if(strcmp(dataCell{2}(i),'Al'))
                dataMat(i,2) = 2;
            elseif(strcmp(dataCell{2}(i),'O'))
                dataMat(i,2) = 1;
                %disp 'O'
            else
                dataMat(i,2) = 0;
                %disp 'Else'
            end
        end
        dataMat(:,3:6) = cell2mat(dataCell(:,3:6));
    end
    atomIdx(:,frame) = dataMat(:,1);
    atomElement(:,frame) = dataMat(:,2);
    %atomElement(3,frame)
    Coordinates(:,1:3,frame) = dataMat(:,4:6);
    atomCharge(:,frame) = dataMat(:,3);
    %atomCharge = 0;    
    frame = frame+1;
end
fclose(FID);
clc
end