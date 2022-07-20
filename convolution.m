function [z,z_start]=convolution(x,x_start,y,y_start,plotFig)
% CONVOLUTION est une fonction déterminant le produit de convolution entre deux signaux entres en argument 
% 
%   Par le calcul matriciel, la fonction CONVOLUTION determine et renvoie le produit
%   de convolution entre les deux matrices passees en argument de la
%   fonction. Elle renvoie egalement une figure (si plotFig est initialise a 1)
%   affichant le produit de convolution.
% 
% Inputs : 
%  * x est une matrice possedant les informations du premier signal;
%  * y est la matrice contenant les informations du second signal;
%  * x_start et y_start determinent l'emplacement du premier element non nul de x et y,
%  respectivement; Ils peuvent être vides dans le cas bidimensionnel;
%  * plotFig determine si la figure de convolution doit être affichee (1) ou non
%  (0).
% 
% Outputs : 
%  * z est la matrice resultant de la convolution des signaux d'entree;
%  * z_start indique le debut du support de z et peut être vide dans le cas
%  bidimensionnel.
% 
% Auteur(s) : Pierre LAMOTTE.
% NOMA(s)   : 654415-00.
% Groupe    : 42.

[K L] = size(x);                                    % Recuperation des dimensions des matrices pour determiner le type de convolution
[M N] = size(y);
A = 0;
z_start = 0;

if(M == 1) && (K == 1)                              % Determination de la convolution unidimensionnelle
    z = conv(x,y);
    z_start = y_start+x_start;                      % Determination de l'emplacement du premier element non nul de la convolution
else                                                % Determination de la convolution pluridimensionnelle
    A = 1;
    z = conv2(x,y);
end

if(plotFig == 1)                                    % Affichage de la figure si demande
    figure
    if (A == 0)
        stem([z_start:z_start+length(z)-1],z);
    else
        imagesc(z);
    end
    title(sprintf('Convolution x*y'),'FontSize',23);
    xlabel('n','FontSize',15);
    ylabel('Z(n)','FontSize',15);
end

end