% Generate
{ cycle(X,Y) : edge(X,Y) } = 1 :- node(X).
{ cycle(X,Y) : edge(X,Y) } = 1 :- node(Y).

% Define
reached(Y) :- cycle(start,Y).
reached(Y) :- cycle(X,Y), reached(X).

% Test
:- node(Y), not reached(Y).
:- not reached(start).         % assicura il ritorno a start

% Display
#show cycle/2.

% Nodes
node(start).        % San Giovanni Rotondo (punto di partenza)
node(1..6).        % Altri nodi da visitare

% Edges
edge(start, (1;2;3;4;5;6)).   % Da SGR posso andare ovunque - San Giovanni Rotondo
edge(1, (2;3;4;5;6)).         % Da Vieste posso andare agli altri (non SGR)
edge(2, (1;3;4;5;6)).         % Da Peschici posso andare agli altri (non SGR)
edge(3, (1;2;4;5;6)).         % Da Rodi posso andare agli altri (non SGR)
edge(4, (1;2;3;5;6)).         % Da San Domino posso andare agli altri (non SGR)
edge(5, (1;2;3;4;6)).         % Da San Nicola posso andare agli altri (non SGR)
edge(6, (1;2;3;4;5)).         % Da Monte Sant'Angelo posso andare agli altri (non SGR)
edge((1;2;3;4;5;6), start).   % Da tutti posso tornare a SGR


% Distance (in km, distanze reali in linea d'aria)
distance(start,1,55). distance(1,start,55).    % SGR-Vieste
distance(start,2,40). distance(2,start,40).    % SGR-Peschici
distance(start,3,30). distance(3,start,30).    % SGR-Rodi
distance(start,4,50). distance(4,start,50).    % SGR-San Domino
distance(start,5,53). distance(5,start,53).    % SGR-San Nicola
distance(start,6,25). distance(6,start,25).    % SGR-Monte Sant'Angelo

distance(1,2,20). distance(2,1,20).            % Vieste-Peschici
distance(1,3,33). distance(3,1,33).            % Vieste-Rodi
distance(1,4,80). distance(4,1,80).            % Vieste-San Domino
distance(1,5,83). distance(5,1,83).            % Vieste-San Nicola
distance(1,6,30). distance(6,1,30).            % Vieste-Monte Sant'Angelo

distance(2,3,13). distance(3,2,13).            % Peschici-Rodi
distance(2,4,60). distance(4,2,60).            % Peschici-San Domino
distance(2,5,65). distance(5,2,65).            % Peschici-San Nicola
distance(2,6,27). distance(6,2,27).            % Peschici-Monte Sant'Angelo

distance(3,4,47). distance(4,3,47).            % Rodi-San Domino
distance(3,5,50). distance(5,3,50).            % Rodi-San Nicola
distance(3,6,25). distance(6,3,25).            % Rodi-Monte Sant'Angelo

distance(4,5,3). distance(5,4,3).              % San Domino-San Nicola
distance(4,6,70). distance(6,4,70).            % San Domino-Monte Sant'Angelo

distance(5,6,70). distance(6,5,70).            % San Nicola-Monte Sant'Angelo


% Terrain factor (1=terra, 15=mare che rappresenta 1.5)
terrain(start,1,1). terrain(1,start,1).   % terra (SGR-Vieste)
terrain(start,2,1). terrain(2,start,1).   % terra (SGR-Peschici)
terrain(start,3,1). terrain(3,start,1).   % terra (SGR-Rodi)
terrain(start,4,15). terrain(4,start,15). % mare (SGR-San Domino)
terrain(start,5,15). terrain(5,start,15). % mare (SGR-San Nicola)
terrain(start,6,1). terrain(6,start,1).   % terra (SGR-Monte Sant'Angelo)

terrain(1,2,1). terrain(2,1,1).           % terra (Vieste-Peschici)
terrain(1,3,1). terrain(3,1,1).           % terra (Vieste-Rodi)
terrain(1,4,15). terrain(4,1,15).         % mare (Vieste-San Domino)
terrain(1,5,15). terrain(5,1,15).         % mare (Vieste-San Nicola)
terrain(1,6,1). terrain(6,1,1).           % terra (Vieste-Monte Sant'Angelo)

terrain(2,3,1). terrain(3,2,1).           % terra (Peschici-Rodi)
terrain(2,4,15). terrain(4,2,15).         % mare (Peschici-San Domino)
terrain(2,5,15). terrain(5,2,15).         % mare (Peschici-San Nicola)
terrain(2,6,1). terrain(6,2,1).           % terra (Peschici-Monte Sant'Angelo)

terrain(3,4,15). terrain(4,3,15).         % mare (Rodi-San Domino)
terrain(3,5,15). terrain(5,3,15).         % mare (Rodi-San Nicola)
terrain(3,6,1). terrain(6,3,1).           % terra (Rodi-Monte Sant'Angelo)

terrain(4,5,15). terrain(5,4,15).         % mare (San Domino-San Nicola)
terrain(4,6,15). terrain(6,4,15).         % mare (San Domino-Monte Sant'Angelo)

terrain(5,6,15). terrain(6,5,15).         % mare (San Nicola-Monte Sant'Angelo)

% Altitude
altitude(start,500). % San Giovanni Rotondo
altitude(1,40).      % Vieste
altitude(2,90).      % Peschici
altitude(3,40).      % Rodi Garganico
altitude(4,70).      % San Domino
altitude(5,70).      % San Nicola
altitude(6,700).     % Monte Sant'Angelo

% Altitude cost
alt_cost(X,Y,C) :- altitude(X,AX), altitude(Y,AY), 
                   C = |AX-AY|/100.

% Final cost = (distance * terrain_factor/10) * (1 + altitude_cost)
cost(X,Y,C) :- distance(X,Y,D), terrain(X,Y,T), alt_cost(X,Y,A),
               C = (D * T / 10) * (1 + A).

% Optimize
#minimize { C,X,Y : cycle(X,Y), cost(X,Y,C) }.