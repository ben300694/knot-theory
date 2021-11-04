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
    def __init__(self, 
                 bridge_number: int,
                 free_group: FreeGroup,
                 braid_word = [],
                 strand_matching = []) -> None:
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
        """
        Postprocessing the output to make it into pretty LaTeX code
        for align environments

        Removes cdot from the output string,
        inserts LaTeX linebreaks at line ends
        """
        comma_sep_string = latex(self.generators_temp_list)
        newlines_string = comma_sep_string.replace(",", " \\\\ \n")
        without_cdot_string = newlines_string.replace("\\cdot", "")
        print(without_cdot_string)
        return without_cdot_string

    def add_crossing(self, crossing : Braid_crossing):
        """
        Modifies self.generators_temp_list 
        with the Wirtinger rules according to the added crossing
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
        # Uncomment to print intermediate steps         
        # print("generators_temp_list:", self.generators_temp_list)
        return

    def product_of_conjugates(self):
        """
        Calculates the product of the meridians at the top
        x_{1} * x_{2} * ... * x_{2b}
        """
        return reduce((lambda x, y: x * y), self.generators_temp_list)

    def relations(self):
        """
        Lists the relations obtained by joining up the
        tangle strands at the top
        """
        return [self.generators_temp_list[a]*self.generators_temp_list[b] for (a,b) in self.strand_matching]

class Bridge_Trisection:
    """
    Attributes
    ----------
    bridge_number : bridge number of the bridge trisection

    red_tangle, blu_tangle, gre_tangle: red, blue and green tangle of type Trivial_tangle_surjection
    """
    def __init__(self, bridge_number: int) -> None:
        self.bridge_number = bridge_number
        self.F = FreeGroup(2*self.bridge_number)
        self.red_tangle = Trivial_tangle_surjection(self.bridge_number, self.F)
        self.blu_tangle = Trivial_tangle_surjection(self.bridge_number, self.F)
        self.gre_tangle = Trivial_tangle_surjection(self.bridge_number, self.F)

    def __repr__(self) -> str:
        return str(self.__dict__)

    def all_relations(self):
        return self.red_tangle.relations() + self.blu_tangle.relations() + self.gre_tangle.relations()

    def group(self):
        """
        Returns a presentation of the fundamental group of the complement of
        the bridge trisected surface
        """
        # WARNING: Careful with the mirror images when putting pairs of tangles together
        return self.F.quotient(self.all_relations())

    def pairwise_pushout_relations(self):
        """
        Returns a three element list of the pairwise pushout groups
        """
        unlink_redblu = self.red_tangle.relations() + self.blu_tangle.relations()
        unlink_blugre = self.blu_tangle.relations() + self.gre_tangle.relations()
        unlink_grered = self.gre_tangle.relations() + self.red_tangle.relations()
        return [unlink_redblu, unlink_blugre, unlink_grered]

    def pairwise_pushout_is_free(self):
        """
        Checks whether the pairwise pushouts are free groups
        """
        for pairwise_relations in self.pairwise_pushout_relations():
            pushout = self.F.quotient(pairwise_relations)
            print(pushout)
            print(pushout.simplified())
            if pushout.simplified().relations() != ():
                print(False)
                continue
                # return False
            print(True)
        return True

# Example: for b=7, have that red_tangle.F is
# FreeGroup on generators {x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13}
#
# Warning about the indexing:
# Use F([5]) to refer to generator x4
# F([5,7, -8]) for the word x4*x6*x7^-1
#
# Thus the crossing index starts at 0
# Index in the code is one off from the notation in the handwritten document
#
# brown band guiding arc (w_2)^(-1) = t_k * d * c^(-1) * (t_k)^(-1)

# # # # # # # # # # # # #
# R_3 in Suciu's family
# # # # # # # # # # # # #

attach('data/suciu_bridge_trisection.sage')

# k in NN is the parameter for Suciu's family R_k
k = 3

R_3 = Bridge_Trisection(7)
R_3.red_tangle = Trivial_tangle_surjection(bridge_number=7,
                                           free_group=R_3.F,
                                           braid_word=R_3_red_tangle_braid_crossings_list,
                                           strand_matching=R_k_red_tangle_matching_list)

# In Suciu's examples, the red and green tangle
# do not have any crossings
R_3.blu_tangle = Trivial_tangle_surjection(bridge_number=7,
                                           free_group=R_3.F,
                                           braid_word=R_k_blue_tangle_braid_crossings_list,
                                           strand_matching=R_k_blue_tangle_matching_list)
R_3.gre_tangle = Trivial_tangle_surjection(bridge_number=7, 
                                           free_group=R_3.F,
                                           braid_word=R_k_blue_tangle_braid_crossings_list,
                                           strand_matching=R_k_green_tangle_matching_list)

# # # # # # # # # # # # # # # # # # # # # #
# 0-twist spin of the (2, 3) torus knot
# = spun trefoil knot
# # # # # # # # # # # # # # # # # # # # # #

attach('data/l_twist_spin_T_2_b_bridge_trisection.sage')

def tau_l_T_2_b(l : int, b : int):
    tau_l_T_2_b = Bridge_Trisection(4)
    tau_l_T_2_b.red_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                    free_group=spun_trefoil.F,
                                                    braid_word=tau_l_T_2_b_red_tangle_braid_crossings_list(l, b),
                                                    strand_matching=tau_l_T_2_b_red_tangle_matching_list(l, b))
    tau_l_T_2_b.blu_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                        free_group=spun_trefoil.F,
                                                        braid_word=tau_l_T_2_b_blu_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_2_b_blu_tangle_matching_list(l, b))
    tau_l_T_2_b.gre_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                        free_group=spun_trefoil.F,
                                                        braid_word=tau_l_T_2_b_gre_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_2_b_gre_tangle_matching_list(l, b))
    return tau_l_T_2_b
    

spun_trefoil = tau_l_T_2_b(0, 3)

#spun_trefoil = Bridge_Trisection(4)
#spun_trefoil.red_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                    free_group=spun_trefoil.F,
#                                                    braid_word=tau_l_T_2_b_red_tangle_braid_crossings_list(0, 3),
#                                                    strand_matching=tau_l_T_2_b_red_tangle_matching_list(0, 3))
#spun_trefoil.blu_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                    free_group=spun_trefoil.F,
#                                                    braid_word=tau_l_T_2_b_blu_tangle_braid_crossings_list(0, 3),
#                                                    strand_matching=tau_l_T_2_b_blu_tangle_matching_list(0, 3))
#spun_trefoil.gre_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                    free_group=spun_trefoil.F,
#                                                    braid_word=tau_l_T_2_b_gre_tangle_braid_crossings_list(0, 3),
#                                                    strand_matching=tau_l_T_2_b_gre_tangle_matching_list(0, 3))

# # # # # # # # # # # # # # # # # # # # # #
# This example is encoded in a separate file and does
# not use the more general l_twist_spin_T_2_b_bridge_trisection.sage
# 3-twist spin of the (2, 5) torus knot
# # # # # # # # # # # # # # # # # # # # # #

attach('data/3_twist_spin_T_2_5_bridge_trisection.sage')

tau_3_T_2_5 = Bridge_Trisection(4)

tau_3_T_2_5.red_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                   free_group=tau_3_T_2_5.F,
                                                   braid_word=tau_3_T_2_5_red_tangle_braid_crossings_list,
                                                   strand_matching=tau_3_T_2_5_red_tangle_matching_list)
tau_3_T_2_5.blu_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                   free_group=tau_3_T_2_5.F,
                                                   braid_word=tau_3_T_2_5_blu_tangle_braid_crossings_list,
                                                   strand_matching=tau_3_T_2_5_blu_tangle_matching_list)
tau_3_T_2_5.gre_tangle = Trivial_tangle_surjection(bridge_number=4,
                                                   free_group=tau_3_T_2_5.F,
                                                   braid_word=tau_3_T_2_5_gre_tangle_braid_crossings_list,
                                                   strand_matching=tau_3_T_2_5_gre_tangle_matching_list)





    
