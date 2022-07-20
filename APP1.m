function[] = APP1()
clc
close all

n = 100;
a = 0;
i = 0;
x = speye(n,1);

% for j=1:n
%     while a<(8*60)
%         i = i+1;
%         a = a+random('gamma',5,3);
%     end
%     x(j) = i-1;
%     i = 0;
%     a = 0;
% end
% 
% mean = sum(x)/n;
% var = sum((x-mean).^2)/(n-1);
% stdDev = sqrt(var);
% quantile(x,[0.05 0.95]);
% figure;
% histogram(x);
% 
% n = 1000;
% for j=1:n
%     while a<(8*60)
%         i = i+1;
%         a = a+random('gamma',5,3);
%     end
%     x(j) = i-1;
%     i = 0;
%     a = 0;
% end
% 
% mean = sum(x)/n;
% var = sum((x-mean).^2)/(n-1);
% stdDev = sqrt(var);
% quantile(x,[0.05 0.95]);
% figure;
% histogram(x);
% 
% n = 1000000;
% for j=1:n
%     while a<(8*60)
%         i = i+1;
%         a = a+random('gamma',5,3);
%     end
%     x(j) = i-1;
%     i = 0;
%     a = 0;
% end
% 
% mean = sum(x)/n
% var = sum((x-mean).^2)/(n-1)
% stdDev = sqrt(var)
% quantile(x,[0.05 0.95])
% figure;
% histogram(x);hold on
% 
% GX = 20:0.1:45;
% GY = gamcdf(GX,160,0.2);
% GY2 = gampdf(GX,160,0.2);
% figure;
% plot(GX,GY,'LineWidth',2);hold on
% plot(GX,GY2*10,'LineWidth',2);
% 
% for i=1:1000
%     x = 0:480;
%     alpha = (480-x)/3;
%     beta = 0.2;
%     f = (exppdf(x,180)).*(gampdf(20,alpha,beta));
%     = sum(f);
%     figure;
%     plot(x,f)
%     I/10+0.9*gampdf(20,160,0.2)
% end

i=0;
for x =0:100000
    i=i+x*gampdf(x,160,0.2);
end
i

end