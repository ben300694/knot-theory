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
set_gap_memory_pool_size(50000000000)

def commutator(a, b):
    return a*b*a^(-1)*b^(-1)

# k in NN is the parameter for Suciu's family R_k
k = 7


H_Free.<t, u, v> = FreeGroup()

# H is the trefoil knot group written as an HNN extension
# coming form the fibering of the complement by a punctured torus
H = H_Free / [v^(-1)*t*u*t^(-1),
              v^(-1)*u*t*v*t^(-1)]
              
def t_k(k):
    return u^k * t

def c(k):
    return u^(-k)*t_k(k)*u^k
def d(k):
    return u^(-k+1)*t_k(k)*u^(k-1)


T_Free.<a, b> = FreeGroup()

# t = b^(-1)*a
# u = t^(-1)*x
#   = a^(-1)*b*a*b^(-1)
# v = x*t^(-1)
#   = a*b^(-1)*a^(-1)*b

# Plugging this into commutator(c,d) to write it in terms of a, b
def rel_ab(k):
    return commutator(c(k),d(k))(b^(-1)*a, a^(-1)*b*a*b^(-1), a*b^(-1)*a^(-1)*b)
    
def rel_ab_manual(k):
    return b^(-1)*a*(a^(-1)*b*a*b^(-1))^(k+1)*b^(-1)*a*b*a^(-1)*(a^(-1)*b*a*b^(-1))^(-k+1)*a^(-1)*b*(a^(-1)*b*a*b^(-1))^(-1)

# Presentation of trefoil knot group from genus 1 Heegaard splitting
Trefoil = T_Free / [a^2*b^(-3)]

def Trefoil_quotient(k):
    """
    Quotient of trefoil knot group by the image of commutator(c, d)
    """
    return T_Free / [a^2*b^(-3), rel_ab(k)]
    
# Trefoil_quotient(1) is abelian and isomorphic to Z
# Trefoil_quotient(2) is abelian and isomorphic to Z
# 
# Trefoil_quotient(3) is abelian and isomorphic to Z
# Exiting Sage (CPU time 822m42.51s, Wall time 1276m55.96s). [Samsung laptop]
#
# Also confirmed that the quotient is abelian in the following way:
# Test=Trefoil_quotient(3)
# Test(a*b*a^(-1)*b^(-1))==Test(1)
# sage: True
# Exiting Sage (CPU time 818m21.67s, Wall time 1167m18.18s). [Samsung laptop]

P_Free.<A, B> = FreeGroup()
PSL_2_Z = P_Free / [A^2, B^3]

def PSL_2_Z_quotient(k):
    """
    Quotient of PSL(2,Z) by the image of commutator(c, d)    
    """
    return P_Free / [A^2, B^3, rel_ab(k)(A,B)]

def run_test():
    for k in range(2, 12):
        Test = PSL_2_Z_quotient(k)
        print("-----------------")
        print(Test)
        print("Order:", Test.cardinality())
        print("Structure Description:", Test.gap().StructureDescription())


