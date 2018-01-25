% Fix the atom position within the radius of cutoffDistance from centerAtom
% in POSCAR file
% 20170117



clear;clc
filename = 'F:\SPG\LiCoO2\cluster\K1-re-constrained\structures\POSCAR_V7_CoO2';
centerAtom = [9.80440403 9.59335650 10.77159506];
cutoffDistance = 3;

[ commentLine,scallingFactor,cellLength,elementName,atomNum, coordinate1 ] = readPOSCAR( filename );
nearestDistance = AtomDistance( coordinate1, centerAtom, cellLength(1,1), cellLength(2,2), cellLength(3,3) );
fixAtomIdx = nearestDistance < cutoffDistance;
disp(['Num of fixed atoms: ' num2str(sum(fixAtomIdx))]);
% plotPOSCAR(cellLength,elementName,sum(fixAtomIdx), coordinate1(fixAtomIdx,:) );
% plotPOSCAR(filename)
POSCAR_file = readList(filename);
startPosi = regexp(POSCAR_file(:,1)','([CD])');
startPosi = startPosi(end);
fixFile = blanks(size(POSCAR_file,1));
fixFile = [fixFile' fixFile' fixFile' fixFile' fixFile'];
for i = 1:size(coordinate1,1)
    if(fixAtomIdx(i))
        fixFile(i + startPosi,:) = 'F F F';
    else
        fixFile(i + startPosi,:) = 'T T T';
    end
end
POSCAR_file = [POSCAR_file fixFile];
writeList([filename '-fix'],POSCAR_file);