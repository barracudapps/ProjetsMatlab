function [v error] = adjust(theta,cible,va,vb,tol,nmax,g)
%%  Written by Pierre LAMOTTE 654415-00
%   17-11-29

options=odeset('RelTol',1e-3,'AbsTol',1e-4,'Events',@event);

b=1;
i=0;
x=0;
y=0;

while b==1
    [T,U] = ode23(g,[0 100],[0 cos(theta)*va 0 sin(theta)*va],options);
    plot(U(:,1),U(:,3),'r');
    x=U(end,1);

    [T,U] = ode23(g,[0 100],[0 cos(theta)*vb 0 sin(theta)*vb],options);
    plot(U(:,1),U(:,3),'r');
    y=U(end,1);
    
    if x<cible && y>cible
        b=0;
    elseif x<cible && y<cible
        va = vb;
        vb=2*vb;
    elseif x>cible && y>cible
        vb=va;
        va=va/2;
    end
    i=i+2;
end

while i<nmax && abs(cible-x)>tol
    v=(va + vb)/2;
    [T,U] = ode23(g,[0 100],[0 cos(theta)*v 0 sin(theta)*v],options);
    plot(U(:,1),U(:,3),'r');
    x=U(end,1);
    
    if x<cible
        vb=2*v-va;
        va=v;
    else
        va=2*v-vb;
        vb=v;
    end
    i=i+1;
end

error = abs(cible-x);

end
function [value,isterminal,direction] = event(t,y)
    value = y(3);
    isterminal = 1;
    direction = -1;
end