# Using SageMath interface for GAP
# To start GAP inside of SageMath:
# gap.console()
#
# Defining groups in GAP:
# PSL := FreeProduct(CyclicGroup(2),CyclicGroup(3))
#
# Using SageMath to access GAP's
# finitely presented groups functionality
# https://doc.sagemath.org/html/en/reference/groups/sage/groups/finitely_presented.html

from sage.interfaces.gap import get_gap_memory_pool_size, set_gap_memory_pool_size
set_gap_memory_pool_size(20000000000)

# k in NN is the parameter for Suciu's family R_k
k = 7

F.<t_k, c, d> = FreeGroup()

# G is the group of the complement S^4 - R_k

G = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)), c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1)]

# Passing to the associated RP^2-knot
# by making the meridian have order 2

# pi_1(R_k # RP^2) 
# \cong pi_1(Double Branched Cover(R_k)) semidirect product Z/2

RPG = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)), c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), t_k^2]

# The groups are finite for k=2 and k=3
# RPG.order()
# List elements of group:
# RPG.gap().Elements()
# Descriptive name for group:
# RPG.gap().StructureDescription()


def commutator(a, b):
    return a*b*a^(-1)*b^(-1)

# w is the guiding arc of the finger move
w = d
rel = commutator(t_k, w^(-1)*t_k*w)

quotient = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)), c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), t_k^2, rel]

quotient.cardinality()
quotient.gap().StructureDescription()

# Unfortunately, the following appears to be the case:
#
# both for 
# k=2 and k=3,
# the relation [t_k, d^(-1)*t_k*d]
# (i.e. w = d in [t_k, w^(-1)*t_k*w])
# will abelianize the group of RP^2 # R_k
#
# for k=4 the group of the RP^2-knot is NOT abelianized by relation [t_k, d^(-1)*t_k*d]
# quotient is "S3"
#
# for k=5 the group of the RP^2-knot IS abelianized by relation [t_k, d^(-1)*t_k*d]
# for k=6 the group of the RP^2-knot IS abelianized by relation [t_k, d^(-1)*t_k*d]
#
# for k=7 the program runs out of memory on my Samsung laptop
# on MPIM metis with
# set_gap_memory_pool_size(20000000000)
# for k=7 the group of the RP^2-knot is NOT abelianized by relation [t_k, d^(-1)*t_k*d]
# quotient is "S3"

# # # # # # # # # # # # #
# Alexander polynomials
# # # # # # # # # # # # #

fox_matrix = G.alexander_matrix()

R.<t> = LaurentPolynomialRing(ZZ)
# if something (like taking determinants) is not implemented in Sage for Laurent Polynomials
# can try to use polynomial ring instead
# R.<t>=PolynomialRing(ZZ)
# https://levitopher.wordpress.com/2017/08/01/knot-theory-on-sage/

alex_matrix = G.alexander_matrix([t,t,t])
alex_poly = gcd(alex_matrix.minors(G.ngens() - 1))




