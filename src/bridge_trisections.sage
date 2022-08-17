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

#Representations to S_p for p odd

#BS(1,2)=<A,B|BAB^-1=A^2>
#homomorphism sending A-->a, B-->b, a, b in S_p where
#a=(1,...,p) p odd
#G=image subgroup


def BS12_to_Sp(p):
    S_p=SymmetricGroup(p)

    a_list_br=[(i+1)%p+1 for i in range(p)] #p-cycle in bottom row notation
    a_list_cycle=[(i+1) for i in range(p)]
    a_dict={i+1:i+1 for i in range(p)}
    a_sq_list=[(2*i)%p +1 for i in range(p)]
    a_sq_inverse_dict={(2*i)%p +1:i+1 for i in range(p)} #inverse dictionary representing a^2 in cycle notation

    b_list_br=[a_dict[a_sq_inverse_dict[i+1]] for i in range(p)] #b in bottom row notation

    #convert lists to bottom-row notation and then symmetric group elements in cycle notation
    a=S_p(Permutation(a_list_br)) 
    b=S_p(Permutation(b_list_br))
    
    return [a,b]

def double_6_1_images_of_generators(p):
    [a,b]=BS12_to_Sp(p)
    g_1=a^-1*b
    g_2=b
    #g_1=b^-1*a
    #g_2=b^-1

    double_6_1_images_of_generators = [g_1,g_1^-1]+4*[g_2,g_2^-1]
    return double_6_1_images_of_generators

def double_6_1_colored_tangles(p):
    stevedore_F = FreeGroup(10)
    stevedore_S = SymmetricGroup(p)
    
    [a,b]=BS12_to_Sp(p)
    g_1=a^-1*b
    g_2=b
    #g_1=b^-1*a
    #g_2=b^-1

    double_6_1_images_of_generators = [g_1,g_1^-1]+4*[g_2,g_2^-1]
    
    double_6_1_coloring_red = Colored_trivial_tangle(stevedore_F, stevedore_S, double_6_1.red_tangle.relations(), double_6_1_images_of_generators)
    double_6_1_coloring_blu = Colored_trivial_tangle(stevedore_F, stevedore_S, double_6_1.blu_tangle.relations(), double_6_1_images_of_generators)
    double_6_1_coloring_gre = Colored_trivial_tangle(stevedore_F, stevedore_S, double_6_1.gre_tangle.relations(), double_6_1_images_of_generators)
    
    return double_6_1_coloring_red, double_6_1_coloring_blu, double_6_1_coloring_gre

def double_6_1_colored_surface(p):
    stevedore_F = FreeGroup(10)
    stevedore_S = SymmetricGroup(p)
    
    [a,b]=BS12_to_Sp(p)
    g_1=a^-1*b
    g_2=b
    #g_1=b^-1*a
    #g_2=b^-1

    double_6_1_images_of_generators = [g_1,g_1^-1]+4*[g_2,g_2^-1]
    return Colored_punctured_surface(stevedore_F,stevedore_S, double_6_1_images_of_generators)

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

