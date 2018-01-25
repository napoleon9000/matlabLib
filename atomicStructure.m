classdef atomicStructure
    %ATOMICSTRUCTURE reads the atomic structure from files
    %   structure = atomicStructure(filename, filetype)
    %   filetype = ['vasp', 'data']
    
    properties
        comment
        scallingFactor
        atomNum
        atomTypeNum
        atomIdx
        atomElement
        elementName
        coordinates
        cellLength
        cellLengthLammps
        atomCharge
    end
    
    methods
        function obj = atomicStructure(filename, filetype)
            switch filetype
                case 'vasp'
                    obj = obj.readVASPData(filename);
                case 'data'
                    obj = obj.readLammpsData(filename);
                otherwise
                    disp('This file type is not supportted')
            end
        end
        
        
        function obj = readLammpsData(obj, filename)
            FID = fopen(filename);
            if(FID == -1)
                disp('Cannot open structure file')
                return
            end
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
            obj.atomNum = header{1};
            obj.atomTypeNum = header{3};
            obj.cellLengthLammps = [header{6:7};header{10:11};header{14:15};];
            obj.cellLength = diag(obj.cellLengthLammps(:,2)-obj.cellLengthLammps(:,1));
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
                    obj.atomNum = header{1};
                    obj.atomTypeNum = header{3};
                    obj.cellLengthLammps = [header{6:7};header{10:11};header{14:15};];
                    obj.cellLength = diag(obj.cellLengthLammps(:,2)-obj.cellLengthLammps(:,1));
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
                    obj.atomNum = header{1};
                    obj.atomTypeNum = header{3};
                    obj.cellLengthLammps = [header{6:7};header{10:11};header{14:15};];
                    obj.cellLength = diag(obj.cellLengthLammps(:,2)-obj.cellLengthLammps(:,1));
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

            obj.atomIdx = dataMat(:,1);
            obj.atomElement = dataMat(:,2);
            obj.coordinates = dataMat(:,4:6);
            obj.atomCharge = dataMat(:,3);
            fclose(FID);
        end
        
        function obj = readVASPData(obj, filename)
            copyfile(filename,'tmp.vasp')
            file1=fopen('tmp.vasp','r+');
            dataStr='';
            charCount=0;
            for i=1:8
                lineContent=fgetl(file1);
                charCount=charCount+size(lineContent,2);
                dataStr=char(dataStr,num2str(lineContent));
            end
            obj.comment=dataStr(2,:);
            obj.scallingFactor=str2num(dataStr(3,:));
            obj.cellLength(1,:)=str2num(dataStr(4,:));
            obj.cellLength(2,:)=str2num(dataStr(5,:));
            obj.cellLength(3,:)=str2num(dataStr(6,:));
            obj.elementName=dataStr(7,:);
            obj.atomNum=str2num(dataStr(8,:));
            switchLine=dataStr(9,:);

            fclose(file1);
            delete('tmp.vasp');
            copyfile(filename,'tmp.vasp')
            file1=fopen('tmp.vasp','r+');

            replaceContent=num2str(ones(1,charCount));
            replaceContent=strrep(replaceContent,'1',' ');
            replaceContent((charCount+15):end)='';
            if(switchLine(1)=='D'||switchLine(1)=='C')
                fprintf(file1,replaceContent);
            elseif(switchLine(1)=='S'||switchLine(1)=='s')
                fprintf(file1,replaceContent);
            else
                disp('Can not read POSCAR');
            end
            % exist('tmp.vasp')
            obj.coordinates=load('tmp.vasp');
            obj.coordinates=obj.coordinates*obj.scallingFactor;

            fclose(file1);
            delete('tmp.vasp');
            obj.atomTypeNum = length(obj.atomNum);
        end
    end
    
end

