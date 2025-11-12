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