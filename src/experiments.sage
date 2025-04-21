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
def G(k=2):
    return F / [d^(-1)*t_k*(d*c^(-1))^(-k+1)*t_k*(d*c^(-1))^(k-1)*(t_k^(-1)),
                c^(-1)*t_k*c*d^(-1)*(t_k)^(-1)*d*t_k*d*c^(-1)*(t_k)^(-1)]

T.<a_1, a_2, a_3> = FreeGroup()
Trefoil_Wirtinger = T / [a_1*a_3^(-1)*a_2^(-1)*a_3,
                         a_3*a_2^(-1)*a_1^(-1)*a_2,
                         a_2*a_1^(-1)*a_3^(-1)*a_1]

