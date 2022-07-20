function []=AppTest()
% clear all
% close all
% clc
figure

A=[1 2 7];
B=[808470 812340 85340];
C=[5000 5042 5012];
D=[347 350 5];
E=[0 1 2 3];
F=[0 1 2 3];

X=0;
Y=0;
Z=0;

if length(A)>1
    for i=2:length(A)
        a=A(i)-A(i-1);
        b=B(i)-B(i-1);
        c=C(i)-C(i-1);
        d=D(i)-D(i-1);
        e=E(i)-E(i-1);
        f=F(i)-F(i-1);
        
        Z(1)=c/C(i);
        Z(2)=d/D(i)
        Z(3)=b/B(i);
        
        if length(X)>30
            X=[X(2:end) X(end)+1];
        else
            X=[X X(end)+1];
        end
        for i=1:length(Z)
            if isnan(Z(i))||~isreal(Z(i))||abs(Z(i))==inf
                Z(i)=0;
            end
        end
        W=Z(1)-Z(2)+Z(3)
        Y=[Y W]
        plot(X,Y(end-length(X)+1:end));
        pause(0.1)
    end
end

end