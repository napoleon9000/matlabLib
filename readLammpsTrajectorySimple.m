function [timeStep,atomNum,atomElement,Coordinates] = readLammpsTrajectory(filename,readRange)

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
    [header,position1] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
    timeStep(frame) = header{4};
    atomNum(frame) = header{1};
    catch
        try
            lineFeedCharacter = '\r';
            frewind(FID);
            [header,position1] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
            timeStep(frame) = header{4};
            atomNum(frame) = header{1};
        catch
            lineFeedCharacter = '\r\n';
            frewind(FID);
            [header,position1] = textscan(FID,['%d' lineFeedCharacter '%s %s %d' lineFeedCharacter],1);
            timeStep(frame) = header{4};
            atomNum(frame) = header{1};
        end
    end
    % ftell(FID)
    
    filePointerPosition = ftell(FID);
    try
    [dataCell,position2] = textscan(FID,[elementFormat ' %f %f %f' lineFeedCharacter]);

    dataMat = cell2mat(dataCell);
    catch
        clear dataMat
        elementFormat = '%s';
        fseek(FID,filePointerPosition,-1);
        [dataCell,position2] = textscan(FID,[elementFormat ' %f %f %f' lineFeedCharacter]);
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
    filePointerPosition = ftell(FID);
    if(dataMat(end,1) ~= dataMat(end-1,1))
    dataMat(end,:) = [];
    end
    
    test = textscan(FID,'%c ');
    extraString = dataCell{end,1};
    backspace = ceil(log10(extraString(end)));
    fseek(FID,filePointerPosition-backspace-1,-1);
    atomElement(:,frame) = dataMat(:,1);
    
    %atomElement(3,frame)
    Coordinates(:,1:3,frame) = dataMat(:,2:4);
    %atomCharge = 0;    
    frame = frame+1;
    %ftell(FID)
%     Coordinates;
end
fclose(FID);

end