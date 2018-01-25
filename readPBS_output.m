function E = readPBS_output(filename,plotFlag)
% Read E from .o output file
% E = readPBS_output(filename,plotFlag)



%filename = 'F:\SPG\LiCoO2\cluster\clusterLi37Co6O26_3+\Li37Co6O26_3+.o37953423';

%plotFlag = 0;

% read file
if(~exist(filename,'file'))
    disp('No such file')
    pause
end

fileContent = readList(filename);
%fileContent = textscan(fid,'%c',-1,'Delimiter',{''},'MultipleDelimsAsOne',0);
fileContentStr = reshape(fileContent',1,size(fileContent,1)*size(fileContent,2));

%fileContentStr = fileContentStr';
% sparse
%%
pat = '\d\sF=\s([-+.E0-9]*)\d';
%fileContentStr = 'RMM: 197    -0.315806923592E+03   -0.45475E-02   -0.65896E-04 11361   0.349E-02    0.335E+00 RMM: 198    -0.315807853891E+03   -0.93030E-03   -0.21385E-04 11765   0.205E-02    0.324E+00 RMM: 199    -0.315808430349E+03   -0.57646E-03   -0.78470E-05 12186   0.137E-02    0.315E+00 RMM: 200    -0.315808123071E+03    0.30728E-03   -0.46988E-04 10208   0.398E-02   1 F= -.31580812E+03 E0= -.31580812E+03  d E =-.315808E+03  mag=     3.0809';
result = regexp(fileContentStr,pat,'match');
E = zeros(length(result),1);
for i = 1:length(result)
    Estr = result{i};
    E(i) = str2num(Estr(5:end)); 
    
end
if(plotFlag)
    figure
    box on
    
    plot(E,'.-','MarkerSize',20);
    title(filename)
    grid on
end