#import "frontpage.typ": conf

#show: conf.with(
  lang: "en",
  cours: "LINMA2171 - Numerical Analysis: Approximation, Interpolation, Integration",
  subject: "Homework 1",
  title: "Hermite Interpolation",
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
  font: "New Computer Modern",
  size: 12pt
)

#show link: set text(blue, style: "italic")
#set figure.caption(separator: " -- " )

#show ref: it => {
  let eq = math.equation
  let el = it.element
  if el != none and el.func() == eq {
    // Override equation references.
    numbering(
      el.numbering,
      ..counter(eq).at(el.location())
    )
  } else {
    // Other references as usual.
    it
  }
}

= Question 1
We need to show that $q_(2n + 1)(x_i) = f(x_i)$ and $q_(2n + 1)^prime (x_i) = f^(prime) (x_i)$ for $i = 0, dots, n$ :

== $underline(q_(2n + 1)(x_i) = f(x_i))$:
#v(.5em)
Knowing that the Lagrange polynomials equals to 1 on the node it is defined on and cancels on every other node, we can compute the following :

$ &H_(i)(x_i) = L_(i)^(2)(x_i) = 1\
  &H_(j)(x_(i != j)) = 0\
  &K_(i)(x_i) = K_(j)(x_(i != j)) = 0 $

With that in mind, we find that $q_(2n + 1)$ evaluated at $x_i$ reduces to :

$ q_(2n + 1)(x_i) &= sum_(j = 0)^(n) f(x_j) H_(j)(x_i) + sum_(j = 0)^(n) f prime(x_j) K_(j)(x_i) \ &= f(x_i) $

== $underline(q_(2n + 1)^(prime)(x_i) = f^(prime) (x_i))$:
#v(.5em)
Let's first compute the derivative of $H_i$ and $K_i$ :

$ &H_(i)^(prime) (x) = -2 L_(i)^(prime) (x_i) L_(i)^(2)(x) + 2L_i (x)L_i^(prime) (x)  (1 - 2L_i^(prime) (x_i) (x - x_i))\
  &K_i^(prime) (x) = L_i ^2 (x) + 2(x-x_i) L_i (x)L_i^(prime) (x) $

When evaluated at the nodes $x_i$, we have :

$ 
cases(
  H_i^(prime) (x_i) = H_j (x_(i != j)) = 0,
  K_i^(prime) (x_i) = 1,
  K_j^(prime) (x_(i != j)) = 0
)
$

Knowing that, we find that $q_(2n + 1)^(prime)$ evaluated at $x_i$ reduces to :

$ q_(2n + 1)^(prime)(x_i) &= sum_(j = 0)^(n) f(x_j) H_(j) prime (x_i) + sum_(j = 0)^(n) f^(prime)(x_j) K_(j)^(prime) (x_i) \ &= f^(prime) (x_i) quad square $

#pagebreak()

= Question 2

To interpolate $(x_i, f(x_i), f^(prime) (x_i), f^(prime prime) (x_i))_(i = 0)^(n)$, we need to impose :

#math.equation(
  block: true,
  numbering: "(1)",
  $cases(
    &alpha_(i)(x_j) = delta_(i j)\, quad &alpha_(i)^(prime)(x_j) = 0 \, quad &alpha_(i)^(prime prime)(x_j) = 0,
    &beta_(i)(x_j) = 0\, quad &beta_(i)^(prime)(x_j) = delta_(i j) \, quad &beta_(i)^(prime prime)(x_j) = 0,
    &gamma_(i)(x_j) = 0\, quad &gamma_(i)^(prime)(x_j) = 0 \, quad &gamma_(i)^(prime prime)(x_j) = delta_(i j)
  )$
)<constraints>


$forall j in {0, 1, dots, n}$.\
To achieve this, we can build them from the following polynomial :

$ q(x) = L_(i)^(3)(x) (a + b x + c x^2) $

where $a, b, c in RR$ are coefficients.\
We have that $q in cal(P)_(3n+2)$, while still having enough degree of freedom to satisfy @constraints. Let's now compute the coefficients for the functions $alpha_(i), beta_(i)$ and $gamma_(i)$ :

== $underline(alpha_(i)(x))$:

First, let's compute the derivative of $q(x)$ :

$ &q(x) = L_(i)^3(x) (a + b x + c x^2)\
  => &q^(prime)(x) = 3L_(i)^2(x) L_(i)^(prime)(x) (a + b x + c x^2) + L_(i)^3(x) (b + 2c x)\
  => &q^(prime prime)(x) = 3 (2L_(i)(x) (L_(i)^(prime)(x))^2 + L_(i)^(2)(x) L_(i)^(prime prime)(x)) (a + b x + c x^2)
                         + 6L_(i)^2(x) L_(i)^(prime)(x) (b + 2c x) + 2c L_(i)^(3)(x) 
$

Now, let's find the coefficients to satisfy the constraints: \

1. To satisfy $alpha_(i)(x_j) = delta_(i j)$, we can simply impose $bold(a + b x_i + c x_(i)^2 = 1)$ because $L_(i)(x_j) = delta_(i j) forall j in {0, dots, n}$.

2. To satisfy $alpha_(i)^(prime)(x_j) = 0$, we can simply impose that $alpha_(i)^(prime)(x_i) = 0$.\ 
  We thus obtain
  $bold(b + 2c x_i = -3 L_(i)^(prime)(x_i))$.

