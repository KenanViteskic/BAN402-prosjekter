set Facilities; #set of facilities
set Pollutants; #set of pollutants

param C {Facilities}; #cost of producing a ton of fish at a facility
param Y {Pollutants, Facilities}; #amount of pollutant j reduced by pr
param R {Pollutants}; #minimal reduction 

var x {Facilities} >= 0; #tons of fish produced at facility i

minimize total_costs: #objective function, minimizing costs
	sum{i in Facilities}C[i]*x[i];

subject to

pollutant_reduction {j in Pollutants}: # pollutant reduction constraint
	sum{i in Facilities}Y[j,i]*x[i] >= R[j];