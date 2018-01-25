function status = addInfo(file, iterm, value)
%ADDINFO Add entry to info file
%   status = addInfo(fileName, iterm, value);
%   status: 0: wrong 1: correct
status = 0;
if(size(file,1) == 1 && strcmp(file(end-2:end),'txt'))
    [iterm0,value0] = readInfo(file);
    for i = 1:length(iterm0)
        if(strcmp(iterm0{i},iterm))
            value0(i) = value;
            status = 1;
        end
    end
    if(~status)
        iterm0(end + 1) = {iterm};
        value0(end + 1) = value;
        status = 1;
    end
    infoContent = [];
    for i = 1:length(iterm0)
        infoContent = char(infoContent,[iterm0{i},',',num2str(value0(i))]);
    end
    infoContent(1,:) = [];
    writeList(file,infoContent);
    
else
    disp('Wrong file');
end


end