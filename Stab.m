% Jo?o Pacheco de Almeida, Decembre 9, 2018
% M?thode des d?placements pour un treillis 2D

% Vider variables, command window, et fermer tous les figures :
clear
clc
close all

%% INPUT
% Tous les param?tres qui doivent ?tre d?finies par l'utilisateur apparaissent dans cette section, et sont not?s par ? UTILISATEUR ?.
% Coordonn?es des noeuds [x,y] :       %% UTILISATEUR, en [mm]
coordonnees =  4*[0   0  
                5000  0
                10000 0
                2500   2500
                7500 2500
                5000   5000];
            
%  Nombre total de degr?s de libert? (ddl) :
no_ddl = length(coordonnees(:,1))*2;
ddl_no = 1:1:no_ddl;

% Matrice de connectivit? : un ?l?ment par ligne [noeud de d?part - noeud de fin]
connectivite = [1   2                        %% UTILISATEUR
                2   3
                1   4
                4   5
                2   4
                2   5
                3   5
                2   6
                4   6
                5   6];
             
% Nombre total d'?l?ments :
no_elem = length(connectivite(:,1));
             
% Degr?s de libert? fixes :
ddl_fixes_no = [1,2,5,6]; % fixed displacements         %% UTILISATEUR

% Degr?s de libert? libres :
ddl_libres_no = ddl_no;
ddl_libres_no(ddl_fixes_no)=[];

% Actions nodales (charges appliqu?es aux noeuds) :
P = zeros(no_ddl,1);
% Vecteur des charges nodales pour les degr?s de libert? libres :
P_f = [0;0;0;-10000;0;-10000;0;-10000];           %% UTILISATEUR, en [N]
P(ddl_libres_no) = P_f;

% Propri?t?s d?s ?l?ments :
E_treillis = ones(no_elem,1)*70000;   % Young modulus        %% UTILISATEUR, en [N/mm2]
A_treillis = ones(no_elem,1)*4000;    % Area                 %% UTILISATEUR, en [mm2]

% La variable suivante est juste utilis? pour le tra?age de la deform?e(pas int?r?t pour le cours SdC...)
scale_factor = 500; %'scale factor' pour le tra?age de la deform?e

%% CALCUL

% Initialization du vecteur des d?placements pour la structure (pour l'instant ?gal ? zero...):
U = zeros(size(P));
% On sait d?j? que le vecteur correspondant aux degr?s de libert? fixes et ?gal ? zero car il n'y a pas des d?placements impos?s :
U_d = U(ddl_fixes_no);

% Initialisation des matrices de rigidit? (de la structure et des ?l?ments dans les syst?mes de r?f?rence local et global) :
K_str = zeros(no_ddl,no_ddl);
k_elem_loc = zeros(2,2,no_elem);
k_elem_glob = zeros(4,4,no_elem);

% Initialization des matrices avec les longueurs des ?l?ments, matrice de rotation, matrice de compatibilit?, et matrice d'assemblage :
Longueur_elements = zeros(no_elem,1); % Matrice avec les longueurs des ?l?ments
r_C = zeros(2,4,no_elem);   % Matrice de compatibilit?
Matrice_Auxiliaire_Assemblage = zeros(no_elem,4); % Matrice d'assemblage: elle associe les ddls de la structure aux ddls des ?l?ments (syst?me global)

% Loop pour calculer les matrices avec les longueurs des ?l?ments, matrice de compatibilit?, et matrice d'assemblage: 
for i=1:no_elem
    % Matrices avec les longueurs des ?l?ments :
    Longueur_elements(i) = sqrt((coordonnees(connectivite(i,2),1)-coordonnees(connectivite(i,1),1))^2+(coordonnees(connectivite(i,2),2)-coordonnees(connectivite(i,1),2))^2);
    % Matrice de compatibilit?, [cos(theta) sin(theta) 0 0; 0 0 cos(theta) sin(theta)]:
    r_C(:,:,i) = 1/Longueur_elements(i)*[(coordonnees(connectivite(i,2),1)-coordonnees(connectivite(i,1),1)) (coordonnees(connectivite(i,2),2)-coordonnees(connectivite(i,1),2)) 0 0
                                       0 0 (coordonnees(connectivite(i,2),1)-coordonnees(connectivite(i,1),1)) (coordonnees(connectivite(i,2),2)-coordonnees(connectivite(i,1),2))];
    % Matrice auxiliaire d'assemblage :
    Matrice_Auxiliaire_Assemblage(i,:) = [connectivite(i,1)*2-1,connectivite(i,1)*2,connectivite(i,2)*2-1,connectivite(i,2)*2];
end

% Vecteur dont les coefficients correspondent ? la rigidit? EA/L de chaque barre du treillis :
k_barre = A_treillis .* E_treillis ./ Longueur_elements;

% Loop dans les ?l?ments de la structure pour calculer les matrices de rigidit? :
for elem = 1:no_elem
    % Calcul des matrices de rigidit? pour chaque ?l?ment dans les syst?mes de r?f?rence local et global, k_elem_loc et k_elem_glob :
    k_elem_loc(:,:,elem) = [k_barre(elem) -k_barre(elem)
                            -k_barre(elem) k_barre(elem)];
    k_elem_glob(:,:,elem) = r_C(:,:,elem)' * k_elem_loc(:,:,elem) * r_C(:,:,elem);
    % Assemblage de la matrice de rigidit? de la structure, K_str, en utilisant l'information dans la matrice auxiliaire d'assemblage 'Matrice_Auxiliaire_Assemblage' :
    for j=1:length(k_elem_glob(:,:,elem))
        for k=1:length(k_elem_glob(:,:,elem))
            K_str(Matrice_Auxiliaire_Assemblage(elem,j),Matrice_Auxiliaire_Assemblage(elem,k)) = K_str(Matrice_Auxiliaire_Assemblage(elem,j),Matrice_Auxiliaire_Assemblage(elem,k))+k_elem_glob(j,k,elem);
        end
    end
end

% Sub-matrice de rigidit? pour les degr?s de libert? libres :
K_ff = K_str(ddl_libres_no,ddl_libres_no) 
% Sub-matrice de rigidit? pour les degr?s de libert? fixes :
K_dd = K_str(ddl_fixes_no,ddl_fixes_no) 
% Sub-matrices de rigidit? K_fd et K_df :
K_fd = K_str(ddl_libres_no,ddl_fixes_no) 
K_df = K_fd'

% EQUATION AUX DEPLACEMENTS (calcul des deplacements, pour les degres de liberte libres) :
U_f = K_ff\(P_f - K_fd*U_d)

% On peut maintenant compl?ter le vecteur final des d?placements, pour tous les degr?s de libert? :
U(ddl_libres_no) = U_f;

% ?QUATION AUX R?ACTIONS (calcul des r?actions, pour les degr?s de libert? fixes) :
P_d = K_df*U_f + K_dd*U_d

% Mise ? jour du vecteur des forces nodales :
P(ddl_fixes_no) = P_d;

% Vecteur des forces r?sistantes de la structure :
P_r = K_str*U;

% Calcul des efforts int?rieurs : 
for i=1:no_elem
    u_local(:,i) = (r_C(:,:,i)) * U(Matrice_Auxiliaire_Assemblage(i,:)); % element forces in the local reference system
    p_local(:,i) = k_elem_loc(:,:,i) * u_local(:,i);
end

% Forces axiales :
N = p_local(2,:)'

%% TRA?AGE

N_rounded=round(N,-2);

% 1) Plot deformed shape

