#import "frontpage.typ": conf

#show: conf.with(
  lang: "en",
  cours: "LINMA2171 - Numerical Analysis: Approximation, Interpolation, Integration",
  subject: none,
  title: "Homework 2",
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

= Polynomial interpolation: Newton & Neville 

== 2. Computational complexities

=== #underline("Newton's divided differences")

\
a) The coefficients for the Newton's algorithm are the divided differences :
$ a_j := [y_0, dots, y_j] $

where :

$ [y_k] &:= y_k\
  [y_k, dots, y_(k+j)] &:= ([y_(k+1), dots, y_(k+j)] - [y_k, dots, y_(k+j-1)])/(x_(k+j) - x_k)
$

with $y_k$ the points we want to interpolate.\
For each $[y_k, dots, y_(k+j)]$, we perform 2 substractions and 1 division. The number of elements to compute to get all the coefficients is $n(n-1)/2$. The total number of flops to compute all the coefficients is :

$ 3 dot n(n-1)/2 tilde cal(O)(n^2) $

b) Assuming all the coefficients are already computed, we simply need to compute:

$ p(x) &= sum_(j=0)^(n-1) a_j n_(j)(x)\
  n_(j)(x) &= cases(
    product_(i=0)^(j-1) (x-x_i) quad &&j > 0,
    1 quad &&j = 0)
$

Every $n_(j)(x)$ can be computed based on $n_(j-1)(x)$ by multiplying by $(x-x_j)$. Each term of the sum thus requires 1 addition, 1 substraction and 1 multiplication. The total number of operations is $n-1$ multiplications and $2(n-1)$ additions/substractions. The complexity is thus $cal(O)(n)$.


c) First, let's examine the storage requirements to compute the coefficients. We know that the divided differences table contains $n(n-1)/2$ entries. However, the evaluated points $y_k$ are only necessary to compute the $k$-th coefficient. We can thus use the given array that contains the $y_k$ to compute the coefficients in place. The total storage requirement for the coefficient computation is $cal(O)(n)$ ($n$ for the nodes $x_i$ and $n$ for the evaluated points $y_i$).

Second, to evaluate the interpolation at $m$ distinct points, we simply need a single variable that gets updated for each point. The storage requirement is thus $cal(O)(m)$ for the evaluation part.

The total storage requirement is $cal(O)(n + m)$.

=== #underline("Neville's algorithm")
\
a) Neville's algorithm is designed for direct evaluation and does not precompute coefficients. So, there is no complexity for the coefficient computation.

b) The triangular table contains $n(n+1)/2$ and each entry $P_(i,j)(x)$ requires 2 substractions, 1 multiplication and 1 division. Since the first column of the table is given, the total number of operation is:

$ 4 dot (n(n+1)/2 - n) = 2n(n-1) tilde cal(O)(n^2) $

c) For a single point, we need at each step at most $n$ slots. In fact, after computing $P_(0,1)$, we can use the slot where $y_0$ was stored to place it. The same goes for the other entries. The space requirement for a single point is thus $cal(O)(n)$.

For $m$ evaluation, we simply need $m$ addition slots. The total complexity is $cal(O)(n+m)$.

== 3. Test functions
\
a) After implementing both methods in Python, let's plot the interpolation for $f_(1)(x) = cos(x)$ using Neville's method and for $f_(2)(x) = (1)/(1 + 25x^2)$ using Newton's method for $n = 5, 10$ and $15$ interpolation nodes. Here are the results :

#figure(
  grid(
    columns: (auto, auto),
z
  ),
  caption: [Neville and Newton's methods applied to $f_1$ and $f_2$ respectively for $n = 5, 10 "and" 15$]
)<fig:q3.a_plot>

On @fig:q3.a_plot, we can see that $f_1$ is being interpolated almost perfectly on the interval $[-1, 1]$, even for small values of $n$, using Neville's method. However, $f_2$ is not properly interpolated with the Newton's method. We observe a noticeable gap between the interpolation and the true function. While increasing $n$ allows to obtain a better interpolation in the middle of the interval, we however notice a Runge's phenomenon on the borders when $n$ becomes too large.

\

b) Before computing and plotting the interpolation errors, let's try to switch the methods for these two functions to see if we can visually notice a difference :

