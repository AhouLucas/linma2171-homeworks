import numpy as np
import matplotlib.pyplot as plt
from numpy.polynomial import Polynomial


def f(x):
    return np.exp(-np.pow(x, 2) / 2)

def f_prime(x):
    return -x * f(x)

def f_prime_second(x):
    return (np.pow(x, 2) - 1) * f(x)


def L(nodes, i) -> Polynomial:
    """Return the ith Lagrange polynomial for nodes `nodes`"""
    nodes = np.asarray(nodes)
    n = len(nodes) - 1
    L_i = Polynomial([1.0])  # Start with the polynomial 1
    for j in range(n + 1):
        if j != i:
            # Create the polynomial (x - nodes[j]) / (nodes[i] - nodes[j])
            factor = Polynomial([-nodes[j], 1]) / (nodes[i] - nodes[j])
            L_i = L_i * factor  # Multiply the polynomials
    return L_i

def L_eval(nodes, i, x):
    """Evaluate the ith Lagrange polynomial at every value in `x` for nodes `nodes`"""
    # nodes = np.asarray(nodes)
    # x = np.asarray(x)
    # n = len(nodes) - 1
    # terms = [(x - nodes[j]) / (nodes[i] - nodes[j]) for j in range(n + 1) if j != i]
    # result = np.prod(terms, axis=0)
    result = L(nodes, i)(x)
    return result

def L_prime(nodes, i):
    # x = np.asarray(x)
    # return (L(nodes, i, x + h) - L(nodes, i, x - h)) / (2 * h)
    return L(nodes, i).deriv()

def L_prime_eval(nodes, i, x):
    return L_prime(nodes, i)(x)

def L_prime_second(nodes, i):
    # x = np.asarray(x)
    # return (L(nodes, i, x + h) - 2 * L(nodes, i, x) + L(nodes, i, x - h)) / (h * h)
    return L(nodes, i).deriv(2)

def L_prime_second_eval(nodes, i, x):
    return L_prime_second(nodes, i)(x)

def q(nodes, i, x, coeff: tuple):
    x = np.asarray(x)
    a, b, c = coeff
    return np.power(L_eval(nodes, i, x), 3) * (a + b * x + c * np.power(x, 2))


# Precompute coeff a, b, c for alpha, beta, gamma

def alpha_coeffs(nodes, i):
    x_i = nodes[i]
    x_i_sq = x_i ** 2
    lp = L_prime_eval(nodes, i, x_i)
    lp_sq = lp ** 2
    lpp = L_prime_second_eval(nodes, i, x_i)

    a = 1 + (3 * x_i * lp) + (6 * x_i_sq * lp_sq) - (3 * x_i_sq * lpp / 2)
    b = (-3 * lp) - (12 * x_i * lp_sq) + (3 * x_i * lpp)
    c = (6 * lp_sq) - (3 * lpp / 2)

    return (a, b, c)

def beta_coeffs(nodes, i):
    x_i = nodes[i]
    x_i_sq = x_i ** 2
    lp = L_prime_eval(nodes, i, x_i)

    a = (-3 * x_i_sq * lp) - x_i
    b = 1 + (6 * x_i * lp)
    c = -3 * lp

    return (a, b, c)

def gamma_coeffs(nodes, i):
    x_i = nodes[i]
    x_i_sq = x_i ** 2

    a = x_i_sq / 2
    b = -x_i
    c = 1 / 2

    return (a, b, c)


def alpha(nodes, i, x, coeffs):
    x = np.asarray(x)
    a, b, c = coeffs
    return q(nodes, i, x, (a, b, c))


def beta(nodes, i, x, coeffs):
    x = np.asarray(x)
    a, b, c = coeffs
    return q(nodes, i, x, (a, b, c))


def gamma(nodes, i, x, coeffs):
    x = np.asarray(x)
    a, b, c = coeffs
    return q(nodes, i, x, (a, b, c))


def p(x, nodes, alpha_coeffs, beta_coeffs, gamma_coeffs):
    n = len(nodes)
    result = np.zeros_like(x)

    for i in range(n):
        result += (alpha(nodes, i, x, alpha_coeffs[i]) * f(nodes[i]) +
                   beta(nodes, i, x, beta_coeffs[i]) * f_prime(nodes[i]) +
                   gamma(nodes, i, x, gamma_coeffs[i]) * f_prime_second(nodes[i]))

    return result


def generate_nodes(n):
    return np.linspace(RANGE_START, RANGE_END, n)


def compute_error(y, y_p):
    return np.sum(np.abs(y - y_p))

def interpolate(N):
    nodes = generate_nodes(N)
    # Compute all coefficients once for efficiency
    all_alpha_coeffs = [alpha_coeffs(nodes, i) for i in range(N)]
    all_beta_coeffs = [beta_coeffs(nodes, i) for i in range(N)]
    all_gamma_coeffs = [gamma_coeffs(nodes, i) for i in range(N)]
    x = np.linspace(RANGE_START, RANGE_END, 1000)
    y = f(x)
    y_p = p(x, nodes, all_alpha_coeffs, all_beta_coeffs, all_gamma_coeffs)
    error = compute_error(y, y_p)
    return nodes, x, y, y_p, error

def plot_interpolation(nodes, x, y, y_p, N, error, show=True):
    plt.figure(figsize=(10, 6))
    plt.plot(x, y, label=r'$f(x)$', color='blue')
    plt.plot(x, y_p, label=r'$p_{%d}(x)$' % (3*N + 2), linestyle='--', color='orange')
    plt.scatter(nodes, f(nodes), color='red', zorder=5, label='Nodes')
    plt.title(r'Hermite Interpolation of $f(x) = e^{-x^2/2}$ with ' + f'{N} nodes, total error = {error:.2e}')
    plt.xticks(np.arange(RANGE_START, RANGE_END + 1, 1))
    plt.xlabel('x')
    plt.ylabel('y')
    plt.legend()
    plt.grid(alpha=0.3, linestyle='--')
    
    if show:
        plt.show()
    else:
        plt.savefig(f'figures/interpolation_N{N}.png')
        plt.close()

def plot_total_errors(n, errors, show=True):
    plt.figure(figsize=(10, 6))
    plt.plot(n, errors, label='Total Error', color='green')
    plt.title('Total Error of Hermite Interpolation')
    plt.xticks(n)
    plt.xlabel('Number of Nodes')
    plt.ylabel('Total Error')
    plt.yscale('log')
    plt.legend()
    plt.grid(alpha=0.3, linestyle='--')
    if show:
        plt.show()
    else:
        plt.savefig('figures/total_errors.png')
        plt.close()



RANGE_START = -5
RANGE_END   =  5

N_START = 4
N_END   = 20


if __name__ == "__main__":
    errors = []
    n = range(N_START, N_END + 1, 1)
    for N in n:
        nodes, x, y, y_p, max_error = interpolate(N)
        plot_interpolation(nodes, x, y, y_p, N, max_error)
        errors.append(max_error)

    plot_total_errors(n, errors)