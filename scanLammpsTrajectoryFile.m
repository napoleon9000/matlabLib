function fPosition = scanLammpsTrajectoryFile( filename, target )
%SCANLAMMPSTRAJECTORYFILE Scan the traj file and return position of each
%frame
%   fPosition = scanLammpsTrajectoryFile( filename )
% filename = 'F:\Oxidation\constOxd_kim-600\traj_all.xyz';
% target = 'ITEM: TIMESTEP';


lenTarget = length(target);
fPosition = zeros(1, 500);
fid = fopen(filename);
if(fid == -1)
    disp('Can not open file')
end
fseek(fid,0,'eof');
endPosition = ftell(fid);
frewind(fid);
i = 1;
jumpFail = 0;
jumpRate = 0.95;
while (ftell(fid)<(endPosition-10))
    lineContent = fgets(fid);   
    if(length(lineContent) >= lenTarget && strcmp(lineContent(1:lenTarget),target))
        fPosition(i) = ftell(fid)-length(lineContent);
        i = i+1;
        if(i > 2)
            if(i >3)
            % check last jump
                if(fPosition(i-1)-fPosition(i-2) > 1.5*(fPosition(i-2)-fPosition(i-3)))
                    i = i-1;
                    fseek(fid,fPosition(i-1),'bof');
                    jumpFail = 1
                    jumpRate = jumpRate*0.9;
                else
                    jumpFail = 0;
%                     jumpRate = jumpRate*1.01;
                end
            end
            % jump
            jumpDistance = round(jumpRate*(fPosition(i-1)-fPosition(i-2)));
            fseek(fid,fPosition(i-1)+jumpDistance,'bof');            
        end
    end
end

fPosition(i:end) = [];
fclose(fid);

end