#figure(
  grid(
    columns: (auto, auto),
    image("figures/Newton_f_1x.svg"),
    image("figures/Neville_f_2x.svg"),
  ),
  caption: [Newton and Neville's methods applied to $f_1$ and $f_2$ respectively for $n = 5, 10 "and" 15$]
)<fig:q3.b_plot>

On @fig:q3.b_plot, we can not observe any difference after swapping these two methods. We expect the errors to be relatively close between these two. Let's compute the errors using the $cal(l)^2$-norm and plot them with respect to $n$:


#figure(
  grid(
    columns: (auto, auto),
    rows: (auto, auto),
    image("figures/Newton_f_1x_error.svg"),
    image("figures/Neville_f_1x_error.svg"),
    image("figures/Newton_f_2x_error.svg"),
    image("figures/Neville_f_2x_error.svg"),
  ),
  caption: [Newton and Neville's methods applied to $f_1$ and $f_2$ respectively for $n = 5, 10 "and" 15$]
)<fig:q3.b_errors>

On @fig:q3.b_errors, we see that the errors are exactly the same which indicates that both methods interpolate exactly in the same way. This is totally expected because we are trying to fit a polynomial of the same degree $n-1$ on the same nodes. The interpolation theorem tells us that there is a unique polynomial that does this, which is why both methods produce the same polynomial even though the procedure to achieve this is different.


= Rational interpolation: Floater-Hormann

== 1. Proving $r$ is rational

A rational function is defined as a function that can be expressed as the ratio of two polynomials. Let's analyze the numerator and denominator of $r(x)$.

=== Denominator $D(x)$:

We define:

$ D(x) := sum_(i=0)^(n-d) lambda_(i)(x) = sum_(i=0)^(n-d) ((-1)^i)/(product_(j=0)^(d) (x - x_(i+j))) $

This is a sum rational terms with a denominator of degree $d+1$. We can express this sum as a rational function but we first have to put every term to the same denominator. The common denominator is :

$ Q(x) := product_(k=0)^(n) (x - x_k) $

which is a polynomial of degree $n+1$. Thus, each $lambda_i$ can be written as :

$ lambda_(i)(x) = (-1)^(i) (P_(i)(x))/(Q(x)) $

where $P_i$ is the polynomial in the numerator of the $i$-th term after putting it to the common denominator and so has a degree of $n-d$. The denominator $D(x)$ of $r(x)$ then becomes:

$ D(x) = sum_(i=0)^(n-d) (-1)^(i) (P_(i)(x))/(Q(x)) = (sum_(i=0)^(n-d) (-1)^(i) P_(i)(x))/(Q(x)) := (tilde(D)(x))/(Q(x)) $

where $tilde(D)(x)$ is a polynomial of the same degree $n-d$ as $P_i$.

=== Numerator $N(x)$:

We define:

$ N(x) := sum_(i=0)^(n-d) lambda_(i)(x) p_(i)(x) = sum_(i=0)^(n-d) ((-1)^i p_(i)(x))/(product_(j=0)^(d)(x - x_(i+j)))  $

Using the same common denominator $D(x)$ as before, we can rewrite the $i$-th term as:

$ lambda_(i)(x) p_(i)(x) = (-1)^(i) (p_(i)(x) P_(i)(x))/(Q(x)) $

where $P_i$ is the same polynomial of degree $n-d$ as before. Therefore, the numerator becomes:

$ N(x) = sum_(i=0)^(n-d) (-1)^(i) (p_(i)(x) P_(i)(x))/(Q(x)) = (sum_(i=0)^(n-d) (-1)^(i) p_(i)(x) P_(i)(x))/(Q(x)) := (tilde(N)(x))/(Q(x)) $

Where $tilde(N)$ is also a polynomial of the same degree as $p_(i)(x) P_(i)(x)$, i.e. $d + (n-d) = n$.

=== Final form of $r(x)$:

Finally, we combine these two expression to obtain the final form for $r(x)$:

$ r(x) = (N(x))/(D(x)) = ((tilde(N)(x))/(Q(x)))/((tilde(D)(x))/(Q(x))) = (tilde(N)(x))/(tilde(D)(x)) $

which is a ratio of two polynomials, whose numerator is of  degree at most $n$ and whose denominator is of degree at most $n-d$.

=== Polynomial $f$ of degree at most $d$:

