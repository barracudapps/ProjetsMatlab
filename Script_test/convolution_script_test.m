% CONVOLUTION_SCRIPT_TEST est un script permettant de tester la fonction
% convolution avec differents inputs, 1D ou 2D.
% 
%   Un script similaire sera utilise pour tester votre fonction et comparer
%   les outputs avec ceux attendus.
% 
% Requirements: 
%  * convolution.m
%  * noyau_audio.mat
%  * signal_audio.mat
%  * hall.mat
%  * cameraman.mat
%  * noyau_image01.mat
%  * noyau_image02.mat
%  * noyau_image03.mat
% 
% See also convolution conv conv2
% 
% Auteur(s) : PAIRET Benoit et GUERIT Stephanie
% NOMA(s)   : 112358-13 et 014916-25
% Groupe    : #StevinA.178


%% Exercice 2.2(a)
%  ===============
%  Vous pouvez tester avec d'autres exercices du syllabus pour valider
%  votre fonction.

x       = [1,2,1,1,2,1];
x_start = -5; 
y       = [-1,0,1,2];
y_start = -1; 
plotFig = true;

[z,z_start] = convolution(x,x_start,y,y_start,plotFig);

% %% Signal audio : aide DJ Beni à composer le hit de l'été !
% %  ========================================================
% %  Cette section va tester votre fonction sur un signal audio (signal_audio.mat)
% %  convolué par un noyau (noyau_audio.mat). Ecoutez le signal avant et
% %  après la convolution : est-ce coherent avec la forme de noyau que vous
% %  observez ?
% %  Pensez-vous que DJ Beni a de l'avenir ?
% 
% %  Lecture du signal audio
% %  -----------------------
% load signal_audio.mat
% x       = x(:,1)';
% x_start = 1;
% 
% % sound(x,Fs)
% % pause(6) % Pause de 6 sec pour entendre le son avant de continuer l'execution du code
% 
% %  Importation du noyau 1 : echos
% %  ------------------------------
% load noyau_audio.mat
% 
% y_start = 1;
% y       = y(:,1)';
% 
% %  Convolution
% %  -----------
% [z,~] = convolution(x,x_start,noyau_audio,y_start,false);
% 
% sound(x,Fs)
% pause(6)
% sound(z,Fs)
% pause(6)
% 
% 
% %% Signal audio : La réponse impulsionnelle d'un hall.
% %  ========================================================
% %  Cette section va tester votre fonction sur un signal audio (audio.m4a)
% %  convolué par un noyau qui correspond à la réponse impulsionnelle d'un hall.
% %  Ecoutez le signal avant et après la convolution : est-ce coherent avec la 
% %  forme de noyau que vous observez ?
% %  Le noyau vient de https://fokkie.home.xs4all.nl/IR.htm#PCM60 , vous
% %  pouvez voir comment l'auteur a estimé la réponse impulsionnelle de
% %  différents endroits de la vie de tous les jours.
% %
% load hall.mat
% 
% y = y/7; % on diminue l'amplitude du noyau pour la qualite du son
% y  = y(1:50000); % on ne prend que le debut de la reponse impulsionnelle 
% y_start = 1;
% 
% [z,~] = convolution(x,x_start,y,y_start,false);
% 
% sound(x,Fs)
% pause(6)
% sound(z,Fs)
% 
% 
% %% Convolution 2D : ou comment trafiquer les images...
% %  ===================================================
% %  Cette section teste votre fonction dans le cas d'une convolution 2D
% %  entre une image (cameraman.mat) et trois noyaux
% %  (noyau_image01.mat, load noyau_image02.mat et noyau_image03.mat). 
% %  Pour les images, l'output z_start, n'est pas nécessaire : vous pouvez
% %  renvoyer un element vide par exemple.
% 
% %  Ouverture de l'image et des noyaux
% %  ----------------------------------
% load cameraman.mat
% 
% load noyau_image01.mat
% load noyau_image02.mat
% load noyau_image03.mat
% 
% [z1,~] = convolution(x,[],noyau_image01,[],true);
% [z2,~] = convolution(x,[],noyau_image02,[],true);
% [z3,~] = convolution(x,[],noyau_image03,[],true);