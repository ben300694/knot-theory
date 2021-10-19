# knot-theory
SageMath and GAP code related to low-dimensional topology

In particular, we study the
[Casson-Whitney unknotting number](https://arxiv.org/abs/2007.13244)
via lower bounds from the fundamental group of the complement.

This is applied to
[Suciu's infinite family of ribbon 2-knots](https://doi.org/10.1017/S0305004100063684)
with the trefoil knot group.


## Using SageMath from docker image


[Docker repository for SageMath](https://hub.docker.com/r/sagemath/sagemath/)

Start SageMath command line:
`sudo docker run -it sagemath/sagemath:latest`

Start SageMath in Jupyter Notebook:
`sudo docker run -p8888:8888 sagemath/sagemath:latest sage-jupyter`

## Using Sage's GAP interface

GAP finitely presented groups through SageMath:
(https://doc.sagemath.org/html/en/reference/groups/sage/groups/finitely_presented.html)

Projective Special Linear Group:
(https://groupprops.subwiki.org/wiki/Projective_special_linear_group:PSL(2,Z))
