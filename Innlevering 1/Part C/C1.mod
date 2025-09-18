set R;                   #set of regions
set F;                   #set of facilities
set K;                   #set of markets
 
param CX {R, F};         #cost of sending milk from region r to facility f
param CY {F, K};         #cost of shipping milk from facility f to market k
param Q {R};             #amount of obtainable milk from a region
param Y {F};             #amount of processable milk at a facility
param Z {K};             #amount of demand in a market

var x {R, F} >= 0;       #tons of milk sent from region r to facility f
var y {F, K} >= 0;       #tons of milk shipped from facility f to market k

minimize total_costs:    #objective function, minimization of total costs
	sum{r in R, f in F}x[r,f]*CX[r,f] + sum{f in F, k in K}y[f,k]*CY[f,k];
	
subject to

region_limit {r in R}:   #cannot send more from a region that its capacity
	sum{f in F}x[r,f] <= Q[r];
	
facility_limit {f in F}: #cannot ship more from a facility than its capacity
	sum{k in K}y[f,k] <= Y[f];

in_out_balance {f in F}: #amount shipped from facility has to be equal to amount sent to it
	sum{r in R}x[r,f] - sum{k in K}y[f,k] = 0;
	
meet_demand {k in K}:    #must meet the markets exact demand
	sum{f in F}y[f,k] = Z[k];