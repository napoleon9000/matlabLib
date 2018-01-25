function POSCAR2data(varargin)
%% Convert POSCAR file to Lammps data structure file
% POSCAR2data(filename)
% POSCAR2data(filename,OutputFilename)

% filename = 'F:\SPG\LiCoO2\trainingSet\trainingSet_LiOLi2_MD\trainingSet_LiOLi\LiOLi-0.6-0.6-0.vasp';
filename = varargin{1};
if(nargin == 1)
    if(strcmp(filename(end-4:end),'.vasp'))
        outputfilename = [filename(1:end-4) 'data'];
    else
        outputfilename = [filename '.data'];
    end
elseif(nvargin == 2)
    outputfilename = varargin{2};
end
    
[ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename );
% convert element
commentLine(isspace(commentLine)) = [];
elecumsum = cumsum(atomNum);
element = ones(sum(atomNum),1);
for i = 1:(length(atomNum)-1)
    element((elecumsum(i)+1):elecumsum(i+1)) = i + 1;
end
% convert cell length
cellLength_lammps = [0 cellLength(1,1); 0 cellLength(2,2); 0 cellLength(3,3)];
writeLammpsDataDirect([commentLine 'eleName: ' elementName],sum(atomNum), length(atomNum), element, cellLength_lammps, 0, scallingFactor * coordinate1, outputfilename);