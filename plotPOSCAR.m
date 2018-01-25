function plotPOSCAR(filename, varargin)
%VIEWPOSCAR plot the atom structures of POSCAR file
%   plotPOSCAR(filename);
%   plotPOSCAR(cellLength,elementName,atomNum, coordinate1 );
if nargin == 1
    [ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename );
elseif nargin == 4
    cellLength = filename;
    elementName = varargin{1};
    atomNum = varargin{2};
    coordinate1 = varargin{3};
else
    disp('Number of inputs is wrong, paused.');
    pause
end

if(~any(coordinate1 > 1))
    coordinate1 = coordinate1*cellLength;
end

figure
hold on
atomNumTemp = [0 atomNum];
for i = 1:length(atomNum)
    plotAtomIdx = sum(atomNumTemp(1:i))+1:sum(atomNumTemp(1:i+1));
    scatter3(coordinate1(plotAtomIdx,1),coordinate1(plotAtomIdx,2),coordinate1(plotAtomIdx,3),50,'filled')
    

end
xlabel('a')
ylabel('b')
zlabel('c')
box on
grid on
box on

