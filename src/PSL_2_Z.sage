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


P_Free.<A, B> = FreeGroup()

PSL_2_Z = P_Free / [A^2, B^3]

def quotient(k):
    return P_Free / [A^2, B^3, rel_ab(k)(A,B)]

def run_test():
    for k in range(2, 12):
        Test = quotient(k)
        print("-----------------")
        print(Test)
        print("Order:", Test.cardinality())
        print("Structure Description:", Test.gap().StructureDescription())


