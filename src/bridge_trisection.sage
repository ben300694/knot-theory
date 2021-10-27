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
k = 3

# b is the bridge number of the bridge trisection
b = 7

# We have 2b bridge points on the central surface,
# where each puncture gives a generator for pi_1
F = FreeGroup(2*b)

# Example: for b=7, have that F is
# Free Group on generators {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13}
# Use F([5]) to refer to generator x4
# F([5,7, -8]) for the word x4*x6*x7^-1

list_bottom = [F([i+1]) for i in range(0, 2*b)]

def conjugate_elements(overstrand_index, understrand_index, list_start):
    """
    Implements one Wirtinger conjugation
    """
    # TODO implement function
    return list_start
    

def G(k=2):
    """
    G is the group of the complement S^4 - R_k
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1)]