If $f$ is a polynomial of degree at most $d$, then every $p_(i)$ is exactly equal to $f(x)$. This is because, by definition, $p_i$ is the unique polynomial of degree $<= d$ interpolating $f$ at $d+1$ points. If we then substitute $p_(i)(x) = f(x)$ into the definition of $r(x)$, we have:

$ r(x) = (sum_(i=0)^(n-d) lambda_(i)(x) p_(i)(x))/(sum_(i=0)^(n-d) lambda_(i)(x)) = (sum_(i=0)^(n-d) lambda_(i)(x) f(x))/(sum_(i=0)^(n-d) lambda_(i)(x)) = f(x) $

This, and the other results, however assume that the denominator $sum_(i=0)^(n-d) lambda_(i)(x)$ does not cancel. This is the case and can easily be seen from the definition of $lambda_i$. 

#pagebreak()

== 2. Barycentric form of $r(x)$

To express $r(x)$ in the barycentric form given in the statement, let's first express each polynomial $p_i$ in the Lagrange form. We recall that $p_j$ interpolates $f$ at $x_j, dots, x_(j+d)$:

$ p_(j)(x) = sum_(l=j)^(j+d) f(x_l) L_(j,l)(x) $

where $L_(j,l)$ is the Lagrange polynomial for the nodes $x_j, dots, x_(j+d)$, defined as:

$ L_(j,l) = product_(m&=j\ m &!= l)^(j+d) (x - x_m)/(x_l - x_m) $

Now let's substitute $p_i$ with this form in the numerator $N(x)$:

$ 
N(x) &= sum_(j=0)^(n-d) lambda_(j)(x) p_(j)(x)\
     &= sum_(j=0)^(n-d) lambda_(j)(x) (sum_(l=j)^(j+d) f(x_l) L_(j,l)(x))\
     &= sum_(j=0)^(n-d) sum_(l=j)^(j+d) f(x_l) lambda_(j)(x) L_(j,l)(x)
$

Knowing that $lambda_(j)(x) = ((-1)^j)/(product_(m=j)^(j+d) (x - x_(m)))$, the product $lambda_(j)(x) L_(j,l)(x)$ can be simplified to:

$
  lambda_(j)(x) L_(j,l)(x) &= ((-1)^j)/(product_(m=j)^(j+d) (x - x_(m))) dot product_(m&=j\ m &!= l)^(j+d) (x - x_m)/(x_l - x_m)\

  &= (-1)^j dot (1)/(x - x_l) dot product_(m&=j\ m &!= l)^(j+d) (1)/(x_l - x_m)\
  &= (C_(j,l))/(x - x_l)
$

where we defined $ C_(j,l) := (-1)^j product_(m&=j\ m &!= l)^(j+d) (1)/(x_l - x_m) $

Our numerator thus becomes:

$
  N(x) = sum_(j=0)^(n-d) sum_(l=j)^(j+d) f(x_l) (C_(j,l))/(x - x_l)
$

To obtain the required form, we need to interchange the sums. To do that, let's introduce this notation:

$
  chi_E := cases(1 quad "if" E "is true", 0 quad "otherwise")
$

This allows to rewrite the previous sums so that the inner one does not depend on the outer one:

$
N(x) &= sum_(j=0)^(n-d) sum_(l=j)^(j+d) f(x_l) (C_(j,l))/(x - x_l)\
     &= sum_(j=0)^(n-d) sum_(l=0)^(n) f(x_l) (C_(j,l))/(x - x_l) chi_({j <= l <= j+d})
$

The sums can now be interchanged safely:

$
N(x) &= sum_(j=0)^(n-d) sum_(l=0)^(n) f(x_l) (C_(j,l))/(x - x_l) chi_({j <= l <= j+d})\
     &= sum_(l=0)^(n) sum_(j=0)^(n-d) f(x_l) (C_(j,l))/(x - x_l) chi_({j <= l <= j+d})\
     &= sum_(l=0)^(n) f(x_l)/(x - x_l) (sum_(j=0)^(n-d)C_(j,l) chi_({j <= l <= j+d}))\
$

Now, because $j$ starts at $0$ but must be $l-d$, the starting index can be written as $max(0, l-d)$. The ending index can be written as $min(l, n-d)$ because $j$ ends at $n-d$ but must also be smaller than $l$. The sum thus becomes: 

