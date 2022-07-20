function[pu]=approx(X,Y,U)
%% APPROX Function solving an equation by least mean square
%       pu = approx(X,Y,U) gives a vector containing the solution of the
%           Jacobian tensor equalised to zero
%       - X,Y and U : coordinates of a cloud of dots in a
%           three-dimensional marker and must be of the same size
%
%   © Pierre LAMOTTE 65441500

A=[X*X' X*Y' sum(X);X*Y' Y*Y' sum(Y);sum(X) sum(Y) 1];  % Creation du tenseur Jacobien contenant le developpement des carres des distances
b=[X*U' Y*U' sum(U)]';                                  % Solution du tenseur Jacobien
pu=A\b;                                                 % Tenseur verifiant l'equation A*pu=b
end