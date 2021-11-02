# knot-theory
SageMath and GAP code related to low-dimensional topology

In particular, we study the
[Casson-Whitney unknotting number](https://arxiv.org/abs/2007.13244)
via lower bounds from the fundamental group of the complement.

This is applied to
[Suciu's infinite family of ribbon 2-knots](https://doi.org/10.1017/S0305004100063684)
with the trefoil knot group.

# Requirements

 * SageMath version >= 9.0

# Instructions

From the main git directory start `sage`

 * `attach('src/suciu_ribbon_knots.sage')` to load the file with Suciu's examples
 * `attach('src/bridge_trisection.sage')` to load the file with the functions for triplane diagrams, this will look for the data files in `/data`

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


## Logging Sage output and keeping processes running over ssh



(https://askubuntu.com/questions/8653/how-to-keep-processes-running-after-ending-ssh-session)
Start `tmux`

Start process in the tmux session:

(https://doc.sagemath.org/html/en/tutorial/interactive_shell.html)
In SageMath, activate logging with
`logstart -o -t Trefoil4commutator`

Options: `-o` to also log output, `-t` for timestamps,
can give any other name instead of 'Trefoil4commutator'

Leave/detach the tmux session by typing
<kbd>Ctrl</kbd> + <kbd>B</kbd> and then <kbd>D</kbd>

(In tmux, <kbd>Ctrl</kbd> + <kbd>B</kbd> is the control key,
while <kbd>D</kbd> is the command key for detaching a session)

You can now safely log off from the remote machine, your process will keep running inside tmux. When you come back again and want to check the status of your process you can use `tmux attach` to attach to your tmux session.

If you want to have multiple sessions running side-by-side,
you should name each session using 
<kbd>Ctrl</kbd> + <kbd>B</kbd> and <kbd>$</kbd>.
Alternative from the terminal `tmux rename-session -t 5 brown_band_commutator`
where `5` is the old name and `brown_band_commutator` new.

You can get a list of the currently running sessions using `tmux list-sessions` or `tmux ls`,
now attach to a running session with command `tmux attach-session -t <session-name>`
