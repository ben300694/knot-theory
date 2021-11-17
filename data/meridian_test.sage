load('./src/bridge_trisections.sage')

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Experiment with trivial tangle where b many generators on
# around punctures are not enough to generate group
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

meridian_test_BT = Bridge_Trisection(2)
meridian_test = Trivial_tangle_surjection(bridge_number = 2,
                                          free_group = meridian_test_BT.F)

meridian_test.generators_temp_list=[meridian_test.F([2]),
                                    meridian_test.F([-2]),
                                    meridian_test.F([1]),
                                    meridian_test.F([-1])]
print("generators_temp_list:", meridian_test.generators_temp_list)

meridian_test.add_crossing(Braid_crossing(1, 2, +1))
meridian_test.add_crossing(Braid_crossing(1, 2, +1))
meridian_test.add_crossing(Braid_crossing(1, 2, +1))
meridian_test.add_crossing(Braid_crossing(0, 1, +1))
meridian_test.add_crossing(Braid_crossing(0, 1, +1))
meridian_test.add_crossing(Braid_crossing(2, 3, +1))
meridian_test.add_crossing(Braid_crossing(2, 3, +1))

print("------------")
print("generators_temp_list:", meridian_test.generators_temp_list)
