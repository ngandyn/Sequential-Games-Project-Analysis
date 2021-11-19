% Andy Ng 301221017 CMPT417   
% Sequential Games variables:
int: K;                         % Goal K ∈ N;
int: num;                       %  Number n ∈ N of games;
set of int: games = 1..num; 
array [games] of int: fun;      % Fun value vi ∈ Z for each game i ∈ [n];
int: cap;                       % Pocket Capacity C ∈ N;
int: refill;                    % Refill amount R ∈ N;
set of int: x_range = 0..(cap + refill); 

array[games] of var int: tokens;
array[games] of var int: plays;



% The constraints on t and p are:

% 1. ∑i∈[n] pivi ≥ K:
constraint sum(i in games) (plays[i] * fun[i]) >= K;


% 2. The number of tokens t(i) available to play game i is C before the first game and for i >1 min{C, t(i-1) - P(i-1) +R}:
constraint (tokens[1] = cap) /\ 
forall(i in games)(
  (1<i /\ i<=num) -> exists(x in x_range)(
    (x = (tokens[i-1] - plays[i-1] + refill)) /\ 
    ((x > cap) -> (tokens[i] = cap)) /\
    ((x <= cap) -> (tokens[i] = x))
  )
);

% 3. We play each game at least once, and at most t(i) times
constraint forall (i in games)((1 <= i /\ i <= num) -> (1 <= plays[i] /\ plays[i] <= tokens[i]));

% 4. If the game is negative, only play it once max:
constraint forall (i in games) (fun[i] < 1 -> plays[i] = 1);

% 5. We play fun games not less than less fun games
constraint forall (i in games)(i > 1 /\ fun[i] > fun[i-1] -> plays[i] >= plays[i-1]);
constraint forall (i in games)(i > 1 /\ fun[i] < fun[i-1] -> plays[i] <= plays[i-1]);


% Result:
solve maximize sum(i in games)(plays[i] * fun[i]);
output ["number of games               " ++ show(num) ++ "\n" ++
        "fun for each games            " ++ show(fun) ++ "\n" ++ 
        "number of tokens in each game " ++ show(tokens) ++ "\n" ++ 
        "sequence of play               " ++ show(plays) ++ "\n" ++ 
        "total fun: " ++ show (sum(i in games)(plays[i] * fun[i]))] ;