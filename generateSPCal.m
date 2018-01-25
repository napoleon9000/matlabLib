function status = generateSPCal(folderName, bashFolder, generateBash, CHGCAR, homeDir)
% Generate single point calculation job on from finished VASP calculation
% status = generateSPCal(folderName, bashFolder, generateBash, CHGCAR,
% homeDir);

% folderName = 'F:\SPG\LiCoO2\cluster\K1\clusterLi37Co6O26\';
% bashFolder = 'F:\SPG\LiCoO2\cluster\K1\';
% generateBash = 1;
% CHGCAR = 1;
oriFolder = pwd;
%homeDir = '/mnt/ls15/scratch/groups/msce/SPG/LiCoO2/cluster/K1';

if(generateBash)
    fclose all;
    if(exist([bashFolder 'submitJob.sh'],'file'))
        delete([bashFolder 'submitJob.sh']);
    end
    fidBash = fopen([bashFolder 'submitJob.sh'],'a+');
        fprintf(fidBash,'%s','#! bin/bash/'); 
        fprintf(fidBash,'\n'); 
    if(fidBash == -1)
        disp('Cannot create bash file')        
    end
end

for i = 1:size(folderName,1)
    oriFolderName = folderName(i,:);
    oriFolderName(isspace(oriFolderName)) = [];
    spFolderName = [oriFolderName '-sp'];
    copyfile(oriFolderName,spFolderName);
    
    currentFolder = spFolderName;
    currentOutputFileReg = regexp(currentFolder,'.*\\(.*)\\','tokens');
    currentOutputFile = char(currentOutputFileReg{1});
    cd(currentFolder)

    


    copyfile('INCAR','INCAR_ori');
    copyfile('OSZICAR','OSZICAR_ori');
    copyfile('OSZICAR','OSZICAR_ori');
    copyfile('POSCAR','POSCAR_ori');
    copyfile('CONTCAR','CONTCAR_ori');
    copyfile('CONTCAR','POSCAR');
    INCAR_Content = readList('INCAR');
    INCAR_ContentStr = reshape(INCAR_Content',1,size(INCAR_Content,1)*size(INCAR_Content,2));
    % change NSW
    NSW_posi = regexp(INCAR_ContentStr,'NSW');
    NSW_posi_r = ceil(NSW_posi/size(INCAR_Content,2));
    NSW_posi_c = mod(NSW_posi,size(INCAR_Content,2));
    INCAR_Content(NSW_posi_r,NSW_posi_c:NSW_posi_c+10) = 'NSW = 1    ';

    % change LCHARG
    if(CHGCAR)
        LCHARG_posi = regexp(INCAR_ContentStr,'LCHARG');
        LCHARG_posi_r = ceil(LCHARG_posi/size(INCAR_Content,2));
        LCHARG_posi_c = mod(LCHARG_posi,size(INCAR_Content,2));
        INCAR_Content(LCHARG_posi_r,LCHARG_posi_c:LCHARG_posi_c+19) = 'LCHARG = .True.     ';    
    end

    writeList('INCAR',INCAR_Content);


    if(generateBash)            
        fprintf(fidBash,'%s', ['cd ' homeDir '/' currentOutputFile]);
        fprintf(fidBash,'\n');
        fprintf(fidBash,'%s', 'qsub myjob.qsub');
        fprintf(fidBash,'\n');
    end
end
cd(oriFolder);

if(generateBash)
    fprintf(fidBash,'%s', 'qstat -u jlliu');
    fclose(fidBash);
end

status = 0;