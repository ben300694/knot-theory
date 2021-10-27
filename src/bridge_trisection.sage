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

F.<t_k, c, d> = FreeGroup()

def G(k=2):
    """
    G is the group of the complement S^4 - R_k
    """
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1)]
