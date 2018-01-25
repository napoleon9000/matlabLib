function [solidVol, totVol] = calTrajectoryVol(filename,readRange,meshSize)

% Read lammps file contains fx fy fz v1.1
% [timeStep,atomNum,atomIdx,atomElement,Coordinates,force,atomCharge,cellLength] = readLammpsTrajectory9(filename,readRange)


FID = fopen(filename);
frame = 1;
volFrame = 1;
fseek(FID,0,'eof');
endPosition = ftell(FID);
frewind(FID);
lineFeedCharacter = '\n';
% lineFeedCharacter = '\r';
% lineFeedCharacter = '\r\n';
elementFormat = '%f';

while (ftell(FID)<(endPosition-10))
%while(frame <= 1)    
    if(readRange~=0&&readRange<volFrame)
        break
    end
    if(mod(volFrame,100)==0)
        disp(volFrame)
    end
    try
    %ftell(FID)
    %FID
%      lineFeedCharacter
%     if(volFrame>2001)
%         lineFeedCharacter = '\r\n';
%     end
    positionB4scan = ftell(FID);
    [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
    %ftell(FID)
    %[header,position1] = textscan(FID,'%s %s\n%d\n%s %s %s %s\n%d\n%s %s %s %s %s %s\n%f %f\n%f %f\n%f %f\n%s %s %s %s %s %s %s %s ',1);
    %header{:}

    timeStep(frame) = header{3};
    
    catch
        try
            lineFeedCharacter = '\r';
            fseek(FID,positionB4scan,-1);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        catch
            lineFeedCharacter = '\r\n';
            fseek(FID,positionB4scan,-1);
            [header,position1] = textscan(FID,['%s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s' lineFeedCharacter '%d' lineFeedCharacter '%s %s %s %s %s %s' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%f %f' lineFeedCharacter '%s %s %s %s %s %s %s %s %s %s %s '],1);
            timeStep(frame) = header{3};
            atomNum(frame) = header{8};
        end
    end
    atomNum(frame) = header{8};
    cellLength(:,frame)= [header{15:20}];
    % ftell(FID)
    filePointerPosition = ftell(FID);
    if(volFrame == 2002)
        elementFormat = '%f';
    end
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
        dataMat(:,3:9) = cell2mat(dataCell(:,3:9));
    end
    atomIdx(:,frame) = dataMat(:,1);
    atomElement(:,frame) = dataMat(:,2);
    %atomElement(3,frame)
    Coordinates(:,1:3,frame) = dataMat(:,3:5);
    force(:,1:3,frame) = dataMat(:,6:8);
    atomCharge(:,frame) = dataMat(:,9);
    %atomCharge = 0;    
    frame = frame;
    volFrame = volFrame + 1;
    %ftell(FID)
    
    solidVol(volFrame-1) = calStructureVol(Coordinates(:,:,frame), cellLength(:,frame), atomElement(:,frame), meshSize);
    totVol(volFrame-1) = (cellLength(2,frame)-cellLength(1,frame))*(cellLength(4,frame)-cellLength(3,frame))*(cellLength(6,frame)-cellLength(5,frame));
end

fclose(FID);

end