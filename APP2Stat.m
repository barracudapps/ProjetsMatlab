function[] = APP2Stat()
clc
clear all
close all

filename = 'Data_APP2.txt';
delimiterIn = ';';
headerlinesIn = 1;
A = importdata(filename,delimiterIn,headerlinesIn);

Y = A.data(:,1);
X = A.data(:,2);
Z = A.data(:,3);

alpha = 0.05;
n = length(Y);
k = 3;

%%
% Let us first get samples corresponding to each value of Z
y1 = []; y2 = []; y3 = [];
x1 = []; x2 = []; x3 = [];
for i=1:length(Z)
    if(Z(i) == 1)
        y1 = [y1 Y(i)];
        x1 = [x1 X(i)];
    elseif(Z(i) == 2)
        y2 = [y2 Y(i)];
        x2 = [x2 X(i)];
    else
        y3 = [y3 Y(i)];
        x3 = [x3 X(i)];
    end
end
maxSzeY = max(length(y1),max(length(y2),length(y3)));
maxSzeX = max(length(x1),max(length(x2),length(x3)));

sigSY1 = var(y1);
sigSY2 = var(y2);
sigSY3 = var(y3);

% Let Yi and Xi denote respectively mean values of yi and xi samples
Y1 = mean(y1); Y2 = mean(y2); Y3 = mean(y3);
X1 = mean(x1); X2 = mean(x2); X3 = mean(x3);
meanY = sum(Y)/n;
meanX = sum(X)/n;

% H0 : Y does not depend on Z >> mu1 = mu2 = mu3
SST = length(y1)*(Y1 - meanY)^2+length(y2)*(Y2 - meanY)^2+length(y3)*(Y3 - meanY)^2;
SSE = sum((y1 - Y1).^2)+sum((y2 - Y2).^2)+sum((y3 - Y3).^2);
F = (SST/SSE)*((n - k)/(k - 1));
for i=length(y1)+1:maxSzeY
    y1 = [y1 NaN];
end
for i=length(y2)+1:maxSzeY
    y2 = [y2 NaN];
end
for i=length(y3)+1:maxSzeY
    y3 = [y3 NaN];
end
for i=length(x1)+1:maxSzeX
    x1 = [x1 NaN];
end
for i=length(x2)+1:maxSzeX
    x2 = [x2 NaN];
end
for i=length(x3)+1:maxSzeX
    x3 = [x3 NaN];
end
pVal = anova1([y1' y2' y3'],{'Machine 1' 'Machine 2' 'Machine3'})

figure
plot(sort(log(x1)),sort(y1),'r',sort(log(x2)),sort(y2),'g',sort(log(x3)),sort(y3),'m');
title('Relation between X and Y');
xlabel('Electricity consumption [MWh]');
ylabel(['Productivity [k' char(8364) '/day]']);
legend({'Machine 1','Machine 2','Machine 3'},'Location','southeast');

end