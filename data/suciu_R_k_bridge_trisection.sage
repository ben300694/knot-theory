# # # # # # # # # # # # #
# R_3 in Suciu's family
# # # # # # # # # # # # #

bottom_pattern = [
                    Braid_crossing(5, 6, +1), # brown band from bottom
                    Braid_crossing(4, 5, +1),
                    Braid_crossing(4, 5, +1),
                    Braid_crossing(5, 6, +1), # t_k
                    Braid_crossing(1, 4, -1),
                    Braid_crossing(4, 5, -1),
                    Braid_crossing(4, 5, -1),
                    Braid_crossing(1, 4, -1), # d
                    Braid_crossing(5, 6, -1),
                    Braid_crossing(4, 5, -1),
                    Braid_crossing(6, 7, -1),
                    Braid_crossing(5, 6, -1), # go under t_k from left to right
                    Braid_crossing(7, 10, +1),
                    Braid_crossing(10, 11, +1),
                    Braid_crossing(6, 7, +1),
                    Braid_crossing(7, 10, +1), # over orange ribbon
                    Braid_crossing(11, 12, -1),
                    Braid_crossing(10, 11, -1),
                    Braid_crossing(10, 11, -1),
                    Braid_crossing(11, 12, -1), # c^(-1)
                    Braid_crossing(7, 10, -1),
                    Braid_crossing(10, 11, -1),
                    Braid_crossing(6, 7, -1),
                    Braid_crossing(7, 10, -1), # over orange ribbon
                    Braid_crossing(5, 6, +1),
                    Braid_crossing(6, 7, +1),
                    Braid_crossing(6, 7, +1),
                    Braid_crossing(5, 6, +1), # (t_k)^(-1)
                    Braid_crossing(7, 10, +1),
                    Braid_crossing(10, 11, +1),
                    Braid_crossing(6, 7, +1),
                    Braid_crossing(7, 10, +1), # over orange ribbon
                    Braid_crossing(11, 12, -1),
                    Braid_crossing(10, 11, -1),
                    Braid_crossing(12, 13, -1),
                    Braid_crossing(11, 12, -1) # go under c
                 ]                                    

repeating_pattern_orange_band = [ 
                                  Braid_crossing(5, 6, +1), # orange band from middle
                                  Braid_crossing(6, 7, +1),
                                  Braid_crossing(4, 5, +1),
                                  Braid_crossing(5, 6, +1), # go under t_k from right to left
                                  Braid_crossing(1, 4, -1),
                                  Braid_crossing(4, 5, -1),
                                  Braid_crossing(4, 5, -1),
                                  Braid_crossing(1, 4, -1), # d
                                  Braid_crossing(5, 6, -1),
                                  Braid_crossing(4, 5, -1),
                                  Braid_crossing(6, 7, -1),
                                  Braid_crossing(5, 6, -1), # go under t_k from left to right
                                  Braid_crossing(7, 10, -1),
                                  Braid_crossing(6, 7, -1),
                                  Braid_crossing(6, 7, -1),
                                  Braid_crossing(7, 10, -1) # c^(-1)
                                ]

top_pattern = [
                Braid_crossing(5, 6, +1),
                Braid_crossing(6, 7, +1),
                Braid_crossing(6, 7, +1),
                Braid_crossing(5, 6, +1), # t_k
              ]

def R_k_red_tangle_braid_crossings_list(k):
    return bottom_pattern + (k-1)*repeating_pattern_orange_band + top_pattern
                                          
                                          

# There are no crossings in the bridge position
# of Suciu's knots R_k that we are using,
# in particular the following function are independent of k
def R_k_blu_tangle_braid_crossings_list(k):
    return []
def R_k_gre_tangle_braid_crossings_list(k):
    return []

# For Suciu's examples,
# the matching of the tangle strands at the top
# does not depend on the parameter k
def R_k_red_tangle_matching_list(k):
    return [(0, 7), 
            (1, 6),
            (2, 3),
            (4, 5),
            (8, 9),
            (10, 13),
            (11, 12)]

def R_k_blu_tangle_matching_list(k):
    return [(0, 1), 
            (2, 5),
            (3, 4),
            (6, 7),
            (8, 11),
            (9, 10),
            (12, 13)]

def R_k_gre_tangle_matching_list(k):
    return [(0, 3), 
            (1, 2),
            (4, 5),
            (6, 9),
            (7, 8),
            (10, 11),
            (12, 13)]