n_nodes=length(coordonnees(:,1));
adjacency=eye(n_nodes);

% Definition of adjacency matrix (check on gplot help for more info)
for i=1:no_elem
    adjacency(connectivite(i,1),connectivite(i,2))=1;
    adjacency(connectivite(i,2),connectivite(i,1))=1;
end

% Plot undeformed shape
gplot(adjacency,coordonnees,'k');hold on

% Plot deformed shape
d_plot=reshape(U,2,n_nodes)'*scale_factor;
gplot(adjacency,coordonnees+d_plot,'r:');hold on
h=findobj('type','line');
set(h,'linewidth',1)

% Plot nodes
plot(coordonnees(:,1),coordonnees(:,2),'ko','markersize',4,'markerfacecolor','k')
plot(coordonnees(:,1)+d_plot(:,1),coordonnees(:,2)+d_plot(:,2),'ro','markersize',4,'markerfacecolor','r')
axis equal
    
legendinfo={'Configuration initiale', ['Configuration deform?e, scale factor = ',num2str(scale_factor)]};
legend(legendinfo)

% 2) Plot axial forces

figure

% Plot undeformed shape
gplot(adjacency,coordonnees,'k');hold on
plot(coordonnees(:,1),coordonnees(:,2),'ko','markersize',4,'markerfacecolor','k')

% Define maximum aplitude of forces for plot purposes
max_force_amplitude=mean(Longueur_elements)/4;

% Scale all forces to have as maximum the predefined value
scale_factor=max_force_amplitude/max(abs(N));
scaled_N=N*scale_factor;

for i=1:no_elem
    cos_el=1/Longueur_elements(i)*(coordonnees(connectivite(i,2),1)-coordonnees(connectivite(i,1),1));
    sin_el=1/Longueur_elements(i)*(coordonnees(connectivite(i,2),2)-coordonnees(connectivite(i,1),2));
mat_plot_N=[coordonnees(connectivite(i,1),:);coordonnees(connectivite(i,1),:)+scaled_N(i)*[-sin_el,+cos_el];coordonnees(connectivite(i,2),:)+scaled_N(i)*[-sin_el,+cos_el];coordonnees(connectivite(i,2),:)];
plot(mat_plot_N(:,1),mat_plot_N(:,2),'r:','linewidth',2)
h=text((coordonnees(connectivite(i,1),1)+scaled_N(i)*[-sin_el]+coordonnees(connectivite(i,2),1)+scaled_N(i)*[-sin_el])/2,(coordonnees(connectivite(i,1),2)+scaled_N(i)*[cos_el]+coordonnees(connectivite(i,2),2)+scaled_N(i)*[cos_el])/2,[num2str(N_rounded(i)),'  N']);
set(h, 'rotation', rad2deg(acos(cos_el)))
set(h,'FontSize',12)
set(h,'Fontweight','bold')
end
    
title('FORCE AXIALES','fontweight','bold','fontsize', 16) 
xlabel('[mm]','fontweight','bold','fontsize', 16)
ylabel('[mm]','fontweight','bold','fontsize', 16)
axis equal