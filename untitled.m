function forestTest()

close all
Tstart = 0;
Tend   = 5e5;
Ustart = [1e8 20];
n = 5e2;
[T,U] = forest(Tstart,Tend,Ustart,n);

figure
subplot(2,1,1)
plot(T/365,U(:,1),'b')
title('Wood in the forest ')
xlabel('Time [years]')
ylabel('Global wood mass [kg]')
subplot(2,1,2)
plot(T/365,U(:,2),'r')
title('Population')
xlabel('Time [years]')
ylabel('Population')

figure
plot(U(:,1),U(:,2));
xlabel('Global wood mass [kg]')
ylabel('Population')


finalValue = U(end,1);
    
end

function [X,U] = forest(Xstart,Xend,Ustart,n)


a = 2e-5;    % croissance naturelle de la foret [day^(-1)]
b = 1e-8;    % impact de la population sur la foret [people^(-1)*day^(-1)] 
             % (fraction de la foret consomme par habitant)
c = 6e-5;    % décroissance de la population en absence de bois [day^(-1)]
d = 7e-13;   % impact du bois sur la population [kg^(-1)*day^(-1)]
             % (avoir du bois a consommer augmente la population)

%
% En incluant la fonction du modele de Lotka-Volterra comme une
% sous-fonction, il n'est pas necessaire de declarer les parametres du
% modele comme des variables globale :-)
%
 
    h = (Xend-Xstart)/n;
    X = linspace(Xstart,Xend,n+1);
    U = [Ustart ; zeros(n,2)];
    for i=1:n
         K1 = f(X(i),   U(i,:)     );
         K2 = f(X(i)+h, U(i,:)+h*K1);
         U(i+1,:) = U(i,:) + h*(K1+K2)/2;    
    end

    function dudx = f(x,u)
        dudx = u;
        dudx(1) = u(1)*(a-b*u(2));;
        dudx(2) = u(2)*(-c+d*u(1));
    end


end