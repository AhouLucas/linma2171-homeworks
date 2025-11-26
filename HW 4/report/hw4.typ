#import "frontpage.typ": conf
#import "components.typ": *

#show: conf.with(
  lang: "en",
  cours: "LINMA2171 - Numerical Analysis: Approximation, Interpolation, Integration",
  subject: "Homework 4",
  title: "Minimax Approximation",
  students: (
    (name: "Lucas Ahou", noma: 35942200),
  ),
  teachers: (
    (name: "P-A. Absil"),
  ),
  heading_numbering: none
)

#let ans-color = rgb(94, 181, 229, 50)



= Discrete minimax approximation

1. When $n > m$, prove that the discrete minimax problem admits infinitely many solutions.

#answer(title: "Answer to Question 2.1", fill-header: ans-color)[
  If $n > m$, then $n+1 > m+1$. We have more degree of freedom ($n+1$) than data points. It is thus possible to interpolate $f$ at ${x_i}_(i=0)^(m)$ by a polynomial $p$ of degree $n$ such that the objective function is $0$. Furthermore, considering the polynomial:

  $ q(x) = product_(i=0)^(m) (x - x_i) in cal(P)_n $

  and any real number $gamma in RR$, the polynomial $overline(p)(x) = p(x) + gamma q(x)$ also interpolates $f$ at ${x_i}_(i=0)^(m)$, so the error is still $0$.

  We conclude that there is an infinite number of polynomials of degree at most $n$ that satisfies the discrete minimax problem in this case. $square$
]

#v(1em)

2. When $n = m$, prove that there exists exactly one solution.

#answer(title: "Answer to Question 2.1", fill-header: ans-color)[
  The reasoning is similar to the previous case. However, when $n = m$, the polynomial which interpolates $f$ at ${x_i}_(i=0)^(m)$ is unique. To show that this polynomial is indeed the unique solution, let's consider any polynomial $q in cal(P)_n$ with $q != p$. Then, $exists x_i$ such that $q(x_i) != p(x_i)$. This implies that, at this $x_i$, $|f(x_i) - q(x_i)| > 0$ and thus :

  $ max_(i = 0, dots, m) |f(x_i) - q(x_i)| > 0 $

  which is worse than the solution $p$.

  $==>$ There exists a unique solution $p$ to the problem in this case. $square$
]

#v(1em)

3. (_Bonus_) When $n < m$, prove that the problem admits at least one solution.

#let ff = $upright(bold(f))$

#answer(title: "Answer", fill-header: ans-color)[
  The discrete minimax problem is equivalent to minimizing:

  $ F(a_0, dots, a_n) = max_(i = 0, dots, m) |f(x_i) - p(x_i)| $

  where $p(x) = sum_(j=0)^(n) a_j x^j$. Using a vectorial notation:

  $ F(bold(a)) = ||ff - bold(P(a))||_(infinity) $

  where $bold(P(a)) := (p(x_0), dots, p(x_m))^top $. We want to prove that $F(a)$ is continuous and coercive with respect to the coefficients of the polynomial $bold(a) = (a_0, dots, a_n)^top$. This way, using also the fact that the whole set $RR^(n+1)$ is closed, we can conclude that there exists an optimum, which is also global.
  
  - $F$ continuous:\
    $-->$ $bold(P): RR^(n+1) -> RR^(m+1)$ is a linear function with respect to $bold(a)$. We thus have an affine function inside the $infinity$-norm (which is a continous function) because $ff$ is constant. $F$, which is a composition of two continous functions, is therefore continuous.

]


#answer(title: "Answer (cont.)", fill-header: ans-color)[
  - $F$ coercive:\
    $-->$ We have to prove that $F -> infinity$ as $||a||_2 -> infinity$. Using the triangle inequality, we obtain:

    $ F(a) &= |||ff - bold(P(a))||_(infinity)\ &>= ||ff||_infinity - ||bold(P(a))||_(infinity) $

    It is therefore sufficient to prove that $||bold(P(a))||_(infinity) -> infinity$ as $||bold(a)||_2 -> infinity$.\
    If $||bold(a)||_2 -> infinity$, then at least one coefficient tends (in absolute value) to $infinity$. Let this coefficient be $a_s$. Since there is also at least a data point $x_i != 0$, the term associated with $a_s$ will also tend (in absolute value) to $infinity$. We therefore have that $||bold(P(a))||_(infinity) -> infinity$ as $||bold(a)||_2 -> infinity$, which proves that $F$ is coercive.

  #v(1em)

  We have proven that $F$ is a continous and coercive function. Furthermore, we now that $RR^(n+1)$, the feasible set, is closed (because it is the whole space). We conclude that there exists an optimum which is also global. $square$
]
