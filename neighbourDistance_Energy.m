clear
%----------------------------
% Define file names
filename1='1PS.vasp';
%%%%filename='TS_Rigid.vasp';
filename2='3SF.vasp';
filename3='4TwinNEB.vasp';


filename=char(filename1,filename2);

% Define parameters
centralAtom=[508,508,267,155,323];
% neighbourPair=[17 16 58 28 69 3 33 23 41 71 62 44 14 0;
%                10 3 33 51 8 62 44 53 23 41 58 28 10 0;];
pairElement=[2 1;2 2;1 1;1 1;1 1;];
cutoff=[0 3;0 4.3;2.4 3.4;2.4 3.4;2.4 3.4];
atomCharge=[-5.64/3 1.64 0];                    % atom charge 
oriMove=4.161;

fileNum=1:2;       
convertAtom=0;
neighbourList=[];            % The current file result
neighbourPair=centralAtom';  % The final result
%%
for i=fileNum
    
    % load position 
    [ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename(i,:));
    coordinate1=InsertAtomInfo(coordinate1,atom1,atom2,atom3);  
    
    % Correct boundary
    switch i
        case 1
            OrigCoor=coordinate1;
        case 2
            coordinate1=boundaryCorrect(OrigCoor,coordinate1,oriMove,b1/2);
        case 3
            coordinate1=boundaryCorrect(OrigCoor,coordinate1,oriMove,b1/2);
    end
    
    
    % find neighbours
    for j=1:size(centralAtom,2)
        currentNeighbour=FindNeighbours(coordinate1,centralAtom(j),pairElement(j,2),cutoff(j,:),a1,b1,c1);
        neighbourList(j,1:size(currentNeighbour,2))=currentNeighbour;
    end
    % cross checking and add data
    for j=1:size(neighbourList,1)
        for k=1:size(neighbourList,2)  % compare data
            pointer=1;
            if(isempty(find(neighbourPair(j,2:end)==neighbourList(j,k))))                
                for l=1:size(neighbourPair,2)   % Find the vancancy
                    if(neighbourPair(j,l)~=0)
                        pointer=pointer+1;
                    end
                end
                neighbourPair(j,pointer)=neighbourList(j,k);  % add data
            end            
        end
    end
    % cross checking and add data %%
end

%%


    % write file head
line=1;
pairStartLine=zeros(size(neighbourPair,1),1);
pairEndLine=pairStartLine;
for i=1:size(neighbourPair,1)
    result(line,1)={neighbourPair(i,1)};
    for k=fileNum
        result(line,((k-1)*3+2):(k*3+1))={['Length in file' num2str(k)],'Energy','%';};
    end
    pairStartLine(i)=line;
    line=line+1;
    for j=2:size(neighbourPair,2)
        if(neighbourPair(i,j)~=0)
            result(line,1)={neighbourPair(i,j)};        
            line=line+1;
        end
    end
    result(line:(line+4),1)={'sum';'Eadd';'Eleft';'Etransfer';'dE'};
    pairEndLine(i)=line-1;
    line=line+8;
end


    % convert atom number
neighbourPairConvert=neighbourPair;

    for i=1:size(pairElement,1)
        pairElement(i,3:size(neighbourPair,2))=pairElement(i,2);
    end
 if(convertAtom==1)   
    neighbourPairConvert=neighbourPair;
    [ ~,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename(1,:));
    neighbourPairConvert(find(pairElement==2))=neighbourPair(find(pairElement==2))+atom1;
    neighbourPairConvert(find(pairElement==3))=neighbourPair(find(pairElement==3))+atom1+atom2;
end
%----------------------------
% Main loop
% calculate distance and E

for i=fileNum
    [ coordinate1,atom1,atom2,atom3,a1,b1,c1 ]=loadPOSCAR(filename(i,:));
    coordinate1=InsertAtomInfo(coordinate1,atom1,atom2,atom3);    
    switch i
        case 1
            OrigCoor=coordinate1;
        case 2
            coordinate1=boundaryCorrect(OrigCoor,coordinate1,oriMove,b1/2);
        case 3
            coordinate1=boundaryCorrect(OrigCoor,coordinate1,oriMove,b1/2);
    end
    for k=1:size(neighbourPairConvert,1)
        for j=2:size(neighbourPairConvert,2)
            if(neighbourPair(k,j)~=0)
                distance=AtomDistance( coordinate1(neighbourPairConvert(k,1),1:3), coordinate1(neighbourPairConvert(k,j),1:3), a1, b1, c1 );
                energy=AtomicPotentialEnergy(distance, atomCharge(pairElement(k,1)), atomCharge(pairElement(k,j)) );
%                 if((pairStartLine+j-1)==26)
%                     disp('found')
%                     pause
%                 end
                result(pairStartLine(k)+j-1,(i-1)*3+2)={distance};
                result(pairStartLine(k)+j-1,(i-1)*3+3)={energy};
               
            end
        end
    end
end
%%
% calculate '%'
for i=2:size(result,1)
   for j=7:3:size(result,2)
       result(i,j)={cell2mat(result(i,j-1))./cell2mat(result(i,3))};
   end
end
result(pairStartLine,4:3:end)={'%'};
% calculate sum 
for i=1:size(pairEndLine,1)
    for j=3:3:size(result,2)
%         i
%         j
%         sum(cell2mat(result((pairStartLine(i)+1):(pairEndLine(i)+1),j)))
        result(pairEndLine(i)+1,j)={sum(cell2mat(result((pairStartLine(i)+1):(pairEndLine(i)+1),j)))};   
        %pause
    end
    
end

% Calculate dE
for i=1:size(pairEndLine,1)
    for j=6:3:size(result,2)   
        result(pairEndLine(i)+5,j)={cell2mat(result(pairEndLine(i)+1,j))-cell2mat(result(pairEndLine(i)+1,3))};
    end
    
end


% calculate Eadd Eleft Etransfer
for i=1:size(pairStartLine,1)    
    currentData=[];         % extraxt data
    currentData=cell2mat(result((pairStartLine(i)+1):pairEndLine(i),2:size(result,2)));
    for j=[1,3:3:size(currentData,2)]    % Identify status
        currentDistance=currentData(:,j);
        currentData(currentDistance<cutoff(i,2),j)=1;
        currentData(currentDistance>=cutoff(i,2),j)=0;
    end
    for j=3:3:size(currentData,2)
        Eadd=0;
        Eleft=0;
        Etransfer=0;
        for k=1:size(currentData,1)
            if(currentData(k,1)==1&&currentData(k,j)==1)
                Etransfer=Etransfer+currentData(k,j+1)-currentData(k,2);
            end
            if(currentData(k,1)==1&&currentData(k,j)==0)
                Eleft=Eleft+currentData(k,j+1)-currentData(k,2);
            end
            if(currentData(k,1)==0&&currentData(k,j)==1)
                Eadd=Eadd+currentData(k,j+1)-currentData(k,2);
            end
            if(currentData(k,1)==0&&currentData(k,j)==0)
                disp('Wrong data!');
                i
                j
                k
            end            
        end
        result(pairEndLine(i)+2,j+3)={Eadd};
        result(pairEndLine(i)+3,j+3)={Eleft};
        result(pairEndLine(i)+4,j+3)={Etransfer};
    end
    
end






