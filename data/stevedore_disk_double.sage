# # # # # # # # # # # # # # # # # # # # # #
# double of the fusion number 1 ribbon disk of the stevedore
# # # # # # # # # # # # # # # # # # # # # #

# Tangles

double_6_1_red_tangle_braid_crossings_list = [
    Braid_crossing(1, 2, +1), # ribbon band left
    Braid_crossing(2, 3, +1),
    Braid_crossing(2, 3, +1), 
    Braid_crossing(1, 2, +1),
    Braid_crossing(3, 6, +1), # ribbon band right
    Braid_crossing(2, 3, +1),
    Braid_crossing(2, 3, +1), 
    Braid_crossing(3, 6, +1),
]

# no crossings in blue and green tangle for ribbon knots

double_6_1_blu_tangle_braid_crossings_list = []

double_6_1_gre_tangle_braid_crossings_list = []

# Matchings

double_6_1_red_tangle_matching_list = [(0, 3), 
                                       (1, 2),
                                       (4, 5),
                                       (6, 9),
                                       (7, 8)]

double_6_1_blu_tangle_matching_list = [(0, 1), 
                                       (2, 3),
                                       (4, 7),
                                       (5, 6),
                                       (8, 9)]

double_6_1_gre_tangle_matching_list = [(0, 1), 
                                       (2, 5),
                                       (3, 4),
                                       (6, 7),
                                       (8, 9)]

