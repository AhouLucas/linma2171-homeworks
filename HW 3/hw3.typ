#import "frontpage.typ": conf

#show: conf.with(
  lang: "en",
  cours: "LINMA2171 - Numerical Analysis: Approximation, Interpolation, Integration",
  subject: none,
  title: "Homework 3",
  students: (
    (name: "Lucas Ahou", noma: 35942200),
  ),
  teachers: (
    (name: "P-A. Absil"),
  ),
  heading_numbering: none
)

#set page(
  paper: "a4",
  margin: (x: 10%, y: 10%),
  numbering: "1 of 1"
)
#set text(
  size: 12pt
)

#show link: set text(blue, style: "italic")
#set figure.caption(separator: " -- " )


= Smooth submanifold

== Question 1

We know by definition that $J_(g)(x) in RR^(m times n)$ has a rank of $m$ $forall x in cal(M)$. By the rank theorem, we have:

$ 
underbrace("rank"(J_(g)(x)), m) + dim(underbrace("Ker"(J_(g)(x)), T_x cal(M))) &= n\
<==> dim("Ker"(J_(g)(x))) &= n - m = d
$

== Question 2

In this case, we have:

$ g: RR^n -> RR: x mapsto x^top B x - 1 $

So $m = 1$. Furthermore, we have that $g$ is smooth because it is a quadratic function in $x$ (with an additional constant). Finally, the jacobian of $g$ is given by:

$ J_(g)(x) = 2x^top B $

which always has a rank of $m = 1$ for any $x in RR^n$ because it is a single row. Thus $cal(M)$ is a smooth submanifold.

Let's now find an expression for the tangent space $T_x cal(M)$. If $x = 0$, the jacobian is null and we thus have:

$ T_0 cal(M) = RR^n $

Otherwise:

$ T_(x != 0) cal(M) = {v in RR^n : x^top B v = 0} $

= Retraction with homotopy continuation

== Question 1

Let's first rewrite the projection-like retraction as an optimization problem :

$ 
min_(x in cal(M)) &f(x) = 1/2 ||p + v - x||^2\
"s.t." quad &g(x) = 0
$

with $g: RR^m -> RR^m$ smooth, $J_(g)(x)$ has rank $m$ $forall x in cal(M)$ and $cal(M) = {x in RR^n: g(x) = 0}$. To solve a constrained optimization problem, we will use Lagrange multipliers. We define the Lagrangian as:

$ cal(L)(x, lambda) = 1/2 ||p + v - x||^2 - lambda^top g(x) $

where $lambda in RR^m$. To find the optimum, we need to impose the first order optimality condition: 

$ 
gradient_x cal(L)(x^*, lambda^*) &= 0\
<==> -(p + v - x^*) - J_(g)(x^*)^top lambda^* &= 0\
<==>  #rect(inset:1em)[$J_(g)(x^*)^top lambda^* + p + v -x^* = 0$]
$

Of course, the optimum also satisfies $g(x^*) = 0$ thus proving the statement.

== Question 2

We are given the system $H(x(t), lambda(t), t) = 0$ and are asked to give a dynamical system based on that. Let's differentiate the function with respect to $t$:

$ (dif)/(dif t) H(x(t), lambda(t), t) = 0 $

Let's denote $H = mat(H_1; H_2)$ where:

$
  cases(
    H_1(x, lambda, t) = J_(g)(x)^top lambda - (1-t)J_(g)(p)^top lambda_0 + p + t v - x,
    H_2(x, lambda, t) = g(x)
  )
$

and where I omitted the time parameter in $x$ and $lambda$ for a more pleasant reading experience from the grader point of view.\
Let's now compute all the necessary derivatives, starting with $H_1$:


- $(partial H_1)/(partial x)$:\

  We know that:

  $ J_(g)(x)^top lambda = mat((partial g_1)/(partial x_1), dots, (partial g_m)/(partial x_1); 
                              dots.v, dots.down, dots.v;
                              (partial g_1)/(partial x_n), dots, (partial g_m)/(partial x_n))
                          
                          mat(lambda_1; dots.v; lambda_m) =
                          
                          mat(sum_(k=1)^(m) lambda_k (partial g_k)/(partial x_1); dots.v; sum_(k=1)^(m) lambda_k (partial g_k)/(partial x_n)) $

  Thus:

  $ (partial)/(partial x)(J_(g)(x)^top lambda) = T(x, lambda) in RR^(n times n) $

  where $[T(x, lambda)]_(i,j) = sum_(k=1)^(m) lambda_k (partial^2 g_k)/(partial x_i partial x_j)$. Finally: 

  $ (partial H_1)/(partial x) = (partial)/(partial x)(J_(g)(x)^top lambda) - (partial x)/(partial x) = T(x, lambda) - I_n $

- $(partial H_1)/(partial lambda) = J_(g)(x)^top$

- $(partial H_1)/(partial t) = J_(g)(p)^top lambda_0 + v$

