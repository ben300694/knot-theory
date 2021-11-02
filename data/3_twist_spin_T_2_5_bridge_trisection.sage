# # # # # # # # # # # # # # # # # # # # # #
# 3-twist spin of the (2, 5) torus knot
# # # # # # # # # # # # # # # # # # # # # #

# Tangles

tau_3_T_2_5_red_tangle_braid_crossings_list = [
    Braid_crossing(1, 2, +1), # full twist in 1, 2, 3
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), 
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), # full twist in 1, 2, 3
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), 
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), # full twist in 1, 2, 3
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), 
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(2, 3, +1),
    Braid_crossing(1, 2, +1), # 5 half twists between 1, 2
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
]

tau_3_T_2_5_blu_tangle_braid_crossings_list = [
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1),
    Braid_crossing(1, 2, +1)
]

tau_3_T_2_5_gre_tangle_braid_crossings_list = [
    Braid_crossing(1, 4, +1),
    Braid_crossing(1, 4, +1),
    Braid_crossing(1, 4, +1),
    Braid_crossing(1, 4, +1),
    Braid_crossing(1, 4, +1)
]

# Matchings

tau_3_T_2_5_red_tangle_matching_list = [(0, 2), 
                                        (1, 7),
                                        (3, 6),
                                        (4, 5)]

tau_3_T_2_5_blu_tangle_matching_list = [(0, 2), 
                                        (1, 5),
                                        (3, 4),
                                        (6, 7)]

tau_3_T_2_5_gre_tangle_matching_list = [(0, 4), 
                                        (1, 7),
                                        (2, 3),
                                        (5, 6)]
