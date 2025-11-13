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
I will now compute all the necessary derivatives, starting with $H_1$:


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

