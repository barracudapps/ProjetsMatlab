function[]=Complexes2()

close all;

%%%%%%%%%%%%%%
% Exercice 2 %
%%%%%%%%%%%%%%

figure
z = cplxgrid(40);
cplxmap(z, log(1+sqrt(z.^2+1)));

%%%%%%%%%%%%%%
% Exercice 3 %
%%%%%%%%%%%%%%

figure
z = cplxgrid(40);
cplxmap(z, log(i*z+sqrt(1-z.^2))/i);

%%%%%%%%%%%%%%
% Exercice 6 %
%%%%%%%%%%%%%%

for n=1:5
    figure
    z = cplxgrid(40);
    cplxmap(z, z.^n);hold on
end

end