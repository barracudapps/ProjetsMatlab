function [force_bob] = bon_et_aimant(position_aimant, affichage)
% Le but de cette fonction est de donner la force s'exerçant sur la bobine
% pour une position donnée de l'aimant.

% position_aimant : vecteur à trois entrée donnant la position de l'aimant
%                   par rapport au centre de la bobine
% affichage       : Faut-il afficher les graphes? 1=oui, 0=non.

% force_bob : Vecteur à trois entrées donnant la force s'exerçant sur la bobine
%             pour NI = 1.

if affichage
    clc; 
    close all;
end

%% Géométrie du problème (A ADAPTER A VOTRE GEOMETRIE)
    % aimant
    forme = 'cyl'; % 'rect' ou 'cyl' selon que l'aimant soit rectangulaire ou cylindrique
    champ = 1.42; % [T]
    switch forme
        case 'cyl'
        % si cylindrique
        rayon = 0.9525/2; % [cm]
        hauteur = 0.9525/3; % [cm]
        volume = pi*rayon^2*hauteur;
        
        case 'rect'
        % si rectangulaire
        x_dim = 1; % [cm]
        y_dim = 1; % [cm]
        z_dim = 1; % [cm]
        volume = x_dim*y_dim*z_dim;
    end
    
    % discrétisation
    ech_aimant = [50 50 50]; % discrétisation de l'aimant dans les directions x, y et z.
    dipolar_momentum = 1.8e6*volume*champ; % Moment dipolaire total de l'aimant
    
    % loop
    rayon_bobine = rayon; % rayon de la bobine.
    ech_bobine = 500; % discrétisation de la bobine.
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
%% Discrétisation de l'aimant:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Ce bloc de code calcule la position de chacun des dipoles composant
% l'aimant.
    switch forme % Calcul des positions relative au centre
        case 'cyl'
            aimant = pos_rel_aim(forme, [rayon, hauteur], ech_aimant); 
        case 'rect'
            aimant = pos_rel_aim(forme, [x_dim, y_dim, z_dim], ech_aimant);
        otherwise
            disp('Problem, the shape of the magnet is not recognized')
    end
    aimant = bsxfun(@plus, aimant, position_aimant); % décalage du centre de l'aimant
    
    if affichage
        figure
        plot3(aimant(:,1),aimant(:,2),aimant(:,3),'.b')
        title('Discrétisation de l''aimant')
        xlabel('x'), ylabel('y'), zlabel('z');
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Discrétisation de la bobine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    [position_bobine orientation_bobine] = pos_rel_bob(rayon_bobine, ech_bobine);
    if(affichage)
        figure;
        pts1 = position_bobine-orientation_bobine/2;
        pts2 = position_bobine+orientation_bobine/2;
        plot3( [pts1(:,1), pts2(:,1)]', [pts1(:,2), pts2(:,2)]', [pts1(:,3), pts2(:,3)]', '.-r');
        title('Forme de la bobine discrétisée');
        xlabel('x'), ylabel('y'), zlabel('z');
    end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Affichage de l'arrangement étudié
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if affichage
        figure;
            plot3(aimant(:,1), aimant(:,2), aimant(:,3),'.b')
            hold on
            pts1 = position_bobine-orientation_bobine/2;
            pts2 = position_bobine+orientation_bobine/2;
            plot3( [pts1(:,1), pts2(:,1)]', [pts1(:,2), pts2(:,2)]', [pts1(:,3), pts2(:,3)]', '.-r');
            title('Structure étudiée');
            xlabel('x'), ylabel('y'), zlabel('z');
    end
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% computation of the magnetic field on each part of the loop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    B_elem = zeros(size(position_bobine));
    
    for iterator=1:size(position_bobine,1)
        [Bx, By, Bz] = dipolar_field(aimant, position_bobine(iterator,:), dipolar_momentum);
        B_elem(iterator,:) = [Bx, By, Bz];
    end
    
    % to plot the magnetic field along the loop
    if affichage
        figure;
        plot3([position_bobine(:,1); position_bobine(1,1)], ...
              [position_bobine(:,2); position_bobine(1,2)], ...
              [B_elem(:,3), B_elem(1,3)]);
        title('z-directed magnetic field along the loop')
        xlabel('x'), ylabel('y'), zlabel('B_z');
    end
    
    force_bob = B_to_F(B_elem, orientation_bobine);
    dflux      = B_to_dflux(B_elem, orientation_bobine); 
    
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% affichage des résultats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    disp('Force exercée sur la bobine :')
    f = force_bob;
    disp(['    F = (' num2str(f(1)) ', ' num2str(f(2)), ', ' num2str(f(3)) ')'])
    disp('Variation du flux :')
    disp(['    dphi = (' num2str(dflux(1)) ', ' num2str(dflux(2)), ', ' num2str(dflux(3)) ')'])
    disp(' ')
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FONCTIONS SUPPLEMENTAIRES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    
    

    function [magnet] = pos_rel_aim(shape, params, sampling)
    % return the position of each subdivision of the magnet relative to the
    % center of that magnet.
    % shape is the shape of the magnet: 'cyl' or 'rect'
    % params are the geometrical parameters of the magnet: [radius height] or
    %                           [length, width, height] depending on the shape
    % sampling is the sampling of the magnet in the x, y and z directions.

        switch shape
            case 'cyl'
                radius = params(1);
                height = params(2);
                % Discretization of the space
                x = 1.1*linspace(-radius, radius, sampling(1));
                y = 1.1*linspace(-radius, radius, sampling(2));
                z = linspace(-height/2, height/2, sampling(3)+1);
                    z = z+0.5*(z(2)-z(1));
                    z(end) = [];
                % use function repmat: repeats a matrix.
                x = repmat(x, 1, sampling(2)*sampling(3));
                    x = x(:);
                y = repmat(y, sampling(1), sampling(3));
                    y = y(:);
                z = repmat(z, sampling(1)*sampling(2), 1);
                    z = z(:);

                % eliminate the positions outside the magnet
                ind = (x.^2+y.^2)> radius^2;
                x(ind) = [];
                y(ind) = [];
                z(ind) = [];

            case 'rect'
                x_dom = params(1)/2;
                y_dom = params(2)/2;
                z_dom = params(3)/2;
                % Discretization of the space
                x = linspace(-x_dom, x_dom, sampling(1)+1);
                    x = x+0.5*(x(2)-x(1));
                    x(end) = [];
                y = linspace(-y_dom, y_dom, sampling(2)+1);
                    y = y+0.5*(y(2)-y(1));
                    y(end) = [];
                z = linspace(-z_dom, z_dom, sampling(3)+1);
                    z = z+0.5*(z(2)-z(1));
                    z(end) = [];
                % use function repmat: repeats a matrix.
                x = repmat(x, 1, sampling(2)*sampling(3));
                    x = x(:);
                y = repmat(y, sampling(1), sampling(3));
                    y = y(:);
                z = repmat(z, sampling(1)*sampling(2), 1);
                    z = z(:);

            otherwise
                disp('Error: the shape of the magnet is not recognized');        
        end
        magnet = [x,y,z];

    end


    function [loop_position loop_params] = pos_rel_bob(radius, sampling)
    % return the position and orientation of each subdivision of the loop
    % relative to its center
    % radius is the radius of the loop
    % sampling is the nb of pieces that the loop is decomposed into
    % loop_position is a Nx3 matrix containing the position of each part
    % loop_params is a Nx3 matrix containing the orientation and length of each
    %                                                       part of the loop

    % Note: it is possible to improve the accuracy to change the way the loop
    % is discretized, so that its width and height are taken into account

        theta = linspace(0,2*pi,sampling+1)';
        theta(end) = [];

        loop_position = radius*[cos(theta), sin(theta), zeros(size(theta))];

        zdir = zeros(size(loop_position));
            zdir(:,3) = 1;
        loop_params = 2*pi/sampling*cross(loop_position', zdir')';

    end

    function [Bx, By, Bz] = dipolar_field(r_source, r_rec, dipolar_momentum)
    % Renvoie le champ magnétique induit au point r_rec par des dipoles situé
    % au point r_source. "dipolar_momentum" est le moment dipolaire total de l'aimant.

    % r_source : Matrice Nx3. Chaque ligne représente les coordonnées d'une
    %            fraction de l'aimant.
    % r_rec    : vecteur 1x3 correspondant à la position du tronçon de
    %            boucle
    % dipolar_momentum : Moment magnétique total de l'aimant.
    
    % B = [Bx, By, Bz] : Champ magnétique total au niveau du tronçon de la bobine.

        m0 = dipolar_momentum/size(r_source,1); % moment magnétique partiel de chaque dipole
        temprec = repmat(r_rec,size(r_source,1),1);
        rayon = temprec - r_source;
        i = 0;
        N=size(r_source,1);
        B = [0,0,0];
        while i<N
            temp = (3*rayon(i,:)*dot(rayon(i,:),m0))/((norm(rayon(i,:))^5) - m0/((norm(rayon(i,:))^3);
            B=B+temp;
            i=i+1;
        end
        
        
        


    end

    
    function force_bob = B_to_F(B_elem, orientation_bobine)
        % Fonction calculant la force s'exerçant sur chaque element de la
        % bobine.
        
        % B_elem: Matrice Nx3 donc la ligne "i" contient le champ
        %         magnétique au niveau de l'élément "i" de la bobine
        % orientation_bobine : Matrice Nx3 dont la ligne "i" contient le
        %                      vecteur "orientation" de l'élément "i" de la
        %                      bobine
        
        % force_elems: Matrice Nx3 dont la ligne "i" contient la force
        %              s'exerçant sur l'élément "i" de la bobine.
        
        i = 1
        N = size(B_elem,1)
        F=[0 0 0]
        while i<N
            temp=cross(B_elem(i,:),orientation_bobine(i,:))
            F=F+temp
        end
        
        
    end

    