$
N(x) &= sum_(i=0)^(n) f(x_i)/(x - x_i) (sum_(j=max(0, i-d))^(min(i, n-d))C_(j,i))\
     &= sum_(i=0)^(n) (w_i)/(x - x_i) f(x_i)
$

where we defined:

$
w_i = sum_(j=max(0, i-d))^(min(i, n-d))C_(j,i) = sum_(j=max(0, i-d))^(min(i, n-d)) (-1)^j product_(k&=j\ k &!= i)^(j+d) (1)/(x_i - x_m)
$

The same logic can be applied to the denominator $D(x)$ to obtain:

$
  D(x) = sum_(i=0)^(n) (w_i)/(x - x_i) quad square
$


== 4. Applying Floater-Hormann to test functions
\
a) We will now apply the same tests as before but using  the Floater-Hormann method. We will be using the same functions, the same values of $n$ and values of $d = {0, 3, 5, 8}$. However, we must have $d <= n$ so we can not test all values of $d$ for all values of $n$.


#figure(
  grid(
    columns: (auto, auto),
    image("figures/Floater_Hormann_f_1x.svg"),
    image("figures/Floater_Hormann_f_2x.svg")
  ),
  caption: [Floater-Hormann method applied to $f_1$ and $f_2$ with $n={5, 10, 15}$ and $d={0, 3, 5, 8} $ (when applicable)]
)<fig:q4.a_plot>

On @fig:q4.a_plot, we observe that the Floater-Hormann interpolation does not interpolate $f_(1)(x) = cos(x)$ as well as the first two methods we used. However, as $n$ increases, we see that it starts to interpolate it pretty well. The same can be said for $f_2$. However, we can see that the Runge's phenomenon is less present than before, at least for small $d$. In fact, when $d$ reaches $n$, Floater-Hormann method becomes a polynomial interpolation like Newton's or Neville's method. We see that for high $n$'s, small values of $d$ like $d = 0$ or $d=3$, the Runge's phenomenon is almost not noticeable. Let's now, like before, compute and plot the errors to further analyze the performance

\

b) Let's compute the errors based on the $cal(l)^2$-norm for values of $n$ ranging from $5$ to $30$ and for different values of $d$ ranging from $0$ to $15$ (only for valid $n$'s):

#figure(
  grid(
    columns: (auto, auto),
    image("figures/Floater_Hormann_f_1x_error.svg", width: 110%),
    image("figures/Floater_Hormann_f_2x_error.svg", width: 110%)
  ),
  caption: [Interpolation errors of the Floater-Hormann method applied to $f_1$ and $f_2$ with respect to $n$ for different $d$]
)<fig:q4.b_errors>

On @fig:q4.b_errors, we see that the errors seem to decrease as $n$ increases whether we try to interpolate $f_1$ or $f_2$. However, a noticeable difference is in the choice of $d$. In fact, for $f_1$, a higher value of $d$ seems to make the error smaller, which is not the case for $f_2$. This can be explained by the fact that choosing a smaller $d$ prevents the Runge's phenomenon from happening, which is why the error is smaller in the interpolation of $f_2$ for small $d$'s. For this function, it looks like the best $d$ is $d=2$.\
Because the first function does not manifest a Runge's phenomenon when interpolated, picking a higher $d$ allows to interpolate almost perfectly because we tend to a polynomial interpolation which, as we have seen previously, interpolates this specific function better.

\

c) To compare this method with the Newton and Neville's ones, we can simply look at @fig:q4.b_errors for the errors when $n=d$ because this corresponds to the polynomial interpolation as said previously.\
For $f_1$, we see that the polynomial interpolation is clearly better than Floater-Hormann's interpolation. Again, this is because there is no Runge's phenomenon so there is no point in using the latter. However, for $f_2$, choosing a smaller blending value makes the Runge's phenomenon vanish which decreases the error. 


= Conclusion

For functions that are easily interpolated by polynomials, Newton's and Neville's methods are better suited than Floater-Hormann. Amongst these two, Newton's method is better for multiple evaluations because, even though the coefficient cost is $cal(O)(n^2)$, it is performed only once. Each evaluation then only has a complexity of $cal(O)(n)$. Neville's method is better when we only have to compute a single evaluation.\
When a Runge's phenomenon appears when we perform a polynomial interpolation, one should fall back to a Floater-Hormann interpolation with a small $d$. 

#pagebreak()


#bibliography("bib.yml", full: true, title: "References")