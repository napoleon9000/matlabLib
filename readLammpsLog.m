function data = readLammpsLog(filename, varargin)
% Read and plot log file from lammps
% data = readLammpsLog(filename)
% data = readLammpsLog(..., column1, column2, ....)

strData = readList(filename);
strData(1:2,:) = [];
data = str2num(strData);

if(nargin > 1)
    figure
    switch nargin
        case 2
            plot(data(:,varargin{1}))
        case 3
            plot(data(:,varargin{1}),data(:,varargin{2}))
        case 4
            plot(data(:,varargin{1}),data(:,varargin{2}),data(:,varargin{3}))               
            
    end
    
    
end
end




