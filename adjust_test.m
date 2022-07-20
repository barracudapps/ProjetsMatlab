function adjust_test()
  warning('off') 
%
% Sous Octave, l'arret d'ode23 avec l'option Events 
% provoque un warning intempestif : c'est pourquoi
% nous avons ajoute cette ligne de code inutile sous MATLAB
%  
  close all;  
%
% Recherche de la valeur de la norme de la vitesse en encadrant
% entre deux valeurs rabitraire 100 et 2000
% Tolérance pour la précision 0.01
% Nombre maximum d'iterations : 50
%
 
  theta = pi/4; cible = 35;
  va = 100; vb = 2000; tol = 0.01; nmax = 50;
%
% -1- Le debut de la figure...
%     a completer dans la solution en dessinant 
%     chaque tir pendant l'ajustage !
%
  figure();
  set(gcf,'Color',[1 1 1]);
  plot([cible cible],[0 40],'-g','LineWidth',2); hold on;
  xlabel('distance [m]');
  ylabel('hauteur [m]');
  axis equal
%
% -2- Ajustage par la technique de bissection
%     ... ou une option aussi robuste et plus rapide (pas evident !)
%     Donc, faites gentiment la bissection sauf si vous etes 
%     un petit genie inconnu !
%
%     Pour info, le code de la methode de la bissection
%     se trouve dans les transparents du cours 9 :-)
%
  [v error] = adjust(theta,cible,va,vb,tol,nmax,@g);
  fprintf('\n Final value : v = %4.0f m/s ',v);

end


function dudx = g(x,u)
  dudx = u;
  frott =  0.1 * sqrt(u(2)*u(2) + u(4)*u(4));
  dudx(1) = u(2);
  dudx(2) = -frott * u(2);
  dudx(3) = u(4);
  dudx(4) = -9.81 - frott * u(4);
end
