function mFiles= RangTraversal( strPath )  
% RangTraversal List all files under a directory
% mFiles = RangTraversal( strPath );
    mFiles = cell(0,0);  
    mPath  = cell(0,0);  
      
    mPath{1}=strPath;  
    [~,c] = size(mPath);  
    while c ~= 0  
        strPath = mPath{1};  
        Files = dir(fullfile( strPath,'*.*'));  
        LengthFiles = length(Files);  
        if LengthFiles == 0  
            break;  
        end  
        mPath(1)=[];  
        iCount = 1;  
        while LengthFiles>0  
            if Files(iCount).isdir==1  
                if Files(iCount).name ~='.'  
                    filePath = [strPath  Files(iCount).name '\'];  
                    [~,c] = size(mPath);  
                    mPath{c+1}= filePath;  
                end  
            else  
                filePath = [strPath  Files(iCount).name];  
                [~,col] = size(mFiles);  
                mFiles{col+1}=filePath;  
            end  
  
            LengthFiles = LengthFiles-1;  
            iCount = iCount+1;  
        end  
        [~,c] = size(mPath);  
    end  
  
    mFiles = mFiles';  
end  