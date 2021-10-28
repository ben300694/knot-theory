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

class Braid_crossing:
    """
    Attributes
    ----------
    first_index, second_index : the index of the left and right strand of the crossing
    sign: +1 for positive crossing, -1 for negative crossing
    """
    def __init__(self, first_index: int, second_index: int, sign: int):
        self.first_index = first_index
        self.second_index = second_index
        assert sign == +1 or sign == -1, "Invalid sign in crossing"
        self.sign = sign

    def __repr__(self) -> str:
        return str(self.__dict__)

class Trivial_tangle_surjection:
    """
    Attributes
    ----------
    bridge_number : bridge number of the tangle
    braid_word : list of elements of type Braid_crossing
    strand_matching : lift of tupels recording how the strands are matched up at the top of the tangle
    generators_temp_list: list of pi_1 elements of the meridians currently at the top of the tangle
    """
    def __init__(self, bridge_number: int, braid_word = [], strand_matching = []) -> None:
        self.bridge_number = bridge_number
        # We have 2b bridge points on the central surface,
        # where each puncture gives a generator for pi_1
        self.F = FreeGroup(2*self.bridge_number)
        self.generators_bottom_list = [self.F([i+1]) for i in range(0, 2*self.bridge_number)]
        self.generators_temp_list = copy.deepcopy(self.generators_bottom_list)
        # Add the crossings to braid word and calculate the meridians at the top
        self.braid_word = []
        for crossing in braid_word:
            self.add_crossing(crossing)
        # Connecting the strands at the top
        self.strand_matching = strand_matching
        return
    
    def __repr__(self) -> str:
        return str(self.__dict__)

    def latex_align_generators_temp(self):
        comma_sep_string = latex(self.generators_temp_list)
        newlines_string = comma_sep_string.replace(",", " \\\\ \n")
        print(newlines_string)
        return newlines_string

    def add_crossing(self, crossing : Braid_crossing):
        """
        Modifies self.generators_temp_list with the Wirtinger rules according to the crossing
        """
        self.braid_word.append(crossing)
        if crossing.sign == +1:
            # Positive crossing
            overstrand_word = self.generators_temp_list[crossing.first_index]
            new_understrand_word = overstrand_word * self.generators_temp_list[crossing.second_index] * overstrand_word^(-1)
            self.generators_temp_list[crossing.first_index] = new_understrand_word
            self.generators_temp_list[crossing.second_index] = overstrand_word
        elif crossing.sign == -1:
            # Negative crossing
            overstrand_word = self.generators_temp_list[crossing.second_index]
            new_understrand_word = overstrand_word^(-1) * self.generators_temp_list[crossing.first_index] * overstrand_word
            self.generators_temp_list[crossing.first_index] = overstrand_word
            self.generators_temp_list[crossing.second_index] = new_understrand_word
        else:
            raise Exception("Invalid value in sign of crossing")
        print("generators_temp_list:", self.generators_temp_list)
        return

class Bridge_Trisection:
    """
    Attributes
    ----------
    bridge_number : bridge number of the bridge trisection

    red_tangle, blue_tangle, green_tangle: of type Trivial_tangle_surjection
    """
    def __init__(self, bridge_number: int) -> None:
        self.bridge_number = bridge_number
        self.red_tangle = Trivial_tangle_surjection(self.bridge_number)
        self.blue_tangle = Trivial_tangle_surjection(self.bridge_number)
        self.green_tangle = Trivial_tangle_surjection(self.bridge_number)

    def __repr__(self) -> str:
        return str(self.__dict__)


# k in NN is the parameter for Suciu's family R_k
k = 3

# Example: for b=7, have that red_tangle.F is
# FreeGroup on generators {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13}
#
# Warning about the indexing:
# Use F([5]) to refer to generator x4
# F([5,7, -8]) for the word x4*x6*x7^-1
#
# Thus the crossing index starts at 0
# Index in the code is one off from the notation in the handwritten document
R_3_red_tangle_braid_crossings_list_INCOMPLETE = [Braid_crossing(5, 6, +1), 
                                                  Braid_crossing(4, 5, +1),
                                                  Braid_crossing(4, 5, +1),
                                                  Braid_crossing(5, 6, +1),
                                                  Braid_crossing(1, 4, -1),
                                                  Braid_crossing(4, 5, -1),
                                                  Braid_crossing(4, 5, -1),
                                                  Braid_crossing(1, 4, -1),
                                                  Braid_crossing(5, 6, -1),
                                                  Braid_crossing(4, 5, -1),
                                                  Braid_crossing(6, 7, -1),
                                                  Braid_crossing(5, 6, -1)
                                                  ]
# TODO: Finish reading off the word from the diagram

# For Suciu's examples, the matching of the tangle strands at the top
# does not depend on the parameter k
R_k_red_tangle_matching_list = [(0, 7), 
                                (1, 6),
                                (2, 3),
                                (4, 5),
                                (8, 9),
                                (10, 13),
                                (11, 12)]

R_k_blue_tangle_matching_list = [(0, 1), 
                                 (2, 5),
                                 (3, 4),
                                 (6, 7),
                                 (8, 11),
                                 (9, 10),
                                 (12, 13)]

R_k_green_tangle_matching_list = [(0, 3), 
                                  (1, 2),
                                  (4, 5),
                                  (6, 9),
                                  (7, 8),
                                  (10, 11),
                                  (12, 13)]

R_3 = Bridge_Trisection(7)
R_3.red_tangle = Trivial_tangle_surjection(bridge_number=7, 
                                           braid_word=R_3_red_tangle_braid_crossings_list_INCOMPLETE,
                                           strand_matching=R_k_red_tangle_matching_list)
# In Suciu's examples, the red and green tangle
# do not have any crossings
R_3.blue_tangle = Trivial_tangle_surjection(bridge_number=7, 
                                            braid_word=[],
                                            strand_matching=R_k_blue_tangle_matching_list)
R_3.green_tangle = Trivial_tangle_surjection(bridge_number=7, 
                                             braid_word=[],
                                             strand_matching=R_k_green_tangle_matching_list)


    
