function [U Ubouncing] = bouncingBall(dt,Ustart,g,m,k)
%%  Ce problème a été résolu avec l'aide de plusieurs étudiants de BAC2 et
%   BAC3 et s'inspire fortement de la solution au problème n°6 de 2015-2016

U=Ustart;
i=1;
x=U(1);
y=U(2);

% Application de la méthode de Heun pour déterminer U en vérifiant la
% condition que la position de la balle est à l'intérieur du domaine
while(sqrt((x^2)+(y^2))<=1)
    K1 = f(U(i,:));
    K2 = f(U(i,:) + dt*K1);
    U(i+1,:) = U(i,:) + dt*(K1+K2)/2;
    U(i+1,end) = U(i,end)+dt;
    x=U(i+1,1);
    y=U(i+1,2);
    i=i+1;   
end

% Force l'arrêt de l'exécution de la fonction car c'est signe d'erreur
if i==1
    return
end

% Détermination analytique des racines
h=U(i,1) - U(i-1,1);
a = (U(i,2) - U(i-1,2))/h;
b = U(i-1,2) - (U(i,2) - U(i-1,2))/h * U(i-1,1);
B=2*a*b;
root = sqrt(B^2 - 4*(a^2+1)*(b^2-1));
denom=(2*(a^2+1));
rac1 = (-B + root)/denom;
rac2 = (-B - root)/denom;

if (abs(U(i,1)-rac1) <= abs(U(i,1)-rac2))
    U(i,1) = rac1;
    if (U(i-1,2) >= 0)   
        U(i,2) = sqrt(1-rac1^2);
    else   
        U(i,2)= -sqrt(1-rac1^2);
    end
else
    U(i,1) = rac2;
    if (U(i-1,2) >= 0)   
        U(i,2) = sqrt(1-rac2^2);
    else   
        U(i,2)= -sqrt(1-rac2^2);
    end
end 

bounce = Bounce(U(end,1),U(end,2),U(end,3),U(end,4));
Ubouncing = [ U(end,1) U(end,2) bounce(1) bounce(2) U(end,5)+dt ];

function [b1 b2] = Bounce(x,y,v,w)
    alpha = atan2(y,x);
    if alpha < 0
        alpha = alpha + 2*pi;
    end
    beta = atan2(w,v);
    if beta < 0
        beta = beta + 2*pi;
    end
    gamma = 2*(alpha-beta);
    rot = [cos(gamma) -sin(gamma); sin(gamma) cos(gamma)];
    b1 = -rot*[v;w];
    b2 = -rot'*[b1(1); -b1(2)];
end
function u2 = f(u)      
    u2 = zeros(size(u));
    u2(1) = u(3);
    u2(2) = u(4);
    u2(3) = -k*u(3)/m;
    u2(4) = -(m*g + k*u(4))/m;    
end
end

