"""
This short script helps with computing classical invariants of Legendrian knots
in contact surgery diagrams of 3-manifolds

References for the formulas:

Hoste, Jim. A Formula for Casson's Invariant.
Transactions of the American Mathematical Society
Vol. 297, No. 2 (Oct., 1986), pp. 547-562
https://doi.org/10.2307/2000539

Kegel, Marc. Legendrian knots in surgery diagrams and the knot complement problem.
PhD thesis, Universität zu Köln (2016)
http://kups.ub.uni-koeln.de/id/eprint/7396
"""


# topological surgery coefficients
P_top = vector([-5, -3, -3]) # numerators p_i
Q_top = vector([ 4,  2,  2]) # denominators q_i

# vector of linking numbers of L_0 with the surgery curves
l = vector([+1, -2, +2])


# linking-framing matrix for Hoste's formula
# https://www.ams.org/journals/tran/1986-297-02/S0002-9947-1986-0854084-4/S0002-9947-1986-0854084-4.pdf
B = matrix([[-5/4, 1, 0], [1, -3/2, 1], [0, 1, -3/2]])

lk_d_L = matrix([+1, -2, +2])
lk_dbb_L = matrix([+1, -2, +2])

def hoste_formula(lk_S3: int, lk_J1_L, B, lk_J2_L):
    return lk_S3 - lk_J1_L * B^(-1) * lk_J2_L
    
def Q_matrix(B, Q_top):
    """
    Input:
    B: linking-framing matrix
    Q_top: list of denominators of topological surgery coefficients
    
    Multiply each column of B with the corresponding denominator
    of the topological surgery coefficient
    """
    return matrix([Q_top[i]*v for (i, v) in enumerate(B.columns())]).transpose()

Q = Q_matrix(B, Q_top)
# to see whether L_0 is null-homologous in the surgery,
# look for integral solution vectors a for the equation
# l = Q*a 

var('a_1, a_2, a_3')
eqn = [row == l[i] for (i, row) in enumerate(Q*vector([a_1, a_2, a_3]))]
s = solve(eqn, a_1, a_2, a_3)

# alternative if Q is invertible
if Q.det() != 0:
    a = Q^(-1)*l

def tb_new(tb_old: int, a, q, l):
    """
    l is the vector of linking numbers with the surgery curves
    a is the itegral solution vector to l = Q*a
    q is the vector of topological surgery denominators
    """    
    return tb_old - sum([a[i]*q[i]*l[i] for i in range(len(a))])
    
# rot is a vector of rotation numbers of the surgery components L_i
# wrt the standard tight contact structure of the 3-sphere
rot = vector([0, 0, 0])

def rot_new(rot_old: int, a, q, rot):
    return rot_old - sum([a[i]*q[i]*rot[i] for i in range(len(a))])
    
# Using SnapPy via the SageMath integration
# Install docker image from
# https://github.com/3-manifolds/sagedocker
# https://hub.docker.com/r/computop/sage/
#
# Run docker with X11 host
# https://stackoverflow.com/questions/49169055/docker-tkinter-tclerror-couldnt-connect-to-display
# sudo docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY computop/sage
# xhost +

# Your new Plink window needs an event loop to become visible.
# Type "%gui tk" below (without the quotes) to start one.
# M=snappy.Manifold()
