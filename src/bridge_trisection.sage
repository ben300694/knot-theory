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

import copy

def commutator(a, b):
    return a*b*a^(-1)*b^(-1)

def conjugate(x, w):
    return w^(-1)*x*w

class Trivial_tangle_surjection:
    """
    Attributes
    ----------
    bridge_number : bridge number of the bridge trisection
    """
    def __init__(self, bridge_number: int) -> None:
        self.bridge_number = bridge_number
        # We have 2b bridge points on the central surface,
        # where each puncture gives a generator for pi_1
        self.F = FreeGroup(2*self.bridge_number)
        self.generators_bottom_list = [self.F([i+1]) for i in range(0, 2*self.bridge_number)]
        self.generators_temp = copy.deepcopy(self.generators_bottom_list)

    def crossing(self, overstrand_index: int, understrand_index: int):
        """
        Modifies self.generators_temp with the Wirtinger rules according to the crossing
        """
        


# k in NN is the parameter for Suciu's family R_k
k = 3

red_tangle = Trivial_tangle_surjection(bridge_number=7)

# Example: for b=7, have that red_tangle.F is
# FreeGroup on generators {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13}
# Use F([5]) to refer to generator x4
# F([5,7, -8]) for the word x4*x6*x7^-1



def conjugate_elements(overstrand_index, understrand_index, list_start):
    """
    Implements one Wirtinger conjugation
    """
    # TODO implement function
    return list_start
    
