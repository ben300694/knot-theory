"""
Using SnapPy via the SageMath integration
Install docker image from
https://github.com/3-manifolds/sagedocker
or alternatively
https://hub.docker.com/r/computop/sage/

Run docker with X11 host:
(https://stackoverflow.com/questions/49169055/docker-tkinter-tclerror-couldnt-connect-to-display)
# sudo docker run -it -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY computop/sage
# xhost +
# sage

Your new Plink window needs an event loop to become visible.
Type "%gui tk" below (without the quotes) to start one.
"""

M = snappy.Manifold()
M.identify()
# [t12047(0,0)(0,0)(0,0)(0,0),
# 8^4_2(0,0)(0,0)(0,0)(0,0),
# L8n7(0,0)(0,0)(0,0)(0,0),
# ooct02_00001(0,0)(0,0)(0,0)(0,0)]
# L = snappy.Link('L8n7')

# Original link:
# PD: [(5,7,6,14),(11,5,12,4),(12,20,13,19),(20,14,15,13),(33,1,34,6),(32,8,33,7),(8,32,9,31),(30,10,31,9),(10,30,11,29),(28,1,29,2),(26,15,27,16),(18,25,19,26),(3,24,4,25),(23,2,24,3),(22,17,23,18),(16,21,17,22),(27,34,28,21)]

# Ordering of components:
# 0: (-5, 4)
# 1: (-3, 2)
# 2: (-3, 2)

M.dehn_fill([(-5, 4), (-3, 2), (-3, 2)])

# Recovering link from PD code
L=snappy.Link([(5,7,6,14),(11,5,12,4),(12,20,13,19),(20,14,15,13),(33,1,34,6),(32,8,33,7),(8,32,9,31),(30,10,31,9),(10,30,11,29),(28,1,29,2),(26,15,27,16),(18,25,19,26),(3,24,4,25),(23,2,24,3),(22,17,23,18),(16,21,17,22),(27,34,28,21)])
L.braid_word()
# [-1, 2, -3, 4, 3, 5, 2, 6, 1, 3, 4, 4, 3, -5, 2, -4, -4, -3, -5, -5, -4, -5, -6, -5, -4, 3, 2]


# # # # # # # # # # # # # # # # # # # # # #
# # # # # # # # # # # # # # # # # # # # # #

M = snappy.Manifold('DT: [(-8,-20,28),(16,-6,22,-18),(24,-26),(12,-4,-30,14,2,-10)]')

# Simplified grid link
# into PLink Editor
# DT: [(-8,-20,28),(16,-6,22,-18),(24,-26),(12,-4,-30,14,2,-10)], [1,1,0,0,0,1,1,0,1,0,0,0,0,1,1]
# Gauss: [(1,2,3,-4,-5,-6),(7,-1,6,10,-11,-12,-13,14),(4,-3,-14,-18,-19,11,21,5,-2,-7,18,13),(-10,19,12,-21)]


M.dehn_fill([(-3, 2), (-3, 2), (-5, 4)])
