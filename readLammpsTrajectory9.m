function [timeStep,atomNum,atomIdx,atomElement,Coordinates,force,atomCharge,cellLength] = readLammpsTrajectory9(filename,readRange)

% Read lammps file contains fx fy fz v1.1
% [timeStep,atomNum,atomIdx,atomElement,Coordinates,force,atomCharge,cellLength] = readLammpsTrajectory9(filename,readRange)


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
    frame;
    try
    %ftell(FID)
    %FID
%     lineFeedCharacter
    [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
    %ftell(FID)
    %[header,position1] = textscan(FID,'%s %s\n%d\n%s %s %s %s\n%d\n%s %s %s %s %s %s\n%f %f\n%f %f\n%f %f\n%s %s %s %s %s %s %s %s ',1);
    %header{:}
    timeStep(frame) = header{3};
    
    catch
        try
            lineFeedCharacter = '\r';
            frewind(FID);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        catch
            lineFeedCharacter = '\r\n';
            frewind(FID);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        end
    end
    atomNum(frame) = header{8};
    cellLength(:,frame)= [header{15:20}];
    % ftell(FID)
    filePointerPosition = ftell(FID);
    try
    [dataCell,position2] = textscan(FID,['%f ' elementFormat ' %f %f %f %f %f %f %f ' lineFeedCharacter]);
    %ftell(FID)
    dataMat = cell2mat(dataCell);
    catch
        clear dataMat
        elementFormat = '%s';
        fseek(FID,filePointerPosition,-1);
        [dataCell,position2] = textscan(FID,['%f ' elementFormat ' %f %f %f %f %f %f %f ' lineFeedCharacter]);
        dataMat(:,1) = cell2mat(dataCell(:,1));
        currentElement = [];
        for i = 1:size(dataCell{1},1)
            if(strcmp(dataCell{2}(i),'Si'))
                dataMat(i,2) = 1001;
                if(sum(currentElement == 1001) == 0 )
                    currentElement(length(currentElement) + 1) = 1001;
                end
             elseif(strcmp(dataCell{2}(i),'Al'))
                dataMat(i,2) = 1002;
                %disp 'O'
                if(sum(currentElement == 1002) == 0 )
                    currentElement(length(currentElement) + 1) = 1002;
                end
            elseif(strcmp(dataCell{2}(i),'Li'))
                dataMat(i,2) = 1003;
                %disp 'O'
                if(sum(currentElement == 1003) == 0 )
                    currentElement(length(currentElement) + 1) = 1003;
                end
            elseif(strcmp(dataCell{2}(i),'O'))
                dataMat(i,2) = 1004;    
                if(sum(currentElement == 1004) == 0 )
                    currentElement(length(currentElement) + 1) = 1004;
                end
            else
                disp('Unknown element');
                dataMat(i,2) = 1005;
                if(sum(currentElement == 1005) == 0 )
                    currentElement(length(currentElement) + 1) = 1005;
                end
                %disp 'Else'
            end
        end
        dataMat2 = dataMat(:,2);
        currentElement = sort(currentElement);
        for i = 1:length(currentElement)
            dataMat2(dataMat2 == currentElement(i)) = i;    
        end
        dataMat(:,2) = dataMat2;
        dataMat(:,3:9) = cell2mat(dataCell(:,3:9));
    end
    atomIdx(:,frame) = dataMat(:,1);
    atomElement(:,frame) = dataMat(:,2);
    %atomElement(3,frame)
    Coordinates(:,1:3,frame) = dataMat(:,3:5);
    force(:,1:3,frame) = dataMat(:,6:8);
    atomCharge(:,frame) = dataMat(:,9);
    %atomCharge = 0;    
    frame = frame+1;
    %ftell(FID)
end
fclose(FID);
% clc
end