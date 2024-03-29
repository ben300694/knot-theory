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

    def _latex_(self):
        # the r indicates raw string literals
        if self.sign == +1:
            return LatexExpr(r"\sigma_{" + str(self.first_index) + r"," + str(self.second_index) + r"}")
        elif self.sign == -1:
            return LatexExpr(r"\sigma_{" + str(self.first_index) + r"," + str(self.second_index) + r"}^{-1}")

class Trivial_tangle:
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
        self.F = free_group
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

    def _latex_(self):
        return list(map(latex, R_3.red_tangle.braid_word))

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
        x'_{1} * x'_{2} * ... * x'_{2b}
        """
        return reduce((lambda x, y: x * y), self.generators_temp_list)

    def relations(self):
        """
        Lists the relations obtained by
        joining up the tangle strands at the top
        """
        return [self.generators_temp_list[a]*self.generators_temp_list[b] for (a,b) in self.strand_matching]
        
    def group(self):
        """
        Gives a presentation of the group of the tangle complement
        (which is free on b generators)
        with generators the meridians around the punctures and
        relations from joining up the tangle strands at the top
        """
        return self.F.quotient(self.relations())

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
        self.red_tangle = Trivial_tangle(self.bridge_number, self.F)
        self.blu_tangle = Trivial_tangle(self.bridge_number, self.F)
        self.gre_tangle = Trivial_tangle(self.bridge_number, self.F)

    def __repr__(self) -> str:
        return str(self.__dict__)

    def all_relations(self):
        return self.red_tangle.relations() + self.blu_tangle.relations() + self.gre_tangle.relations()

    # Use the following command to find an isomorphism simplifying the presentation:
    # hom = tau_2_T_3_5.group().simplification_isomorphism()
    # We can access the images under the isomorphism via:
    # hom(tau_2_T_3_5.F.gen(0))
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
            print(pushout.simplification_isomorphism())
            print(pushout.simplified())
            if pushout.simplified().relations() != ():
                print(False)
                continue
                # return False
            print(True)
        return True

#    def construct_coloring(n: int):
#        """
#        Constructs the object containing the coloring for the tangles
#        """
#        S = SymmetricGroup(n)
#        self.coloring = Coloring(self.F, S, [], [])
        

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
# R_k in Suciu's family
# # # # # # # # # # # # #

attach('data/suciu_R_k_bridge_trisection.sage')

# k in NN is the parameter for Suciu's family R_k
def R_k(k : int):
    R_k = Bridge_Trisection(7)
    R_k.red_tangle = Trivial_tangle(bridge_number=7,
                                               free_group=R_k.F,
                                               braid_word=R_k_red_tangle_braid_crossings_list(k),
                                               strand_matching=R_k_red_tangle_matching_list(k))
    R_k.blu_tangle = Trivial_tangle(bridge_number=7,
                                               free_group=R_k.F,
                                               braid_word=R_k_blu_tangle_braid_crossings_list(k),
                                               strand_matching=R_k_blu_tangle_matching_list(k))
    R_k.gre_tangle = Trivial_tangle(bridge_number=7, 
                                               free_group=R_k.F,
                                               braid_word=R_k_gre_tangle_braid_crossings_list(k),
                                               strand_matching=R_k_gre_tangle_matching_list(k))
    return R_k

R_3 = R_k(3)
R_4 = R_k(4)



# # # # # # # # # # # # # # # # # # # # # #
# l-twist spin of the (2, b) torus knot
# # # # # # # # # # # # # # # # # # # # # #

attach('data/l_twist_spin_T_2_b_bridge_trisection.sage')

def tau_l_T_2_b(l : int, b : int):
    tau_l_T_2_b = Bridge_Trisection(4)
    tau_l_T_2_b.red_tangle = Trivial_tangle(bridge_number=4,
                                                    free_group=tau_l_T_2_b.F,
                                                    braid_word=tau_l_T_2_b_red_tangle_braid_crossings_list(l, b),
                                                    strand_matching=tau_l_T_2_b_red_tangle_matching_list(l, b))
    tau_l_T_2_b.blu_tangle = Trivial_tangle(bridge_number=4,
                                                        free_group=tau_l_T_2_b.F,
                                                        braid_word=tau_l_T_2_b_blu_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_2_b_blu_tangle_matching_list(l, b))
    tau_l_T_2_b.gre_tangle = Trivial_tangle(bridge_number=4,
                                                        free_group=tau_l_T_2_b.F,
                                                        braid_word=tau_l_T_2_b_gre_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_2_b_gre_tangle_matching_list(l, b))
    return tau_l_T_2_b

# # # # # # # # # # # # # # # # # # # # # #
# l-twist spin of the (3, b) torus knot
# # # # # # # # # # # # # # # # # # # # # #

attach('data/l_twist_spin_T_3_b_bridge_trisection.sage')

