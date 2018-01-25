function newFile = replaceLine(oldFile, lines, content)
%% Replace the whole line in a file with new content
% newFile = replaceLine(oldFile, lines, content)
% lines and content must have same number of rows

[r_old, c_old] = size(oldFile);
[r_content, c_content] = size(content);
if(c_content > c_old)
    oldFile = char(oldFile,content(1,:));
    oldFile(end,:) = [];
end
if(r_content > r_old)
    disp(['Line number out of range:' num2str(r_content) ' > ' num2str(r_old)])
    return
end
for i = 1:r_content
    oldFile(lines(i),1:c_content) = content(i,:); 
    oldFile(lines(i),c_content+1:c_old) = blanks(c_old-c_content); 
end
newFile = oldFile;
end