Knowing that $(dif H_1)/(dif t) = (partial H_1)/(partial x) dot(x) + (partial H_1)/(partial lambda) dot(lambda) + (partial H_1)/(partial t) = 0 $, we obtain:

$
  (T(x, lambda) - I_n) dot(x) + J_(g)(x)^top dot(lambda) + J_(g)(p)^top lambda_0 + v = 0 quad ("Eq." 1)
$

Differentiating $H_2$ is straightforward and gives us:

$ (dif H_2)/(dif t) = J_(g)(x) dot(x) = 0 quad ("Eq." 2) $

We can now put everything in matrix form to get:


$
  mat(
    T(x, lambda) - I_n, J_(g)(x)^top; J_(g)(x), 0
  ) 
  mat(dot(x); dot(lambda))

  = 

  mat(-J_(g)(p)^top lambda_0 - v; 0)
$

To find a solution $(x^*, lambda^*)$ to the original problem, we notice that $(x(t), lambda(t))$ is a solution of the original problem in this dynamical system when $t=1$. We can thus solve the dynamical system for $t in [0, 1]$ and look at the solution at $t=1$.\
To do that, we need an initial condition. We notice that taking $x(0) = p$ and $lambda(0) = lambda_0$ satisfies the system for $t=0$. We can thus take those to simulate the system.


= Implementation

== Question 1

Here we have:

$
  g(x) = beta x_1^2 + x_2^2
$

Using the previously derived dynamical model and the parameters given in the statement, we obtain this system to solve:

$
  mat(2lambda(t)beta - 1, 0, 2beta x_1(t);
      0, 2lambda(t) - 1, 2x_2(t);
      2beta x_1(t), 2x_2(t), 0)
  
  mat(dot(x)_1(t);dot(x)_2(t); dot(lambda)(t))

  =

  mat(-1;-2lambda_0; 0)
$

We are also asked to plot $p + T_p cal(M)$. We know that:

$
  J_(g)(x) &= mat(2beta x_1, 2x_2)\
  ==> J_(g)(p) &= mat(0, 2)
$

$T_p cal(M)$, which is the set of vectors which cancels $J_(g)(p)$, is thus:

$
  T_p cal(M) = "span" chevron.l mat(1;0) chevron.r
$

After solving the dynamical system using the given parameters, we obtain the following plot:

#figure(
  image("figures/q1_plot.svg", width:60%),
  caption: [Trajectory $x(t)$, the smooth submanifold $cal(M)$ and the tangent space $T_p cal(M)$]
)<q1_plot>

On @q1_plot, we can see that the real part of $x(t)$ converges towards the closest point of $cal(M)$ to the vector $p + v$. We also notice that the imaginary part of $x(t)$ goes back to 0 at the final timestep. This indicates that the retraction was correctly computed.

== Question 2

We are now interested at the error of the solution. Let's thus analyze the norm of $H$: 

#figure(
  image("figures/q2_H_norms.svg", width:60%),
  caption: [Errors of the approximation as a function of time for different $Delta  t$]
)<q2_euler>

On @q2_euler, even though the error seems to be very small for small $Delta t$,
we actually have to decrease $Delta t$ by a considerable amount to achieve a small error. For $Delta t = 0.1$, we see that the error is too large to be considered a good approximation. For  $Delta t = 1e"-06"$, we get a pretty good approximation. However, the cost of computation becomes quite expensive.

As suggested, let's add Newton correction steps into the previous algorithm. To do that, we will keep the Euler explicit method and at each time step, we take the new iterate and perform the Newton-Raphson method until we reach a tolerance of $epsilon.alt = 1e"-10"$. We then continue this loop with this new corrected iterate. Here is the plot of the errors for this new method:

#figure(
  image("figures/q2_H_norms_newton.svg", width:60%),
  caption: [Error of the approximation for $Delta t = 0.1$]
)<q2_newton>

On @q2_newton, we reached a much smaller error at the final time step even though we used a large $Delta t$ of $0.1$. This allows to converge very quickly to the solution and with greater precision. I chose $Delta t = 0.1$ because choosing a smaller $Delta t$ gave an error of the same order of magnitude and is thus not necessary.

== Question 3

Let's now plot the trajectories of $lambda(t)$ depending on the initial condition $lambda_0$ for different $beta$:


#figure(
  grid(
    columns: (auto, auto, auto),
    image("figures/q3_lambda_trajectories_beta_0.5.svg"),
    image("figures/q3_lambda_trajectories_beta_1.0.svg"),
    image("figures/q3_lambda_trajectories_beta_5.0.svg"),
  ),
  caption: [Trajectories of $lambda(t)$ in the complex plane depending of the initial condition $lambda_0$ for different values of $beta$]
)

Here, we see that no matter the position of the initial condition or if it is real, they all converge to the same solution which is a valid valued for the retraction.


#bibliography("bib.yml", full: true)