def tau_l_T_3_b(l : int, b : int):
    tau_l_T_3_b = Bridge_Trisection(7)
    tau_l_T_3_b.red_tangle = Trivial_tangle(bridge_number=7,
                                                    free_group=tau_l_T_3_b.F,
                                                    braid_word=tau_l_T_3_b_red_tangle_braid_crossings_list(l, b),
                                                    strand_matching=tau_l_T_3_b_red_tangle_matching_list(l, b))
    tau_l_T_3_b.blu_tangle = Trivial_tangle(bridge_number=7,
                                                        free_group=tau_l_T_3_b.F,
                                                        braid_word=tau_l_T_3_b_blu_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_3_b_blu_tangle_matching_list(l, b))
    tau_l_T_3_b.gre_tangle = Trivial_tangle(bridge_number=7,
                                                        free_group=tau_l_T_3_b.F,
                                                        braid_word=tau_l_T_3_b_gre_tangle_braid_crossings_list(l, b),
                                                        strand_matching=tau_l_T_3_b_gre_tangle_matching_list(l, b))
    return tau_l_T_3_b

# # # # # # # # # # # # # # # # # # # # # #
# p-twist spin of the (q, r) torus knot
# for {p, q, r} = {2, 3, 5}
# # # # # # # # # # # # # # # # # # # # # #

# meridional rank 2

# 3-twist spin of the (2, 5) torus knot
tau_3_T_2_5 = tau_l_T_2_b(3, 5)

# 5-twist spin of the (2, 3) torus knot
# This example is also encoded in a separate file which does
# not use the more general l_twist_spin_T_2_b_bridge_trisection.sage
tau_5_T_2_3 = tau_l_T_2_b(5, 3)

# meridional rank 3

tau_2_T_3_5 = tau_l_T_3_b(2, 5)



# # # # # # # # # # # # # # # # # # # # # # # # # # #
# Double of the fusion number one ribbon disk
# of the Stevedore knot 6_1
# # # # # # # # # # # # # # # # # # # # # # # # # # #

attach('data/stevedore_disk_double.sage')

double_6_1 = Bridge_Trisection(5)

double_6_1.red_tangle = Trivial_tangle(bridge_number=5,
                                                  free_group=double_6_1.F,
                                                  braid_word=double_6_1_red_tangle_braid_crossings_list,
                                                  strand_matching=double_6_1_red_tangle_matching_list)

# In ribbon knots, the red and green tangle
# do not have any crossings
double_6_1.blu_tangle = Trivial_tangle(bridge_number=5,
                                                  free_group=double_6_1.F,
                                                  braid_word=double_6_1_blu_tangle_braid_crossings_list,
                                                  strand_matching=double_6_1_blu_tangle_matching_list)
double_6_1.gre_tangle = Trivial_tangle(bridge_number=5, 
                                                  free_group=double_6_1.F,
                                                  braid_word=double_6_1_gre_tangle_braid_crossings_list,
                                                  strand_matching=double_6_1_gre_tangle_matching_list)


# # # # # # # # # # # # # # # # # # # # # #
# 0-twist spin of the (2, 3) torus knot
# = spun trefoil knot
# # # # # # # # # # # # # # # # # # # # # #
spun_trefoil = tau_l_T_2_b(0, 3)

# Use the coloring function for this example
# spun_trefoil.construct_coloring(3)

# # # # # # # # # # # # # # # # # # # # # #
# This space is for implementing the steps in the
# Reidemeister-Schreier procedure
# 
# We can implement the functions here first and
# incorporate them in the classes above later
# # # # # # # # # # # # # # # # # # # # # #

class Coloring:
    """
    Attributes
    ----------
    F: Free group containing the generators (in our case x_0, ... x_{2b-1})
    S: Symmetric group used as the codomain for the coloring
    relations: list of relations_source specifying the source group as a quotient of F
    images_of_generators:
        list of elements of the symmetric group S specifying the images of the generators of F
        We are always assuming that the representation is transitive,
        so that we obtain a connected cover.
    """
    def __init__(self, F: FreeGroup, S: SymmetricGroup, relations_source = [], images_of_generators = []):
        self.F = F
        self.S = S
        self.relations_source = relations_source
        # construct homomorphism F --> S from the list images_of_generators
        self.representation = self.F.hom([self.S(g) for g in images_of_generators])

    def __repr__(self) -> str:
        return str(self.__dict__)

    def lift_of_single_relation(relation, starting_sheet):
        """
        Computes the attaching circle for the lift of a 2-cell,
        with the basepoint in the starting_sheet

        relation: word in a FreeGroup
        starting_sheet: 
        """
        current_sheet = starting_sheet
        # TODO: Continue implementing this function
        # We can integrate it into the python classes later
        return

    def reidemeister_schreier(coloring):
        for rel in coloring.relations:
            break # TODO: find the lifts for each relation using the function above
        # TODO: Continue implementing this function
        # We can integrate it into the python classes later
        return


test_F = FreeGroup(4)
test_S = SymmetricGroup(3)
# Suppose S is the symmetric group
# We can act by elements of the symmetric group by writing
# S('(1, 2)')(1), the result is 2
# Another example:
# test_hom(test_F([1]))(1) is the action of the image of x0 on the number '1'

# Write down list with images of generators of F in the symmetric group
test_images_of_generators = ['(1, 2)', '(1, 2)', '(2, 3)', '(2, 3)']

# Relation in the handwritting notes from 2021-12-03 that we can
# test the implementation of the Reidemeister-Schreier algorithm on
test_relation = test_F([2, -4, 1, 3])

# Constructing an example coloring to test our functions on
test_coloring = Coloring(test_F, test_S, [test_relation], test_images_of_generators)





