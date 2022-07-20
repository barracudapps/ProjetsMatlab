function I=cheese(L,radius,errorRequested,u)

r=radius;
er=errorRequested;
n=length(u);

I=0;
for i=1:n
    for j=1:n
        I=I+(L/n)^2*(1-u(i,j))/L^2;
    end
end


end