clf
clear
clc
hold on
for i=0:0.05:1
    for j=0:0.05:1
        for k=0:1:10
            x=k+i;
            y=j;
            colorValue=[k/10 i j];
            plot(x,y,'color',colorValue,'Marker','.','MarkerSize',25)
        end
    end
end