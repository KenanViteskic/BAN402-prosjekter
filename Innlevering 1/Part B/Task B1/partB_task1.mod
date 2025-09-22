# Task 1 : MODEL

# Sets:
set S;					# Suppliers
set C;					# Cardboards
set P;					# Products
set A within P;			# Category A products
set B within P;			# Category B products

# Parameters (nonnegative)
param u{S,C}     >= 0, default 0;	# Purchase caps (t/week) (0 if not offered)
param cBuy{S,C}  >= 0, default 0;	# Purchase prices ($/t)
param M{S}       >= 0;				# Min spend per supplier ($)

param capA       >= 0;				# Category A capacity (t/week)
param capB       >= 0;				# Category B capacity (t/week)

param dmin{P}    >= 0;				# Min demand (t/week)
param price{P}   >= 0;				# Sales price ($/t)
param cProd{P}   >= 0;				# Production cost ($/t)

param str{C}     >= 0;				# Cardboard strength
param tr{C}      >= 0;				# Cardboard transparency 

param STRmin{P}  >= 0;				# Product min strength
param TRmax{P}   >= 0;				# Product max transparency

# Decision variables:
var x{S,C} >= 0;		# Purchases (t/week)
var z{P,C} >= 0;		# Blend amounts into product p (t/week)
var y{P}   >= 0;		# Product output (t/week)

# Objective: maximize weekly profit
maximize Profit:
    sum{p in P} price[p]*y[p]
  - sum{s in S, c in C} cBuy[s,c]*x[s,c]
  - sum{p in P} cProd[p]*y[p];

# Constraints
# 1) Purchase limits:
s.t. PurchaseLimit{s in S, c in C}:
    x[s,c] <= u[s,c];

# 2) Minimum spend per supplier:
s.t. MinSpend{s in S}:
    sum{c in C} cBuy[s,c]*x[s,c] >= M[s];

# 3) Material balance by cardboard:
s.t. MaterialBalance{c in C}:
    sum{p in P} z[p,c] <= sum{s in S} x[s,c];

# 4) Blend equals output, by product:
s.t. BlendEq{p in P}:
    sum{c in C} z[p,c] = y[p];

# 5) Category capacities:
s.t. CapAcon:
    sum{p in A} y[p] <= capA;

s.t. CapBcon:
    sum{p in B} y[p] <= capB;

# 6) Minimum demand:
s.t. Demand{p in P}:
    y[p] >= dmin[p];

# 7) Quality – strength:
s.t. StrengthReq{p in P}:
    sum{c in C} str[c]*z[p,c] >= STRmin[p]*y[p];

# 8) Quality – transparency:
s.t. TranspReq{p in P}:
    sum{c in C} tr[c]*z[p,c] <= TRmax[p]*y[p];


	