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

#from sage.interfaces.gap import get_gap_memory_pool_size, set_gap_memory_pool_size
#set_gap_memory_pool_size(50000000000)

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

load('data/suciu_R_k_bridge_trisection.sage')

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

load('data/l_twist_spin_T_2_b_bridge_trisection.sage')

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

load('data/l_twist_spin_T_3_b_bridge_trisection.sage')

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

load('data/stevedore_disk_double.sage')

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

class Colored_trivial_tangle:
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
        self.coverF=FreeGroup(rank(self.F)*self.S.degree())

    def __repr__(self) -> str:
        return str(self.__dict__)

    def lift_of_single_relation_sub_sup_exp(self, relation, starting_sheet):
        """
        Computes the attaching circle for the lift of a 2-cell,
        with the basepoint in the starting_sheet

        Returns a list of pairs, with each element giving (subscript, superscript)
        in the lifted relation (following Fox' notation convention)

        relation: word in a FreeGroup
        starting_sheet: index of the lift of the basepoint where the lift of the curve is starting 
        """
        # Test the function by calling
        # test_coloring.lift_of_single_relation(test_relation, 1)
        current_sheet = starting_sheet
        list_of_sheets = [starting_sheet]
        for current_letter in relation.Tietze():
            #print("current_letter =", current_letter)
            #print("permutation of current letter =", self.representation(self.F([current_letter])))
            current_sheet = self.representation(self.F([current_letter]))(current_sheet)
            list_of_sheets.append(current_sheet)
            #print("current list_of_sheets =", list_of_sheets)
        # try to find subscripts and superscripts, save them as a list of pairs
        list_of_pairs = []        
        for i, current_letter in enumerate(relation.Tietze()):
            subscript = current_letter
            if sign(current_letter) == +1:
                superscript = list_of_sheets[i]
            elif sign(current_letter) == -1:
                superscript = list_of_sheets[i+1]
            list_of_pairs.append((subscript, superscript))
        list_of_triples=[]
        for pair in list_of_pairs:
            list_of_triples.append([abs(pair[0])-1,pair[1],sign(pair[0])]) #fixes off by one error in subscript, moves sign of exponent to third entry
        #each triple is (superscript,subscript,exponent (+/-1))
        return list_of_triples
    
    def lift_of_single_relation_reindex(self, relation, starting_sheet):
        relationtriples=self.lift_of_single_relation_sub_sup_exp(relation, starting_sheet)
        relation=[]
        for triple in relationtriples:
            (sub, sup, exp) = triple
            new_subscript= (( (sub + self.F.rank() * (sup - 1)))+1)*exp
            
            relation.append(new_subscript)
        return self.coverF(relation)
            
    def lift_relations_sub_sup_exp(self):
        list_of_lifted_relations = []
        for rel in self.relations_source:
            # self.S.degree() is the rank of the symmetric group = number of sheets
            for i in range(0, self.S.degree()):
                rel_lifted = self.lift_of_single_relation_sub_sup_exp(rel, i+1)
                # i+1 because sheets are indexed starting from 1
                list_of_lifted_relations.append(rel_lifted)
        # TODO: Continue implementing this function
        
        # Find the claw relations
        
        # n degree of the cover
        # g number of generators of group 
        return list_of_lifted_relations
   
    def lift_relations_reindex(self):
        list_of_lifted_relations=[]
        for rel in self.relations_source:
            # self.S.degree() is the rank of the symmetric group = number of sheets
            for i in range(0, self.S.degree()):
                 rel_lifted = self.lift_of_single_relation_reindex(rel, i+1)
                 # i+1 because sheets are indexed starting from 1
                 list_of_lifted_relations.append(rel_lifted)
        
        return list_of_lifted_relations
    
    def claw_relations_sub_sup_exp(self):

        #F=FreeGroup(g)
        #Free group with generators x0,x1,...,x(g-1)

        n=self.S.degree()
        g=self.F.rank()
        
        #homomorphism rho sends the generator xi to rho[i]
        #rho=['(1,2)','(1,2)','(1,3)','(1,3)','(1,3)','(1,3)','(1,3)','(1,3)']
        #rho=['(1,2)','(1,2)','(1,2,3)','(1,2,3)','(1,2,3)','(1,2,3)','(1,4,5)','(1,4,5)']
        #vertices p1,p2,p3,... note indexing starts at 1 to match symmetric group

        #there is an edge from pi to pj


        reachable=[1]
        remaining=[i for i in range(2,n+1)] #vertices remaining to be visited
        #print('remaining',remaining)
        claw_relations={1:[]}


        while len(remaining)>0:

            for current in reachable:
                #print("current",current)
                reachable.remove(current)

                for j in range(g): #j is the subscript of x_j.  

                    #Determine which vertices you can reach from current from each of the generators x_0,...,x_g-1
                    #endpoint=self.S(rho[j])(current) 
                    
                    endpoint=self.representation(self.F([j+1]))(current)

                    #check if the endpoint vertex has been visited.  If not (i.e., if in remaining)...
                    if( endpoint in remaining):
                        #print("endpoint",endpoint)
                        remaining.remove(endpoint) #don't visit this vertex again           


                        reachable.append(endpoint)

                        #next concatenate corresponding variable with current claw relation
                        previous_subword=claw_relations[current].copy()
                        #print('previous_subword',previous_subword)
                        #print('new generator to add to subword',[j,current])              
                        claw_relations.update({endpoint: previous_subword})
                        claw_relations[endpoint].append([j,current,1])

                        #print("remaining",remaining)
                        #print("reachable",reachable)
                        #print("claw_relations",claw_relations)


        #print("final claw relations",claw_relations)
        
        claw_relations_list=list(claw_relations.values())
        
        return claw_relations_list
    
    def claw_relations_reindex(self):
        relations_sub_sup_exp=self.claw_relations_sub_sup_exp()
        relations_list=[]
        for relation_sub_sup_exp in relations_sub_sup_exp:
            relation_reindexed=[]
            for triple in relation_sub_sup_exp:
                (sub, sup, exp) = triple
                new_subscript= (( (sub + self.F.rank() * (sup - 1)))+1)*exp
                relation_reindexed.append(new_subscript)
            relations_list.append(relation_reindexed)
        group_relations_list=[]
        for reln in relations_list:
            group_relations_list.append(self.coverF(reln))
        return group_relations_list
    
    def unbranchedtobranched_relations_sub_sup_exp(self):
        # Powers of meridians
        
        n=self.S.degree()
        g=self.F.rank()
        
        relations=[]
        for j in range(g): #go through all generators x_j
            #image=self.representation(self.F([j]))
            #startingvertex=1
            #remainingvertices=[i for i in range(2,n+1)]
            
            #endpoint=self.representation(self.F([j]))(1)
            #relations.append([j,startingvertex])
           # while !(endpoint=startingvertex):
                
               # endpoint=self.representation(self.F([j]))(endpoint)
               # relations.append
                
            cycles=self.representation(self.F([j+1])).cycle_tuples(singletons=True)
            #basepoints=[]
            
            for cycle in cycles:
                #basepoints.append(cycle[0])
                #k=len(cycle)
                cycle_relation=[]
                for i in range(len(cycle)):
                    cycle_relation.append([j,cycle[i],1])
                relations.append(cycle_relation)
                
                
        return relations
                
    def unbranchedtobranched_relations_reindex(self):
        relations_sub_sup_exp=self.unbranchedtobranched_relations_sub_sup_exp()
        relations_list=[]
        for relation_sub_sup_exp in relations_sub_sup_exp:
            relation_reindexed=[]
            for triple in relation_sub_sup_exp:
                (sub, sup, exp) = triple
                new_subscript= (( (sub + self.F.rank() * (sup - 1)))+1)*exp
                relation_reindexed.append(new_subscript)
            relations_list.append(relation_reindexed)
        group_relations_list=[]
        for reln in relations_list:
            group_relations_list.append(self.coverF(reln))
        return group_relations_list
    
    
    def all_cover_relations(self):
        lift_relations=self.lift_relations_reindex()
        claw_relations=self.claw_relations_reindex()
        unbranchedtobranched_relations=self.unbranchedtobranched_relations_reindex()
        return lift_relations + claw_relations + unbranchedtobranched_relations
    
    def convert_index(self, triple_sub_sup_exp):
        (sub, sup, exp) = triple_sub_sup_exp
        return exp * (sub + self.F.rank() * (sup - 1))         
                
            
        
    
 #   def reidemeister_schreier(self):
        #return lifted relations, claw relations, and branch relations together
        
        
        
        
        
        
        # We can integrate it into the python classes later
        

