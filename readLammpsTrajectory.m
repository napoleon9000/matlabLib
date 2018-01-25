function [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectory(filename,readRange)

% Read lammps file v1.1
% [timeStep,atomNum,atomIdx,atomElement,Coordinates,atomCharge,cellLength] = readLammpsTrajectory(filename,readRange);


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
    [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s '],1);
    %ftell(FID)
    %[header,position1] = textscan(FID,'%s %s\n%d\n%s %s %s %s\n%d\n%s %s %s %s %s %s\n%f %f\n%f %f\n%f %f\n%s %s %s %s %s %s %s %s ',1);
    %header{:}
    timeStep(frame) = header{3};
    
    catch
        try
            lineFeedCharacter = '\r';
            frewind(FID);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        catch
            lineFeedCharacter = '\r\n';
            frewind(FID);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        end
    end
    atomNum(frame) = header{8};
    cellLength(:,frame)= [header{15:20}];
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
    Coordinates(:,1:3,frame) = dataMat(:,3:5);
    atomCharge(:,frame) = dataMat(:,6);
    %atomCharge = 0;    
    frame = frame+1;
    %ftell(FID)
    
    %% Pre alocate data
    if(frame == 2 && readRange ~=0)
        timeStep = [timeStep zeros(1,readRange-2)];
        atomNum = [atomNum zeros(1,readRange-2)];
        atomElement = [atomElement zeros(atomNum(1),readRange-2)];
        atomIdx = [atomIdx zeros(atomNum(1),readRange-2)];
        cellLength = [cellLength zeros(6,readRange-2)];
        Coordinates(atomNum(1), 3, readRange) = 0;
    end    
    
    if(mod(frame, 100) == 0 && readRange == 0)    
        timeStep = [timeStep zeros(1,98)];
        atomNum = [atomNum zeros(1,98)];
        atomElement = [atomElement zeros(atomNum(1),98)];
        atomIdx = [atomIdx zeros(atomNum(1),98)];
        cellLength = [cellLength zeros(6,98)];
        Coordinates(atomNum(1), 3, readRange) = 0; 
    end
    
end

if(readRange == 0)    
    timeStep((frame+1):end) = [];
    atomNum((frame+1):end) = [];
    atomElement(:,(frame+1):end) = [];
    atomIdx(:,(frame+1):end) = [];
    cellLength(:,(frame+1):end) = [];
    Coordinates(:,:,(frame+1):end) = [];        
end


fclose(FID);
clc
end