3. Finally, to satisfy $alpha_(i)^(prime prime)(x_j) = 0$, we simply impose $alpha_(i)^(prime prime)(x_i) = 0$.\ 
  We thus obtain $bold(3L_(i)^(prime prime)(x_i) - 12 (L_(i)(x_i))^2 + 2c = 0)$

The system to solve is thus :

#math.equation(
  block: true,
  numbering: "(1)",
  $
    cases(
      a + b x_i + c x_(i)^2 = 1,
      b + 2c x_i = -3 L_(i)^(prime)(x_i),
      3L_(i)^(prime prime)(x_i) - 12 (L_(i)(x_i))^2 + 2c = 0
    )
  $
)

After solving, we obtain :

$ 
cases(
 a = 1 + 3x_(i) L_(i)^(prime)(x_(i)) + 6x_(i)^(2) (L_(i)^(prime)(x_(i)))^2 - 3/2 x_(i)^(2) L_(i)^(prime prime)(x_i),
 b = -3L_(i)^(prime)(x_(i)) - 12x_i (L_(i)^(prime)(x_(i)))^2 + 3x_i L_(i)^(prime prime)(x_i),
 c = 6 (L_(i)^(prime)(x_(i)))^2 - 3/2 L_(i)^(prime prime)(x_i)
)
$

== $underline(beta_i (x))$:
Let's proceed in the same way for $beta_i$:

1. To satisfy $beta_i (x_j) = 0$, we can simply impose $beta_i (x_i) = 0$.\ We thus obtain $bold(a + b x_i + c x_i ^2 = 0)$

2. To satisfy $beta_(i)^(prime) (x_j) = delta_(i j)$, we can simply impose $beta_i (x_i) = 1$.\ 
  We thus obtain $bold(b + 2c x_i = 1)$

3. Finally, to satisfy $beta_(i)^(prime prime) (x_j) = 0$, we simply impose $beta_(i)^(prime prime)(x_i) = 0$.\
  We thus obtain $bold(6L_(i)^(prime)(x_i) + 2c = 0)$


After solving that, we obtain :

$ 
cases(
 a = -3x_(i)^2 L_(i)^(prime)(x_i) - x_i,
 b = 1 + 6x_i L_(i)^(prime)(x_i),
 c = -3L_(i)^(prime)(x_i)
)
$

== $underline(gamma_i (x))$:
Finally, let's compute $gamma_i$:

1. To satisfy $gamma_i (x_j) = 0$, we can simply impose $gamma_i (x_i) = 0$.\ We thus obtain $bold(a + b x_i + c x_i ^2 = 0)$

2. To satisfy $gamma_(i)^(prime) (x_j) = 0$, we can simply impose $gamma_i (x_i) = 0$.\ 
  We thus obtain $bold(b + 2c x_i = 0)$

3. Finally, to satisfy $gamma_(i)^(prime prime) (x_j) = delta_(i j)$, we simply impose $gamma_(i)^(prime prime)(x_i) = 1$.\
  We thus obtain $bold(2c = 1)$


After solving that, we obtain :

$ 
cases(
 a = 1/2 x_i ^2,
 b = -x_i,
 c = 1/2
)
$

#pagebreak()

= Question 3
Let's now implement the Hermite interpolation $p_(3n+2)$ defined before on $f(x) = e^(-x^2\/2)$ on the interval $[-5, 5]$ in Python. Here are the plots of the interpolation with 1, 4, 9 and 15 nodes respectively #footnote("The nodes are uniformly spaced with both ends of the interval included"):

#figure(
  grid(
    columns: (auto, auto),
    rows: (auto, auto),
    gutter: 3pt,
    grid.cell(image("figures/interpolation_N1.png")),
    grid.cell(image("figures/interpolation_N4.png")),
    grid.cell(image("figures/interpolation_N9.png")),
    grid.cell(image("figures/interpolation_N15.png")),
  ),
  caption: [Hermite interpolation of $f(x) = e^(-x^2\/2)$ on $[-5, 5]$ with 1, 4, 9 and 15 nodes]
)

As expected, a too small number of nodes (like 1 and 3) will result in a bad interpolation of the original function. However, too many nodes makes the interpolation polynomial explode on the end nodes. This is due to the fact that the polynomial is of order $3n + 2$, which can become quite large even for moderate values of $n$. This results in very high-degree polynomials as $n$ increases, which in return causes high oscillations.\

Below, you will find a plot of the total errors of the interpolation, computed as an approximation of $integral_(-5)^(5) |f(x) - p_(3n + 2)(x)| dif x$, with respect to $n$:

#figure(
  image("figures/total_errors.png"),
  caption: [Total interpolation error with respect to the number of nodes]
)

As we can see, the error decreases as $n$ increases, but starts to increase again after a certain point. This is due to the Runge's phenomenon #footnote(link("https://en.wikipedia.org/wiki/Runge%27s_phenomenon")), which states that increasing the number of interpolation nodes can lead to worse approximations for high-degree polynomials. In this case, the error starts to increase again after $n = 9$. This is because the polynomial starts to oscillate wildly between the nodes, leading to large errors in the approximation. Thus, we can deduce that there is an optimal number of nodes that minimizes the interpolation error, and adding more nodes beyond that point can actually worsen the approximation.