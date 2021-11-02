# # # # # # # # # # # # # # # # # # # # # #
# l-twist spin of the (2, b) torus knot
# # # # # # # # # # # # # # # # # # # # # #

# Tangles

# full twist in 1, 2, 3
full_twist_1_2_3 = [
    Braid_crossing(1, 2, +1), 
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), 
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(2, 3, +1)
]


def tau_l_T_2_b_red_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the red tangle in the l-twist spin of the (2, b) torus knot
    """
    return l * full_twist_1_2_3 + b * [Braid_crossing(1, 2, +1)]

def tau_l_T_2_b_blu_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the blue tangle in the l-twist spin of the (2, b) torus knot
    """
    return b * [Braid_crossing(1, 2, +1)]

def tau_l_T_2_b_gre_tangle_braid_crossings_list(l : int, b : int):
    """
    Returns the green tangle in the l-twist spin of the (2, b) torus knot
    """
    return b * [Braid_crossing(1, 4, +1)]

# Matchings

# For the twist spin of the 2-bridge knot T(2, b)
# the matching of the strands at the top does not
# depend on the numbers l and b
def tau_l_T_2_b_red_tangle_matching_list(l : int, b : int):
    return [(0, 2), 
            (1, 7),
            (3, 6),
            (4, 5)]

def tau_l_T_2_b_blu_tangle_matching_list(l : int, b : int):
    return [(0, 2), 
            (1, 5),
            (3, 4),
            (6, 7)]

def tau_l_T_2_b_gre_tangle_matching_list(l : int, b : int):
    return [(0, 4), 
            (1, 7),
            (2, 3),
            (5, 6)]
