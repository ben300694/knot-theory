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
set_gap_memory_pool_size(200000000000)

def commutator(a, b):
    return a*b*a^(-1)*b^(-1)


# k in NN is the parameter for Suciu's family R_k
k = 7

F.<t_k, c, d> = FreeGroup()

def G(k=2):
    """
    G is the group of the complement S^4 - R_k
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1)]

def RPG(k=2):
    """
    Passing to the associated RP^2-knot
    by making the meridian t_k have order 2
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)), 
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), 
                t_k^2]

# Can identify this groups as
# pi_1(R_k # RP^2) 
# \cong pi_1(Double Branched Cover(R_k)) semidirect product Z/2
#
# The groups are finite for k=2 and k=3
# RPG.order()
# List elements of group:
# RPG.gap().Elements()


def w_1(k):
    """
    Words for the guiding arc of the first (orange) ribbon band
    in the fusion number 2 presentation of 
    Suciu's knot R_k
    """
    return t_k*(d*c^(-1))^(-k+1)

def w_2(k):
    """
    Words for the guiding arc of the second (brown) ribbon band
    in the fusion number 2 presentation of 
    Suciu's knot R_k

    Comment: w_2 does not depend on k
    """    
    return t_k*c*d^(-1)*(t_k)^(-1)


# Testing w as the guiding arc of the finger move
w = d
rel = commutator(t_k, w^(-1)*t_k*w)
FM_quotient = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)), 
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), 
                t_k^2,
                rel]

# GAP functions to investigate the structure of a group:
#
# quotient.cardinality()
#
# Descriptive name for group:
# quotient.gap().StructureDescription()

def G_quotient_by_relation(k=2, relation=commutator(c, d)):
    """
    Function for defining the quotient of G(k) by relation
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1),
                relation]

def RPG_quotient_by_relation(k=2, relation=commutator(c, d)):
    """
    Function for defining quotients of RPG(k)
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1),
                t_k^(2),
                relation]


# # # # # # # # # # # # #
# Alexander polynomials
# # # # # # # # # # # # #

R.<t> = LaurentPolynomialRing(ZZ)
# if some operation (like taking determinants) is not implemented in Sage for Laurent Polynomials
# can try to use polynomial ring instead
# R.<t>=PolynomialRing(ZZ)
# https://levitopher.wordpress.com/2017/08/01/knot-theory-on-sage/

fox_matrix = G(k).alexander_matrix()
alex_matrix = G(k).alexander_matrix([t,t,t])
alex_poly = gcd(alex_matrix.minors(G(k).ngens() - 1))

def alexander_ideal(Group):
    alex_matrix = Group.alexander_matrix([t]*Group.ngens())
    print("----------------------")
    print("Alexander matrix:")
    print(alex_matrix)
    print("----------------------")
    return alex_matrix.minors(Group.ngens() - 1)

# # # # # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # # # # #

def check_all_finger_move_relations(k=2):
    """
    Checking the quotient of the group of the RP^2 knot RP^2 # R_k
    by all possible finger move relations
    [t_k, w^(-1)*t_k*w]

    For each finger move relation, the function will print
    the cardinality of the quotient and its Alexander module
    
    Call this function only for
    k=2 and k=3
    because these are the only cases where the group is finite
    """
    Group = RPG(k)
    print("k =", k)
    print("Checking quotients of group", Group)
    for w in Group.gap().Elements():
        print("=====================================")
        print("Taking group element", w)
        # Use RPG(x) to convert word x in the free group F to GAP object element in RPG
        # Use F(y) to convert GAP object y to word in the free group F
        rel = F(commutator(Group(t_k), Group(w)^(-1)*Group(t_k)*Group(w)))
        print("Checking quotient after relation", rel)
        RPGQuotient = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                           c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), 
                           t_k^2,
                           rel]
        print("Cardinality of the quotient =", RPGQuotient.cardinality())
        Quotient = F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                        c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1), 
                        rel]
        alex_ideal = alexander_ideal(Quotient)
        print("Alexander ideal:")
        print(alex_ideal)
    return
