
#####
# When t=3 this is the family of tri-plane diagrams in https://arxiv.org/pdf/1812.10842.pdf p. 9
####


####
# k>0 odd
####

def singular_red_tangle_braid_crossings_list(k : int, t: int):
    return [Braid_crossing(2,2*k+3,+1)]+t*[Braid_crossing(1,2,+1)]

def singular_blu_tangle_braid_crossings_list(k : int, t: int):
    return (k-1)*[Braid_crossing(2*k+2,2*k+3,-1)]+t*[Braid_crossing(1,2*k+2,+1)]

def singular_gre_tangle_braid_crossings_list(k : int, t: int):
    return [Braid_crossing(2*i+1,2*i+2,+1) for i in range(1,k+1)]+[Braid_crossing(2,3,+1)]+t*[Braid_crossing(1,2,+1)]

# Matchings (doesn't depend on t)


def singular_red_tangle_matching_list(k : int, t: int):
    return [(0, 1)]+[(2,2*k+3)]+[(2*i+1,2*i+2) for i in range(1,k+1)]

def singular_blu_tangle_matching_list(k : int, t: int):
    return [(0,1)]+[(2*k+2,2*k+3)]+[(2*i, 2*i+1) for i in range(1,k+1)]

def singular_gre_tangle_matching_list(k : int, t: int):
    return [(2*i,2*i+1) for i in range(0,k+2)]
