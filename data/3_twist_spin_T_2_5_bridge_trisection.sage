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

tau_3_T_2_5_red_tangle_matching_list = [(0, 1), 
                                        (2, 7),
                                        (3, 6),
                                        (4, 5)]

tau_3_T_2_5_blu_tangle_matching_list = [(0, 1), 
                                        (2, 5),
                                        (3, 4),
                                        (6, 7)]

tau_3_T_2_5_gre_tangle_matching_list = [(0, 1), 
                                        (4, 7),
                                        (2, 3),
                                        (5, 6)]
                                        
# To import this into your SageMath project use                                        
                                        
#attach('data/3_twist_spin_T_2_5_bridge_trisection.sage')
#
#tau_3_T_2_5 = Bridge_Trisection(4)
#
#tau_3_T_2_5.red_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                   free_group=tau_3_T_2_5.F,
#                                                   braid_word=tau_3_T_2_5_red_tangle_braid_crossings_list,
#                                                   strand_matching=tau_3_T_2_5_red_tangle_matching_list)
#tau_3_T_2_5.blu_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                   free_group=tau_3_T_2_5.F,
#                                                   braid_word=tau_3_T_2_5_blu_tangle_braid_crossings_list,
#                                                   strand_matching=tau_3_T_2_5_blu_tangle_matching_list)
#tau_3_T_2_5.gre_tangle = Trivial_tangle_surjection(bridge_number=4,
#                                                   free_group=tau_3_T_2_5.F,
#                                                   braid_word=tau_3_T_2_5_gre_tangle_braid_crossings_list,
#                                                   strand_matching=tau_3_T_2_5_gre_tangle_matching_list)

