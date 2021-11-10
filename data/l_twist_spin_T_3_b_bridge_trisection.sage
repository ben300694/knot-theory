# # # # # # # # # # # # # # # # # # # # # #
# l-twist spin of the (3, b) torus knot
# # # # # # # # # # # # # # # # # # # # # #

# Assumptions
#
# 3 and b are coprime
#
# This will result in a 7-bridge trisection


# # # # # #
# Tangles
# # # # # #

# full twist in 1, 2, 3, 6, 7
full_twist_1_2_3_6_7 = 5*[Braid_crossing(1, 2, +1), 
                          Braid_crossing(2, 3, +1),
                          Braid_crossing(3, 6, +1), 
                          Braid_crossing(6, 7, +1)]


def tau_l_T_3_b_red_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the red tangle in the l-twist spin of the (2, b) torus knot
    """
    return [Braid_crossing(7, 8, -1), Braid_crossing(6, 7, -1), Braid_crossing(8, 9, -1), Braid_crossing(7, 8, -1)] + l * full_twist_1_2_3_6_7 + [Braid_crossing(7, 8, +1), Braid_crossing(8, 9, +1), Braid_crossing(6, 7, +1)] + b * [Braid_crossing(1, 2, +1), Braid_crossing(2, 7, +1)] + [Braid_crossing(7, 8, +1)]

def tau_l_T_3_b_blu_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the blue tangle in the l-twist spin of the (3, b) torus knot
    """
    return [Braid_crossing(5, 8, -1)] + b * [Braid_crossing(1, 2, +1), Braid_crossing(2, 5, +1)] + [Braid_crossing(5, 8, +1)]

def tau_l_T_3_b_gre_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the green tangle in the l-twist spin of the (3, b) torus knot
    """
    return [Braid_crossing(7, 10, -1)] + b * [Braid_crossing(1, 4, +1), Braid_crossing(4, 7, +1)] + [Braid_crossing(7, 10, +1)]

# Matchings

# For the twist spin of the 3-bridge knot T(3, b)
# the matching of the strands at the top does not
# depend on the numbers l and b
def tau_l_T_3_b_red_tangle_matching_list(l : int, b : int):
    return [(0, 1), 
            (2, 7),
            (3, 6),
            (4, 5),
            (8, 13),
            (9, 12),
            (10, 11)]

def tau_l_T_3_b_blu_tangle_matching_list(l : int, b : int):
    return [(0, 1), 
            (2, 5),
            (3, 4),
            (6, 7),
            (8, 11),
            (9, 10),
            (12, 13)]

def tau_l_T_3_b_gre_tangle_matching_list(l : int, b : int):
    return [(0, 1), 
            (2, 3),
            (4, 7),
            (5, 6),
            (8, 9),
            (10, 13),
            (11, 12)]
