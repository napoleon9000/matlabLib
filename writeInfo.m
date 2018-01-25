function writeInfo( varargin )
%WRITEINFO write info file
%   writeInfo( filename, content )
%   writeInfo( filename, iterm, value )

if(nargin == 2)
    filename = varargin{1};
    content = varargin{2};
elseif(nargin == 3)
    filename = varargin{1};
    iterm = varargin{2};
    value = varargin{3};
    content = '';
    for i = 1:length(iterm)
        content = char(content,[iterm{i,1} ',' num2str(value(i))]);
    end
    content(1,:) = [];
else
    disp('Wrong number of input')
end
writeList(filename, content);    
end

