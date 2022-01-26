sign = lambda x: x and (1, -1)[x<0]

# # # # # # # # # # # # # # # # # # # # # #
# l-twist spin of the (2, n) torus knot
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


def tau_l_T_2_b_red_tangle_braid_crossings_list(l : int, n : int):
    """
    Parameters:
        l: number of twists (required to be positive integer)
        n: Second parameter of torus knot T(2, n)
    
    Returns:
        The generalized braid word of the red tangle in the l-twist spin of the (2, n) torus knot
    """
    return l * full_twist_1_2_3 + abs(n) * [Braid_crossing(1, 2, sign(n))]

def tau_l_T_2_b_blu_tangle_braid_crossings_list(l : int, n : int):
    """
    Parameters:
        l: number of twists (required to be positive integer)
        n: Second parameter of torus knot T(2, n)
    
    Returns:
        The generalized braid word of the blue tangle in the l-twist spin of the (2, n) torus knot
    """
    return abs(n) * [Braid_crossing(1, 2, sign(n))]

def tau_l_T_2_b_gre_tangle_braid_crossings_list(l : int, n : int):
    """
    Parameters:
        l: number of twists (required to be positive integer)
        n: Second parameter of torus knot T(2, n)
    
    Returns:
        The generalized braid word of the green tangle in the l-twist spin of the (2, n) torus knot
    """
    return abs(n) * [Braid_crossing(1, 4, sign(n))]

# Matchings

# For the twist spin of the 2-bridge knot T(2, n)
# the matching of the strands at the top does not
# depend on the numbers l and n
def tau_l_T_2_b_red_tangle_matching_list(l : int, n : int):
    return [(0, 1), 
            (2, 7),
            (3, 6),
            (4, 5)]

def tau_l_T_2_b_blu_tangle_matching_list(l : int, n : int):
    return [(0, 1), 
            (2, 5),
            (3, 4),
            (6, 7)]

def tau_l_T_2_b_gre_tangle_matching_list(l : int, n : int):
    return [(0, 1), 
            (4, 7),
            (2, 3),
            (5, 6)]
