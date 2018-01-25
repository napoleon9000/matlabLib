load('Distribution1.mat');
load('Distribution2.mat');
load('Distribution3.mat');
load('Distribution4.mat');
load('Distribution5.mat');
DisDistribution=Distribution5-Distribution4;

hold on
%cutOff=5;
if(sum(DisDistribution(:,1)==0)<size(DisDistribution,1))
    plot([0:HistRes:cutOff],DisDistribution(:,1),'r')
end
if(sum(DisDistribution(:,2)==0)<size(DisDistribution,1))
    plot([0:HistRes:cutOff],DisDistribution(:,2),'g')
end
if(sum(DisDistribution(:,3)==0)<size(DisDistribution,1))
    plot([0:HistRes:cutOff],DisDistribution(:,3),'b')
end
legend('O-O','Ca-Ca','Ca-O')
axis([0 6 -15 15])
title('5-4');