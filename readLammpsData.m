function [atomNum,atomIdx,atomElement,coordinates,cellLength,atomCharge] = readLammpsData(filename)

% Read single lammps data file v1.1
% [atomNum,atomIdx,atomElement,coordinates,cellLength,atomCharge] = readLammpsData(filename)

FID = fopen(filename);
% fseek(FID,0,'eof');
% endPosition = ftell(FID);
frewind(FID);
lineFeedCharacter = '\r\n';
% lineFeedCharacter = '\r';
% lineFeedCharacter = '\r\n';
elementFormat = '%f';
lineContent=fgetl(FID);
headerTextFormat = ['%f %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter ];
%%
try     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%try different lineFeedCharacter
%ftell(FID)
%FID
[header,position1] = textscan(FID,headerTextFormat,1);
atomNum = header{1};
atomTypeNum = header{3};
cellLength = [header{6:7};header{10:11};header{14:15};];
lineContent=fgetl(FID);
lineContent=fgetl(FID);
lineContent=fgetl(FID);

%%

try
    filePointerPosition = ftell(FID);
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
catch    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%catch different lineFeedCharacter
    try
        lineFeedCharacter = '\r';
        elementFormat = '%f';
        headerTextFormat = ['%f %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter ];
        frewind(FID);
        lineContent=fgetl(FID);
        [header,position1] = textscan(FID,headerTextFormat,1);
        atomNum = header{1};
        atomTypeNum = header{3};
        cellLength = [header{6:7};header{10:11};header{14:15};];
        lineContent=fgetl(FID);
        lineContent=fgetl(FID);
        lineContent=fgetl(FID);

        %%

        try
            filePointerPosition = ftell(FID);
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
    catch    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%catch different lineFeedCharacter
        lineFeedCharacter = '\n';
        elementFormat = '%f';
        headerTextFormat = ['%f %s' lineFeedCharacter '%d %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter '%f %f %s %s' lineFeedCharacter ];
        frewind(FID);
        lineContent=fgetl(FID);
        [header,position1] = textscan(FID,headerTextFormat,1);
        atomNum = header{1};
        atomTypeNum = header{3};
        cellLength = [header{6:7};header{10:11};header{14:15};];
        lineContent=fgetl(FID);
        lineContent=fgetl(FID);
        lineContent=fgetl(FID);

        %%

        try
            filePointerPosition = ftell(FID);
            
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
    end
end   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end different lineFeedCharacter

atomIdx = dataMat(:,1);
atomElement = dataMat(:,2);
coordinates = dataMat(:,4:6);
atomCharge = dataMat(:,3);


fclose(FID);
end
