clear;clc
filename = 'currentJob.txt';
fwLpadName = 'my_launchpad.yaml';

fileContent = readList(filename);
fileContentStr = fileContent';
fileContentStr = fileContentStr(:)';

expr = 'exec_host = (.*)/0-9';
nodeNameReg = regexp(fileContentStr,expr,'tokens');
nodeName = nodeNameReg{1}{1};

fwLpadFile = char(['host: ' nodeName],...
                   'port: 27017',...
                   'name: fireworks',...
                   'username:',...
                   'password:',...
                   'logdir: null',...
                   'strm_lvl: INFO');
               
writeList(fwLpadName,fwLpadFile);