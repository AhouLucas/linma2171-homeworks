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

Otherwise, because $B$ is positive definite, the only vector that can cancel it is the null vector:

$ T_(x != 0) cal(M) = {0} $

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