class Colored_punctured_surface:
    """
    Attributes
    ----------
    F: Free group containing the generators (in our case x_0, ... x_{2b-1})
    S: Symmetric group used as the codomain for the coloring
    
    images_of_generators:
        list of elements of the symmetric group S specifying the images of the generators of F
        We are always assuming that the representation is transitive,
        so that we obtain a connected cover.
    """
    
    def __init__(self, F: FreeGroup, S: SymmetricGroup, images_of_generators=[]):
        self.F=F
        self.S=S
        # construct homomorphism F --> S from the list images_of_generators
        self.representation = self.F.hom([self.S(g) for g in images_of_generators])
        self.coverF=FreeGroup(rank(self.F)*self.S.degree())
        # punctured surface relation
        #self.relation=self.F([-i for i in range(1,rank(self.F)+1)])
        self.relation=self.F([i for i in range(1,rank(self.F)+1)]) #this is consistent with above bridge trisections class
        
    def __repr__(self) -> str:
        return str(self.__dict__)
    
    def is_representation(self):
        #Check that surface relation is satisfied
        return self.representation.image(self.relation)==self.S.identity()
    
    def claw_relations_endpt_sub_sup_exp_dict(self):
        
        #Returns a dictionary.  Each entry is of the form {endpoint,relation}.  When relation is lifted beginning at vertex 1, it ends at endpoint.  Relation is expressed as a list of triples [sub,sup,exp], corresponding to the generator (x_sub^sup)^exp, where exp=+/- 1

        #F=FreeGroup(g)
        #Free group with generators x0,x1,...,x(g-1)

        n=self.S.degree()
        g=self.F.rank()
        
        
        #vertices p1,p2,p3,... note indexing starts at 1 to match symmetric group

        
        reachable=[1]
        remaining=[i for i in range(2,n+1)] #vertices remaining to be visited
        
        claw_relations={1:[]}


        while len(remaining)>0:

            for current in reachable:
                
                reachable.remove(current)

                for j in range(g): #j is the subscript of x_j.  

                    #Determine which vertices you can reach from current from each of the generators x_0,...,x_g-1
                   
                    
                    endpoint=self.representation(self.F([j+1]))(current)

                    #check if the endpoint vertex has been visited.  If not (i.e., if in remaining)...
                    if( endpoint in remaining):
                        
                        remaining.remove(endpoint) #don't visit this vertex again  
                        reachable.append(endpoint)
                        #next concatenate corresponding variable with current claw relation
                        previous_subword=claw_relations[current].copy()                                    
                        claw_relations.update({endpoint: previous_subword})
                        claw_relations[endpoint].append([j,current,1])

        return claw_relations
    
    def claw_relations_reindex(self):
        relations_sub_sup_exp=list(self.claw_relations_endpt_sub_sup_exp_dict().values())
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
            
                
            cycles=self.representation(self.F([j+1])).cycle_tuples(singletons=True)
            
            
            for cycle in cycles:
                
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
    
    def claw_collapse_hom(self):
        #returns the homomorphism from self.pi_1_unbranched() to itself determined by collapsing the claw
         
        images_list=[self.coverF([]) for i in range(rank(self.coverF))]
        for sub in range(rank(self.F)):
            for sup in range(1,self.S.degree()+1):
        
                
                generator_reindex_subscript=( (sub + self.F.rank() * (sup - 1)))
                endpoint=self.representation(self.F([sub+1]))(sup)
                
                claw_dict=self.claw_relations_endpt_sub_sup_exp_dict()
                left_word_sub_sup_exp=claw_dict[sup]
                
                left_word=[]
                for gen in left_word_sub_sup_exp:
                    # for each generator in the word, find its reindexed subscript.
                    # Add 1 because will use as index in free group.
                    left_word.append((( (gen[0] + self.F.rank() * (gen[1] - 1))))*gen[2]+1)
                    

                right_word_sub_sup_exp=self.claw_relations_endpt_sub_sup_exp_dict()[endpoint]
                right_word=[]
                for gen in right_word_sub_sup_exp:              
                    # for each generator in the word, find its reindexed subscript.
                    # Add 1 because will use as index in free group.
                    right_word.append((( (gen[0] + self.F.rank() * (gen[1] - 1))))*gen[2]+1) 
                
                                        
                
                    
                #generator_image = self.coverF(left_word) * \
                #                    self.coverF([generator_reindex_subscript+1]) * \
                #                        self.coverF(right_word)^-1
                generator_image = self.pi_1_unbranched()(left_word) * \
                                    self.pi_1_unbranched()([generator_reindex_subscript+1]) * \
                                        self.pi_1_unbranched()(right_word)^-1
               
                images_list[generator_reindex_subscript]=generator_image
                                            
        #hom=self.coverF.hom(images_list)
        hom=self.pi_1_unbranched().hom(images_list)
        
        return hom
    
    def pi_1_punctured_sphere(self):
        return self.F.quotient([self.relation])
    
    def covering_hom(self):
        #returns the homomorphism from self.pi_1_unbranched() to self.pi_1_punctured_sphere() induced by covering map, after claw collapse
        images_list=[]
        collapse_hom=self.claw_collapse_hom()
        for g in range(rank(self.coverF)):
            upstairs=list(collapse_hom.image(self.pi_1_unbranched()([g+1])).Tietze())
            
            downstairs=[(((abs(x)-1) % rank(self.F))+1)*sign(x) for x in upstairs]
            
            images_list.append(self.pi_1_punctured_sphere()(downstairs))
        hom=self.pi_1_unbranched().hom(images_list)
        return hom
    
    
    
    def single_lift_relation_sub_sup_exp(self,starting_sheet):
        current_sheet = starting_sheet
        list_of_sheets = [starting_sheet]
        for current_letter in self.relation.Tietze():
            current_sheet = self.representation(self.F([current_letter]))(current_sheet)
            list_of_sheets.append(current_sheet)
        list_of_pairs = []        
        for i, current_letter in enumerate(self.relation.Tietze()):
            subscript = current_letter
            if sign(current_letter) == +1:
                superscript = list_of_sheets[i]
            elif sign(current_letter) == -1:
                superscript = list_of_sheets[i+1]
            list_of_pairs.append((subscript, superscript))
        list_of_triples=[]
        for pair in list_of_pairs:
            # fixes off by one error in subscript,
            # moves sign of exponent to third entry
            # each triple is (superscript,subscript,exponent (+/-1))
            list_of_triples.append([abs(pair[0])-1,pair[1],sign(pair[0])]) 
        return list_of_triples

    def single_lift_relation_reindex(self, starting_sheet):
        relationtriples=self.single_lift_relation_sub_sup_exp(starting_sheet)
        rel=[]
        for triple in relationtriples:
            (sub, sup, exp) = triple
            new_subscript= (( (sub + self.F.rank() * (sup - 1)))+1)*exp
            
            rel.append(new_subscript)
        return self.coverF(rel)
    
    def lift_relation_reindex(self):
        list_of_lifted_relations=[]
        rel=self.relation
        # self.S.degree() is the rank of the symmetric group = number of sheets
        for i in range(0, self.S.degree()):
            rel_lifted = self.single_lift_relation_reindex(i+1)
            # i+1 because sheets are indexed starting from 1
            list_of_lifted_relations.append(rel_lifted)
        
        return list_of_lifted_relations
    
    def pi_1_branched(self):
        return self.coverF.quotient(self.unbranchedtobranched_relations_reindex()+self.claw_relations_reindex()+self.lift_relation_reindex())
         
    def pi_1_unbranched(self):
        return self.coverF.quotient(self.claw_relations_reindex()+self.lift_relation_reindex())
    
    def genus_branched_cover(self):
        pi_1=self.pi_1_branched()
        return len(pi_1.abelian_invariants())/2
    
    
    
    def in_cyclic_order(self,cyclic_list):
        
        min_reached=false
        for i in range(len(cyclic_list)):
            if i != len(cyclic_list)-1:
            
                if cyclic_list[i] > cyclic_list[i+1]:
                    if min_reached==true:
                        return false
                    elif min_reached==false:
                        min_reached=true
                elif cyclic_list[i] == cyclic_list[i+1]:
                    return false
            elif i == len(cyclic_list)-1:
                if cyclic_list[i]> cyclic_list[0]:
                    if min_reached==true:
                        return false
                    elif min_reached==false:
                        min_reached=true
                elif cyclic_list[i] == cyclic_list[0]:
                    return false
                
        return true
                
            
    def cyclic_word_sheet_incoming_outgoing_list(self, cyclic_word):
        #Subroutine for computing intersection numbers of curves
        
        #Given  a cyclic word in self.F which lifts to a cyclic word in the cover,
        #return a list of basepoint indices (sheet indices) through which the word passes.
        #For each sheet index k, also return a list of pairs (i,j) of integers in {0,...,2*rank(self.F)-1} 
        #where the corresponding curve enters a 2-ball neighborhood U_k of p_k at position i and leaves at position j
        #Positions labelled clockwise around the boundary of U_k    
        sheet_inc_out_list=[[] for i in range(self.S.degree())]
        
        
        
        for i in range(len(cyclic_word.Tietze())):
            index=cyclic_word.Tietze()[i]          
            sub=(abs(index)-1) % rank(self.F) 
            sup=(abs(index)-1)//rank(self.F)+1 
            sign=sgn(index)
              
            
            if i==0:
                prev_index=cyclic_word.Tietze()[len(cyclic_word.Tietze())-1] 
            elif i!=0:
                prev_index=cyclic_word.Tietze()[i-1] 
            prev_sub=(abs(prev_index)-1) % rank(self.F) 
            prev_sup=(abs(prev_index)-1)//rank(self.F)+1 
            prev_sign=sgn(prev_index)           
                       
            if sign==1:
                sheet=sup
                #outgoing=2*sub+1
                outgoing=2*sub
            elif sign==-1:
                sheet=self.representation(self.F([sub+1]))(sup)
                #outgoing=2*sub
                outgoing=2*sub+1
            if prev_sign==1:
                #incoming=2*prev_sub
                incoming=2*prev_sub+1
            elif prev_sign==-1:
                #incoming=2*prev_sub+1
                incoming=2*prev_sub
            
            sheet_inc_out_list[sheet-1].append([sheet, incoming,outgoing])
                       
        return sheet_inc_out_list
                       
            
                       
            
                       
                       
    
    def intersection_number(self,word_1,word_2):
        #compute the algebraic intersection number of two cyclic words in the branched cover,
        #which are lifts of cyclic words on the surface
        
        sheet_inc_out_1=self.cyclic_word_sheet_incoming_outgoing_list(word_1)
        sheet_inc_out_2=self.cyclic_word_sheet_incoming_outgoing_list(word_2)
        intersection_number=0
        
        for sheet in range(1,self.S.degree()+1):
            for (s,in_1,out_1) in sheet_inc_out_1[sheet-1]:
                for (s, in_2,out_2) in sheet_inc_out_2[sheet-1]:
                    
                    #incoming and outgoing arrows have 4 distinct endpoints
                    
                    if len(set([in_1,in_2,out_1,out_2]))==4:
                        #print("case 4")
                        if self.in_cyclic_order([in_1,out_2,out_1,in_2])==true:
                            local_intersection=1
                        elif self.in_cyclic_order([in_2,out_1,out_2,in_1])==true:
                            local_intersection=-1
                        elif self.in_cyclic_order([in_1,out_1,out_2,in_2])==true:
                            local_intersection=0
                        elif self.in_cyclic_order([in_1,out_1,in_2,out_2])==true:
                            local_intersection=0
                        elif self.in_cyclic_order([out_1,in_1,out_2,in_2])==true:
                            local_intersection=0
                        elif self.in_cyclic_order([out_1,in_1,in_2,out_2])==true:
                            local_intersection=0
                            
                        else:
                            raise Exception("linking case not accounted for; 4 endpoints")
                    
                    #incoming and outgoing arrows have 3 distinct endpoints
                    
                    elif len(set([in_1,in_2,out_1,out_2]))==3:
                        #print("case 3")
                        
                        if out_1==out_2:
                            if self.in_cyclic_order([in_2,in_1,out_1])==true:
                                local_intersection=1
                            elif self.in_cyclic_order([in_1,in_2,out_1])==true:
                                local_intersection=0
                            else:
                                raise Exception("linking case not accounted for; 3 endpoints")
                        elif in_1==in_2:
                            if self.in_cyclic_order([in_2,out_2,out_1])==true:
                                local_intersection=0
                            elif self.in_cyclic_order([in_2,out_1,out_2])==true:
                                local_intersection=-1
                            else:
                                raise Exception("linking case not accounted for; 3 endpoints")
                        elif in_1==out_2:
                            if self.in_cyclic_order([in_1,in_2,out_1])==true:
                                local_intersection=0
                            elif self.in_cyclic_order([in_1,out_1,in_2])==true:
                                local_intersection=1
                            else:
                                raise Exception("linking case not accounted for; 3 endpoints")
                        elif out_1==in_2:
                            if self.in_cyclic_order([out_1,out_2,in_1])==true:
                                local_intersection=-1
                            elif self.in_cyclic_order([out_1,in_1,out_2])==true:
                                local_intersection=0
                            else:
                                raise Exception("linking case not accounted for; 3 endpoints")
                        elif in_1==out_1:
                            local_intersection=0
                        elif in_2==out_2:
                            local_intersection=0
                        else:
                            raise Exception("linking case not accounted for; 3 endpoints")
                        
                            
                                
                    #incoming and outgoing arrows have 2 distinct endpoints
                    
                    elif len(set([in_1,in_2,out_1,out_2]))==2:
                        #print("case 2")
                        
                        #3 endpoints match
                        if len(set([in_1,out_1,in_2]))==1:
                            local_intersection=-1
                        elif len(set([in_1,out_1,out_2]))==1:
                            local_intersection=1
                        elif len(set([in_2,out_2,in_1]))==1:
                            local_intersection=0
                        elif len(set([in_2,out_2,out_1]))==1:
                            local_intersection=0
                            
                        #2 endpoints match
                        elif in_1==out_1 and in_2==out_2:
                            local_intersection=0
                        elif in_1==in_2 and out_1==out_2:
                            local_intersection=0
                        elif in_1==out_2 and out_1==in_2:
                            local_intersection=0
                        
                        else:
                            raise Exception("linking case not accounted for; 2 endpoints")
                        
                        
                            
                            
                    #incoming and outgoing arrows have 1 distinct endpoint
                    
                    elif len(set([in_1,in_2,out_1,out_2]))==1:
                        #print("case 1")
                        
                        local_intersection=0
                    
                    intersection_number+=local_intersection
        return intersection_number
    
    def intersection_matrix(self):
        #returns matrix of algebraic intersection numbers of generators of self.coverF after application of claw homomorphism
        
        claw_hom=self.claw_collapse_hom()
        dim = rank(self.coverF)
        
        M=Matrix(dim)
        
        for i in range(dim):
            for j in range(dim):
                M[i,j]=self.intersection_number(claw_hom.image(self.pi_1_unbranched().gens()[i]),claw_hom.image(self.pi_1_unbranched().gens()[j]))
        
        return M
                        
                    
                
        
        
    
    
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
        self.coverF = FreeGroup(self.F.rank() * self.S.degree())
        self.surface = Colored_punctured_surface(self.F,self.S,images_of_generators)

    def __repr__(self) -> str:
        return str(self.__dict__)
    
    def is_representation(self):
        for reln in self.relations_source:
            if self.representation(reln)!=self.S.identity():
                return false
        return true

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
            # fixes off by one error in subscript,
            # moves sign of exponent to third entry
            list_of_triples.append([abs(pair[0])-1,pair[1],sign(pair[0])])
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
    
   
    def all_cover_relations(self):
        lift_relations=self.lift_relations_reindex()
        claw_relations=self.surface.claw_relations_reindex()
        unbranchedtobranched_relations=self.surface.unbranchedtobranched_relations_reindex()
        return lift_relations + claw_relations + unbranchedtobranched_relations
    
    def convert_index(self, triple_sub_sup_exp):
        (sub, sup, exp) = triple_sub_sup_exp
        return exp * (sub + self.F.rank() * (sup - 1))         
                
            
    def handlebody_group(self):
        return self.coverF.quotient(self.all_cover_relations())
    
    def check_handlebody_group_is_free(self):
        group=self.handlebody_group()
        is_free=True
        if group.simplified().relations() != ():
            is_free=False
            
        return is_free
   
    def handlebody_genus(self):
        group=self.handlebody_group()
        Z_factors=group.abelian_invariants()
        return len(Z_factors)
    
    def handlebody_group_unbranched(self):
        return self.coverF.quotient(self.lift_relations_reindex() + self.surface.claw_relations_reindex())
    
            
