function [I error num denom] = newtonCotes(f,C,a,b,m,n)
% newtonCotes numerically evaluates the integral of a function f between a
% and b.
%   [I error num denum] = newtonCotes(f,C,a,b,m,n)
% 
%   INPUTS
%   f is a mathematical function.
%   C is the constant used to determine the value of error.
%   a is the lower value of the function on the x-axis.
%   b is the uppur value of the function on the x-axis.
%   m is the degree of the function.
%   n is the number of subintervals between a and b.
%
%   OUTPUTS
%   I is the integral of the function f between a and b obtained by the
% Newton-Cotes method.
%   error is the maximal value of the possible error between the
% Newton-Cotes' method and the real value of the integral.
%   num is the value of alpha variable in the error's expression.
%   denum is beta's value in the error's expression.
%
%   USE
%   The newtonCotes function calculates the integral of any function
%   between 2 points on the x-axis. It shows the maximum error value and
%   gives it's expression.
%
% LAMOTTE Pierre
% Groupe 1257
% 16.10.30

    % Les numerateurs et denominateurs sont ceux issus d'internet et ne
    % correspondent pas aux valeurs reelles, une adaptation est necessaire
    switch m
        case 1,    w = [1 1]'/2; num = 1; denom = 2;
        case 2,    w = [1 4 1]'/6; num = 1; denom = 90;
        case 3,    w = [1 3 3 1]'/8; num = 3; denom = 180;
        case 4,    w = [7 32 12 32 7]'/90; num = 8; denom = 945;
        case 5,    w = [19 75 50 50 75 19]'/288; num = 275; denom = 12096;
        case 6,    w = [41 216 27 272 27 216 41]'/840; num = 9; denom = 1400;
        case 7,    w = [751 3577 1323 2989 2989 1323 3577 751]'/17280; num = 8183; denom = 518400;
        case 8,    w = [989 5888 -928 10496 -4540 10496 -928 5888 989]'/28350; num = 2368; denom = 467775;
        case 9,    w = [2857 15741 1080 19344 5778 5778 19344 1080 15741 2857]'/89600; num = 173; denom = 14620;
        case 10,   w = [16067 106300 -48525 272400 -260550 427368 -260550 272400 -48525 106300 16067]'/598752; num = 1346350; denom = 326918592;
        otherwise, w = 0;
    end
    
    % Fonction servant au calcul integral
    X=linspace(a,b,n*m+1);                          % Determination des abscisses a utiliser
    u=f(X);                                         % Calcul des images
    I=0;
    for i=1:n                                       % Boucle faisant la somme de 1 a n du produit des poids des intervalles et des images des abscisses liees
        I=I+dot(u((1+m*(i-1)):(1+i*m)),w)*(b-a)/n;  % Produit scalaire entre le poids et les images correspondant a l'intervalle etudie (trouve avec l'aide de Cyrille Sepulchre)
    end
    
    % Fonction determinant l'erreur d'intepolation maximale
    d=0;
    g=m+1;
    h=(b-a)/(n*m);                                  % Pas de la fonction
    if (mod(g,2)==0)                                % Determine l'ordre de la fonction
        d=g;
    else
        d=g+1;
    end
    denom=denom/(m*n);                              % Rectification de la valeur du beta tire d'internet
    error=(num*C*(b-a)*(h^d))/denom;
    
end