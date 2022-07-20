function[uh]=trigonometric(x,n,U)
%% TRIGONOMETRIC Function used to interpolate an other function using complex values
%       uh = trigonometric(x,n,U) gives a matrix containing the ordonates
%           values corresponding to x abscissa and interpolating data
%           contained in U
%       - x : Abscissa wanted to be associated to ordinates given by uh
%       - n : Degree of the function wanted to be created
%       - U : Ordinates of the function wanted to be interpolated
%           by which uh need to pass
%
%   © Pierre LAMOTTE 65441500

K=[-n:n];                               % Determination des valeurs de K, abscisses liees a U
F=exp(i*K.*((2*pi/(2*n+1))*[0:2*n]'));  % Creation de la matrice contenant la fonction a coefficient inconnu
uh=real((exp(i*K.*x))*(F\U));           % Formation des ordonnees associees aux valeurs de x avec les coefficients determines par F\U
end