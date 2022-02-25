# Using SageMath interface for GAP
# To start GAP inside of SageMath:
# gap.console()
#
# Using SageMath to access GAP's
# finitely presented groups functionality
# https://doc.sagemath.org/html/en/reference/groups/sage/groups/finitely_presented.html

# from sage.interfaces.gap import get_gap_memory_pool_size, set_gap_memory_pool_size
# set_gap_memory_pool_size(20000000000)

F := FreeGroup("a", "b");
BS := F / [F.2*F.1*F.2^(-1)*F.1^(-2)];
RelatorsOfFpGroup(BS);
# [ b*a*b^-1*a^-2 ]

subgr := Subgroup(BS, [BS.1^(-1)*BS.2*BS.1, BS.2*BS.1^(-1)]);
# Group([ a^-1*b*a, b*a^-1 ])

IndexInWholeGroup(subgr);
# 3
Index(BS, subgr);
# 3
IsNormal(BS, subgr);
# false
ConjugateSubgroups(BS, subgr);
# [ Group([ a^-1*b*a, b*a^-1 ]), Group([ a^-2*b*a^2, a^-1*b ]), Group([ b, a*b*a^-2 ]) ]

iso := IsomorphismFpGroup(subgr);
# [ <[ [ 2, 1 ] ]|b^-1*a^-1>, <[ [ 2, -1, 1, -1 ] ]|a*b*a*b^-1> ] -> [ F1, F2 ]
Image(iso);
# <fp group of size infinity on the generators [ F1, F2 ]>
RelatorsOfFpGroup(Image(iso));
# [ F2*F1*F2^-2*F1^-1 ]