#class Colored_bridge_trisection:
    
    
    
class Group_Trisection:
    def __init__(self, F: FreeGroup, S: SymmetricGroup, C: Colored_trivial_tangle):
        self.F = F
        self.S = S
        self.C = C
        self.big_group_F = FreeGroup(self.F.rank() * self.S.degree())

    # To get the group element in the big group corresponding to a pair
    # group_trisection_trefoil.big_group_F([group_trisection_trefoil.convert_index((-2, 3))])
    #def convert_index(self, pair_sub_sup):
    #    (sub, sup) = pair_sub_sup
    #    return sign(sub) * (abs(sub) + self.F.rank() * (sup - 1))
    def convert_index(self, triple_sub_sup_exp):
        (sub, sup, exp) = triple_sub_sup_exp
        return exp * (sub + self.F.rank() * (sup - 1))    

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
# to obtain the word in the free group
test_relation = test_F([2, -4, 1, 3])

# can get the list of indices determining the word via test_relation.Tietze()

# Constructing an example coloring to test our functions on
test_coloring = Colored_trivial_tangle(test_F, test_S, [test_relation], test_images_of_generators)

# Compute the image of test_relation under the homomorphism
test_coloring.representation(test_relation)


# new example of one of the tangles in the spun trefoil
trefoil_F = FreeGroup(8)
trefoil_S = SymmetricGroup(3)
trefoil_cover_F=FreeGroup(8*3)
# in our coloring of the spun trefoil,
# first two points map to (1, 2), all of the others to (1, 3)
trefoil_images_of_generators = ['(1, 2)', '(1, 2)', '(1, 3)', '(1, 3)', '(1, 3)', '(1, 3)', '(1, 3)', '(1, 3)']

trefoil_relation = trefoil_F([1, 6, 1, -6, -1, 3])
trefoil_coloring = Colored_trivial_tangle(trefoil_F, trefoil_S, spun_trefoil.red_tangle.relations(), trefoil_images_of_generators)
# test the function to relation
# trefoil_coloring.lift_of_single_relation(trefoil_relation, 1)
# test the function on all relations of red tangle
# trefoil_coloring.reidemeister_schreier()

group_trisection_trefoil = Group_Trisection(trefoil_F, trefoil_S, trefoil_coloring)


