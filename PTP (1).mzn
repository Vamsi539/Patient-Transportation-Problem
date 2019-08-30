include "globals.mzn";

%----Parameters----
bool: sameVehicleBackward;
int: num_patients;
int: num_vehicles;
set of int: vehicles = 1..num_vehicles;
array[vehicles] of int: vehicles_id;
int: num_categories;
array[vehicles, 1..num_categories] of 0..1: vehicles_categories;
array[vehicles] of int: vehicles_start_depot;
array[vehicles] of int: vehicles_end_depot;
array[vehicles] of int: vehicles_capacity;
array[vehicles] of int: vehicles_start_time;
array[vehicles] of int: vehicles_end_time;
int: num_trips;
set of int: trips = 1..num_trips;
array[trips] of int: trips_id;
array[trips] of int: trips_start_pos;
array[trips] of int: trips_end_pos;
array[trips] of int: trips_category;
array[trips] of int: trips_load;
array[trips] of int: trips_start_time;
array[trips] of int: trips_end_time;
array[trips] of int: trips_emb_dis_time;
int: num_places;
array[1..num_places, 1..num_places] of int: distMatrix;





%----Pre-computed parameters----


%----Decision Variables----
array[trips] of var 0..num_vehicles: V;
array[trips] of var 0..1440: S;
array[trips] of var 0..1440: E;
array[trips] of var 0..1440: D;
array[trips] of var 0..1: X;

%----Constraints----
constraint forall(t in trips)(D[t] = E[t] -S[t]);
constraint forall(v in vehicles)(cumulative(S, D , trips_load,vehicles_capacity[v]));

%case 1
%constraint forall(i in trips, j in trips)(E[i]-S[j] >= distMatrix[S[j],E[i]]);
%constraint forall(i in trips, j in trips)(S[j]-S[i] >= distMatrix[S[i],S[j]]);
%constraint forall(i in trips, j in trips)(E[j]-E[i] >= distMatrix[E[i],E[j]]);

%case 2

%constraint forall(i in trips, j in trips)((E[i]-S[j]) + distMatrix[E[i],S[j]] + (E[j]-S[j]) >= E[j]-S[i]);
%constraint forall(i in trips, j in trips)(distMatrix[E[i],S[j]] + (E[i]-S[i]) <= S[j]-S[i]);
%constraint forall(i in trips, j in trips)(distMatrix[E[i],S[j]] + (E[j]-S[j]) <= E[j]-S[i]);

%case 3


constraint forall(i in trips, j in trips)((E[i]-S[j]) + (E[j]-S[j]) >= E[j]-S[i]);
constraint forall(i in trips, j in trips)((E[i]-S[i]) - distMatrix[S[j],E[i]] >= E[j]-S[i]);
constraint forall(i in trips, j in trips)(E[i]-S[j] >= distMatrix[E[j],S[j]] + (E[j]-S[j]));

solve satisfy;


%----Output----