class Colored_bridge_trisection:
    def __init__(self, F: FreeGroup, S: SymmetricGroup, tangles_dict, images_of_generators):
        """
        Parameters:
            tangles_dict: dictionary of trivial tangles; will get assigned the coloring determined by
                            images_of_generators
            images_of_generators: list of images of the puncture generators in the symmetric group 
        """
        self.F = F
        self.S = S
        
        self.coverF = FreeGroup(self.F.rank() * self.S.degree())
        
        self.colored_tangles = {}
        for (key, value) in tangles_dict.items():
            self.colored_tangles[key] = Colored_trivial_tangle(self.F, 
                                                               self.S, 
                                                               value.relations(), 
                                                               images_of_generators)
        self.surface = Colored_punctured_surface(self.F,self.S,images_of_generators)
        
        return
    
    def pi_1_branched_cover(self):
        all_relations = []
        for colored_tangle in self.colored_tangles.values():
            # print(colored_tangle.all_cover_relations())
            # group of branched cover of handlebody:
            # print(colored_tangle.coverF.quotient(colored_tangle.all_cover_relations()))
            all_relations.extend(colored_tangle.all_cover_relations())
        
        # print(all_relations)
        pi_1_branched_cover = self.coverF.quotient(all_relations)
        return pi_1_branched_cover
    
    def pi_1_unbranched_cover(self):
        all_relations = []
        for colored_tangle in self.colored_tangles.values():
            # print(colored_tangle.all_cover_relations())
            # group of branched cover of handlebody:
            # print(colored_tangle.coverF.quotient(colored_tangle.all_cover_relations()))
            all_relations.extend(colored_tangle.surface.claw_relations_reindex())
            all_relations.extend(colored_tangle.lift_relations_reindex())
        
        # print(all_relations)
        pi_1_branched_cover = self.coverF.quotient(all_relations)
        return pi_1_branched_cover
    
    def pi_1_branched_cover_handlebodies(self):
        groups_dict={}
        for (key,value) in self.colored_tangles.items():            
            groups_dict.update({key:value.handlebody_group()})
        return groups_dict
    
    def pi_1_branched_cover_3_manifolds(self):
        colored_tangles_list = list(self.colored_tangles)

        consecutive_pairs_keys = [(colored_tangles_list[-1], colored_tangles_list[0])] \
                                    + [(colored_tangles_list[i], colored_tangles_list[i + 1])
                                            for i in range(len(list(colored_tangles_list)) - 1)]
        
        groups_dict={}
        for first, second in consecutive_pairs_keys:
            rels = self.colored_tangles[first].all_cover_relations() + \
                        self.colored_tangles[second].all_cover_relations()
            group = self.coverF.quotient(rels)
            groups_dict[(first, second)]=group
        return groups_dict
    
    def check_pi_1_branched_cover_3_manifolds_free(self):
        colored_tangles_list = list(self.colored_tangles)

        consecutive_pairs_keys = [(colored_tangles_list[-1], colored_tangles_list[0])] \
                                    + [(colored_tangles_list[i], colored_tangles_list[i + 1])
                                            for i in range(len(list(colored_tangles_list)) - 1)]

        for first, second in consecutive_pairs_keys:
            rels = self.colored_tangles[first].all_cover_relations() + \
                        self.colored_tangles[second].all_cover_relations()
            group = self.coverF.quotient(rels)
            if group.simplified().relations() != ():
                print(False)
                continue
            print(True)
            
    def trisection_parameters_branched_cover(self):
        groups_dict = self.pi_1_branched_cover_3_manifolds()
        handlebody_genus_list_4D=[]
        for (key, group) in groups_dict.items():
            handlebody_genus_list_4D.append(len(group.abelian_invariants()))
        
        handlebody_genus_list_3D=[]
        for (key,tangle) in self.colored_tangles.items():
            handlebody_genus_list_3D.append(tangle.handlebody_genus())
       
        g=self.surface.genus_branched_cover()
        match=True
        for i in range(len(handlebody_genus_list_3D) ):
            if handlebody_genus_list_3D[i] != g:
                print('Parameter mismatch: 3D-handlebody genus')
                print('Handlebody genera:', handlebody_genus_list_3D)
                print('Core surface genus:', g)
                match=False
        if match==True:
            return [g, handlebody_genus_list_4D]

        

    
    def H_1_handlebodies(self):
        groups_dict=self.pi_1_branched_cover_handlebodies()
        p_matrix_dict={}
        H_1_dict={}
        
        
        free_module=span(matrix.identity(rank(self.coverF)).columns())
        
        for (key,group) in groups_dict.items():
            
            p_matrix_dict.update({key:presentation_matrix(self.coverF,group.relations())})
        
        for (key, group) in groups_dict.items():
            
            
            relation_submodule=span(p_matrix_dict[key].columns())
            H_1_module=free_module/relation_submodule
            H_1_dict.update({key:H_1_module})
        return free_module, H_1_dict
    
    
    
    def inclusion_maps_tripod(self):
        free_module=self.H_1_handlebodies()[0]
        groups_dict=self.H_1_handlebodies()[1] 
        
        
        surface_relation_submodule=span(presentation_matrix(self.coverF,self.surface.pi_1_branched().relations()).columns())
        
        surface_module=free_module/surface_relation_submodule
                         
        
        
        #in order to construct morphisms from central surface to each handlebody, 
        #need the free module presented as a trivial quotient of itself

        zero_vector=[0 for i in range(rank(self.coverF))]
        trivial_module=free_module.span([zero_vector])
        free_module_quotient_form=free_module/trivial_module
        surface_quotient_map=free_module_quotient_form.hom([surface_module(free_module_quotient_form.gen(i))for i in range(rank(self.coverF))])

        
        inclusion_dict={}
        
        for (key,group) in groups_dict.items():
            quotient_map=free_module_quotient_form.hom([groups_dict[key](free_module_quotient_form.gen(i)) for i in range(rank(self.coverF))])
            
            
            inclusion_map=surface_module.hom([quotient_map(surface_quotient_map.lift(gen)) for gen in surface_module.gens()])
                  
            inclusion_dict.update({key:inclusion_map})
                     
        return inclusion_dict
    
    def lagrangians(self):
        inclusion_dict = self.inclusion_maps_tripod()
        lag_dict = {}
        for (key, value) in inclusion_dict.items():
            lag_dict.update({key : value.kernel()})
        return lag_dict
            
    
    def H_2_branched_cover(self):
        inclusion_maps_dict=self.inclusion_maps_tripod()
        
        #Cannot compute intersection of submodules of finitely generated modules
        #To intersect the Lagrangians, re-build each as a submodule of a free module
        
        
        free_module=self.H_1_handlebodies()[0]
        surface_relation_submodule=span(presentation_matrix(self.coverF,self.surface.pi_1_branched().relations()).columns())
        
        surface_module=free_module/surface_relation_submodule
        surface_free=ZZ^len(surface_module.gens())
        
        #in order to construct morphisms from central surface to each handlebody, 
        #need the free module presented as a trivial quotient of itself

        zero_vector=[0 for i in range(rank(self.coverF))]
        trivial_module=free_module.span([zero_vector])
        free_module_quotient_form=free_module/trivial_module
        surface_quotient_map=free_module_quotient_form.hom([surface_module(free_module_quotient_form.gen(i))for i in range(rank(self.coverF))])
        
        
        #Express basis for each Lagriangian (kernel of inclusion map into handlebody) in terms of surface module basis
        
        lag_surface_basis_dict={}
        
        for (key,value) in inclusion_maps_dict.items():
            lag_surface_module_basis=[]
            for k in value.kernel().gens():
                lag_surface_module_basis.append(surface_quotient_map(surface_quotient_map.lift(k)))
                
            lag=surface_free.span([list(lag_surface_module_basis[i]) for i in range(len(lag_surface_module_basis))],ZZ)
            lag_surface_basis_dict.update({key:lag})
            
            
        sum_red_blu=lag_surface_basis_dict['red']+lag_surface_basis_dict['blu']
        intersection_blu_gre=lag_surface_basis_dict['blu'].intersection(lag_surface_basis_dict['gre'])
        intersection_gre_red=lag_surface_basis_dict['gre'].intersection(lag_surface_basis_dict['red'])
        
        
        #https://arxiv.org/pdf/1711.04762.pdf Thm 3.6 p.9
        
        H_2_numerator=lag_surface_basis_dict['gre'].intersection(sum_red_blu)
        
        H_2_denominator=intersection_blu_gre+intersection_gre_red
        
        return H_2_numerator/H_2_denominator
        
            
        
#Determine the presentation matrix corresponding to the abelianization of a finitely presented group
def presentation_matrix(F,relations):
    num_gens=rank(F)
    num_relns=len(relations)
    
    presentation_matrix=[[0 for j in range(num_relns)] for i in range(num_gens)]
    for j in range(num_relns):
        reln=relations[j]
        subscript_list=reln.Tietze()
    
        for k in range(len(subscript_list)):
        
            presentation_matrix[abs(subscript_list[k])-1][j]+=sgn(subscript_list[k])
    return matrix(presentation_matrix)  
                 
        
        
        
        
            

