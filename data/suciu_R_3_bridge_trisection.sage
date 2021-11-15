# # # # # # # # # # # # #
# R_3 in Suciu's family
# # # # # # # # # # # # #

R_3_red_tangle_braid_crossings_list = [
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
                                          Braid_crossing(11, 12, -1), # go under c 
                                          Braid_crossing(5, 6, +1), # --- now orange band from middle ~~~ repeat this part k times
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
                                          Braid_crossing(7, 10, -1), # c^(-1) ~~~ k = 2
                                          Braid_crossing(5, 6, +1), # ~~~ next pattern
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
                                          Braid_crossing(7, 10, -1), # c^(-1) ~~~ k = 3
                                          Braid_crossing(5, 6, +1),
                                          Braid_crossing(6, 7, +1),
                                          Braid_crossing(6, 7, +1),
                                          Braid_crossing(5, 6, +1), # t_k
                                      ]

# There are no crossings in the bridge position
# of Suciu's knots R_k that we are using,
# in particular this is independent of k
R_k_blu_tangle_braid_crossings_list = []
R_k_gre_tangle_braid_crossings_list = []

# For Suciu's examples, the matching of the tangle strands at the top
# does not depend on the parameter k
R_k_red_tangle_matching_list = [(0, 7), 
                                (1, 6),
                                (2, 3),
                                (4, 5),
                                (8, 9),
                                (10, 13),
                                (11, 12)]

R_k_blu_tangle_matching_list = [(0, 1), 
                                (2, 5),
                                (3, 4),
                                (6, 7),
                                (8, 11),
                                (9, 10),
                                (12, 13)]

R_k_gre_tangle_matching_list = [(0, 3), 
                                (1, 2),
                                (4, 5),
                                (6, 9),
                                (7, 8),
                                (10, 11),
                                (12, 13)]
                                
# To import this into your SageMath project use

#R_3 = Bridge_Trisection(7)
#R_3.red_tangle = Trivial_tangle_surjection(bridge_number=7,
#                                           free_group=R_3.F,
#                                           braid_word=R_3_red_tangle_braid_crossings_list,
#                                           strand_matching=R_k_red_tangle_matching_list)

## In Suciu's examples, the red and green tangle
## do not have any crossings
#R_3.blu_tangle = Trivial_tangle_surjection(bridge_number=7,
#                                           free_group=R_3.F,
#                                           braid_word=R_k_blu_tangle_braid_crossings_list,
#                                           strand_matching=R_k_blu_tangle_matching_list)
#R_3.gre_tangle = Trivial_tangle_surjection(bridge_number=7, 
#                                           free_group=R_3.F,
#                                           braid_word=R_k_gre_tangle_braid_crossings_list,
#                                           strand_matching=R_k_gre_tangle_matching_list)
