# Using SageMath interface for GAP
# To start GAP inside of SageMath:
# gap.console()
#
# Defining groups in GAP:
# PSL := FreeProduct(CyclicGroup(2),CyclicGroup(3))
#
# Using SageMath to access GAP's
# finitely presented groups functionality
# https://doc.sagemath.org/html/en/reference/groups/sage/groups/finitely_presented.html

# from sage.interfaces.gap import get_gap_memory_pool_size, set_gap_memory_pool_size
# set_gap_memory_pool_size(20000000000)

k := 4;

F := FreeGroup("t_k", "c", "d");

G := F / [F.3^(-1)*F.1*(F.3*F.2^(-1))^(-k+1)*F.1*(F.3*F.2^(-1))^(k-1)*(F.1^(-1)),
          F.2^(-1)*F.1*F.2*F.3^(-1)*(F.1)^(-1)*F.3*F.1*F.3*F.2^(-1)*(F.1)^(-1)];

RelatorsOfFpGroup(G);

AllHomomorphismClasses(G, SymmetricGroup(3));
# AllHomomorphisms(G, SymmetricGroup(3));

