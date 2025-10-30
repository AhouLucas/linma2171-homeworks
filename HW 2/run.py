import numpy as np
import matplotlib.pyplot as plt

##### PARAMETERS #####
X_START = -1
X_END = 1
NUM_EVAL_POINTS = 200


class NewtonInterpolator:
    def __init__(self, x_points, y_points):
        self.x_points = x_points
        self.y_points = y_points
        self.n = len(x_points)
        self.divided_diff = self.compute_divided_differences()

    def compute_divided_differences(self):
        n = self.n
        coef = np.zeros((n, n))
        coef[:, 0] = self.y_points

        for j in range(1, n):
            for i in range(n - j):
                coef[i][j] = (coef[i + 1][j - 1] - coef[i][j - 1]) / (self.x_points[i + j] - self.x_points[i])
        return coef[0]

    def evaluate(self, x):
        n = self.n
        result = self.divided_diff[0]
        term = 1.0

        for i in range(1, n):
            term *= (x - self.x_points[i - 1])
            result += self.divided_diff[i] * term
        return result
    

class NevilleInterpolator:
    def __init__(self, x_points, y_points):
        self.x_points = x_points
        self.y_points = y_points
        self.n = len(x_points)

    def evaluate_single_point(self, x):
        n = self.n
        y = np.copy(self.y_points)
        for k in range(1, n):
            y[0:n - k] = (self.x_points[k:n] - x) * y[0:n - k] + (x - self.x_points[0:n - k]) * y[1:n - k + 1]
            y[0:n - k] /= (self.x_points[k:n] - self.x_points[0:n - k])
        return y[0]
    
    def evaluate(self, x):
        return np.array([self.evaluate_single_point(xi) for xi in x])
    

def f1(x):
   return np.cos(x)

def f2(x):
   return 1 / (1 + 25 * x**2)


def plot_interpolations(function, interpolator, inter_label, func_label, title, n_arr):
    """Create subplots to show interpolation for different n values contained in n_arr.
    """
    x_eval = np.linspace(X_START, X_END, NUM_EVAL_POINTS)
    y_true = function(x_eval)

    plt.figure(figsize=(15, 3 * len(n_arr)))

    for i, n in enumerate(n_arr):
        xi = np.linspace(X_START, X_END, n)
        yi = function(xi)
        interpolator_instance = interpolator(xi, yi)
        y_interp = interpolator_instance.evaluate(x_eval)

        plt.subplot(len(n_arr), 1, i + 1)
        plt.plot(x_eval, y_true, label=f'True Function: {func_label}', color='blue')
        plt.plot(x_eval, y_interp, label=f'Interpolation: {inter_label} (n={n})', linestyle='--', color='red')
        plt.scatter(xi, yi, color='black', zorder=5)
        plt.title(f'{title} (n={n})')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.legend()
        plt.grid()

    plt.tight_layout()
    plt.savefig("figures/" + inter_label + "_" + func_label.replace('$', '').replace('(', '').replace(')', '').replace('^', '').replace('/', '') + ".svg", format='svg')
    plt.show()


if __name__ == "__main__":
    n_values = [5, 10, 15]

    plot_interpolations(f1, NewtonInterpolator, 'Newton', r'$f_1(x)$', "Newton's Interpolation of cos(x)", n_values)

    # Interpolation for f1 using Neville's method
    plot_interpolations(f1, NevilleInterpolator, 'Neville', r'$f_1(x)$', "Neville's Interpolation of cos(x)", n_values)

    plot_interpolations(f2, NewtonInterpolator, 'Newton', r'$f_2(x)$', "Newton's Interpolation of 1/(1+25x^2)", n_values)

    # Interpolation for f2 using Neville's method
    plot_interpolations(f2, NevilleInterpolator, 'Neville', r'$f_2(x)$', "Neville's Interpolation of 1/(1+25x^2)", n_values)