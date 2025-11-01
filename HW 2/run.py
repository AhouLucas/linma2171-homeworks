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


class FloaterHormannInterpolator:    
    def __init__(self, x_points, y_points, d=3):
        self.x_points = np.asarray(x_points)
        self.y_points = np.asarray(y_points)
        self.n = len(x_points) - 1  # n is the max index (0-indexed)
        self.d = d
        if self.d > self.n:
            raise ValueError(f"d={d} cannot be larger than n={self.n}")
        self.weights = self.compute_weights()

    def compute_weights(self):
        # Initialize weights to zero
        weights = np.zeros(self.n + 1)
        
        for i in range(self.n + 1):
            total = 0.0
            # j ranges over all intervals that contain node i
            j_min = max(0, i - self.d)
            j_max = min(i, self.n - self.d)
            
            for j in range(j_min, j_max + 1):
                # Start with the sign (-1)^j
                term = (-1.0) ** j
                
                # Multiply by the product over k in [j, j+d], k ≠ i
                for k in range(j, j + self.d + 1):
                    if k != i:
                        term /= (self.x_points[i] - self.x_points[k])
                
                total += term
            
            weights[i] = total
        
        return weights

    def evaluate(self, x):
        x = np.asarray(x)
        num = np.zeros_like(x, dtype=float)
        denom = np.zeros_like(x, dtype=float)
        
        # Check for exact matches with nodes first
        for i in range(len(x)):
            exact_match = False
            for j in range(self.n + 1):
                if np.abs(x[i] - self.x_points[j]) < 1e-12:
                    num[i] = self.y_points[j]
                    denom[i] = 1.0
                    exact_match = True
                    break
            
            if not exact_match:
                for j in range(self.n + 1):
                    w_j = self.weights[j] / (x[i] - self.x_points[j])
                    num[i] += w_j * self.y_points[j]
                    denom[i] += w_j
        
        return num / denom

    # Alternative vectorized evaluation (more efficient for many points)
    def evaluate_vectorized(self, x):
        x = np.asarray(x)
        num = np.zeros_like(x, dtype=float)
        denom = np.zeros_like(x, dtype=float)
        
        for j in range(self.n + 1):
            # Handle division by zero more carefully
            with np.errstate(divide='ignore', invalid='ignore'):
                w_j = self.weights[j] / (x - self.x_points[j])
            
            # For points exactly at nodes, use the known function value
            mask = np.abs(x - self.x_points[j]) < 1e-12
            w_j[mask] = 0.0  # Will be handled separately
            
            num += w_j * self.y_points[j]
            denom += w_j
        
        # Handle points that exactly coincide with nodes
        for j in range(self.n + 1):
            mask = np.abs(x - self.x_points[j]) < 1e-12
            num[mask] = self.y_points[j]
            denom[mask] = 1.0
        
        return num / denom

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

    errors = np.zeros(len(n_arr))

    for i, n in enumerate(n_arr):
        xi = np.linspace(X_START, X_END, n)
        yi = function(xi)
        interpolator_instance = interpolator(xi, yi)
        y_interp = interpolator_instance.evaluate(x_eval)

        # l2 norm of the error
        errors[i] = np.sqrt(np.sum((y_true - y_interp) ** 2) / NUM_EVAL_POINTS)

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

    # Plot errors vs n
    plt.figure()
    plt.plot(n_arr, errors, marker='o')
    plt.yscale('log')
    plt.xlabel('Number of Interpolation Points (n)')
    plt.ylabel('L2 Norm of Error')
    plt.title(f'Error in {inter_label} Interpolation of {func_label}')
    plt.grid()
    plt.savefig("figures/" + inter_label + "_" + func_label.replace('$', '').replace('(', '').replace(')', '').replace('^', '').replace('/', '') + "_error.svg", format='svg')
    plt.show()


def plot_floater_hormann_interpolations(function, func_label, n_arr):
    """Create subplots to show Floater-Hormann interpolation for different d values.
    """
    # Test different values of d depending on n
    d_values = [0, 3, 5, 8]

    d_colors = ['orange', 'green', 'red', 'purple']

    x_eval = np.linspace(X_START, X_END, NUM_EVAL_POINTS)
    y_true = function(x_eval)

    plt.figure(figsize=(15, 3 * len(n_arr)))

    errors = np.zeros((len(n_arr), len(d_values)))

    for n_idx, n in enumerate(n_arr):
        xi = np.linspace(X_START, X_END, n)
        yi = function(xi)
        plt.subplot(len(n_arr), 1, n_idx + 1)
        plt.plot(x_eval, y_true, label=f'True Function: {func_label}', color='blue')

        for d_idx, d in enumerate(d_values):
            if d >= n:
                continue  # Skip invalid d values

            interpolator_instance = FloaterHormannInterpolator(xi, yi, d=d)
            y_interp = interpolator_instance.evaluate(x_eval)

            # l2 norm of the error
            errors[n_idx, d_idx] = np.sqrt(np.sum((y_true - y_interp) ** 2) / NUM_EVAL_POINTS)
            
            plt.plot(x_eval, y_interp, label=f'Floater-Hormann (d={d})', linestyle='--', color=d_colors[d_idx])
            plt.scatter(xi, yi, color='black', zorder=5)

        plt.title(f'Floater-Hormann Interpolation of {func_label} (n={n})')
        plt.xlabel('x')
        plt.ylabel('y')
        plt.legend()
        plt.grid()

    plt.tight_layout()
    plt.savefig("figures/Floater_Hormann_" + func_label.replace('$', '').replace('(', '').replace(')', '').replace('^', '').replace('/', '') + ".svg", format='svg')
    plt.show()


def plot_floater_hormann_errors(function, func_label):
    n_values = range(5, 31)
    d_values = range(0, 16, 2)
    errors = np.zeros((len(n_values), len(d_values)))

    x_eval = np.linspace(X_START, X_END, NUM_EVAL_POINTS)
    y_true = function(x_eval)

    for n_idx, n in enumerate(n_values):
        xi = np.linspace(X_START, X_END, n)
        yi = function(xi)

        for d_idx, d in enumerate(d_values):
            if d >= n:
                errors[n_idx, d_idx] = np.nan  # Invalid case
                continue

            interpolator_instance = FloaterHormannInterpolator(xi, yi, d=d)
            y_interp = interpolator_instance.evaluate(x_eval)

            # l2 norm of the error
            errors[n_idx, d_idx] = np.sqrt(np.sum((y_true - y_interp) ** 2) / NUM_EVAL_POINTS)
    
    # Plot errors with respect to n for every d
    plt.figure(figsize=(10, 6))
    for d_idx, d in enumerate(d_values):
        valid_n_indices = [j for j in range(len(n_values)) if d < n_values[j]]
        plt.plot([n_values[j] for j in valid_n_indices], [errors[j, d_idx] for j in valid_n_indices], label=f'd={d}', alpha=0.7)
    
    plt.yscale('log')
    plt.xlabel('Number of Interpolation Points (n)')
    plt.ylabel('L2 Norm of Error')
    plt.title(f'Error in Floater-Hormann Interpolation of {func_label}')
    plt.grid()
    plt.legend()
    plt.savefig("figures/Floater_Hormann_" + func_label.replace('$', '').replace('(', '').replace(')', '').replace('^', '').replace('/', '') + "_error.svg", format='svg')
    plt.show()

if __name__ == "__main__":
    n_values = [5, 10, 15]

    # plot_interpolations(f1, NewtonInterpolator, 'Newton', r'$f_1(x)$', "Newton's Interpolation of cos(x)", n_values)

    # # Interpolation for f1 using Neville's method
    # plot_interpolations(f1, NevilleInterpolator, 'Neville', r'$f_1(x)$', "Neville's Interpolation of cos(x)", n_values)

    # plot_interpolations(f2, NewtonInterpolator, 'Newton', r'$f_2(x)$', "Newton's Interpolation of 1/(1+25x^2)", n_values)

    # # Interpolation for f2 using Neville's method
    # plot_interpolations(f2, NevilleInterpolator, 'Neville', r'$f_2(x)$', "Neville's Interpolation of 1/(1+25x^2)", n_values)

    # # Plot Floater-Hormann interpolations for f1
    # plot_floater_hormann_interpolations(f1, r'$f_1(x)$', n_arr=n_values)

    # # Plot Floater-Hormann interpolations for f2
    # plot_floater_hormann_interpolations(f2, r'$f_2(x)$', n_arr=n_values)

    # Plot Floater-Hormann error heatmap for f1
    plot_floater_hormann_errors(f1, r'$f_1(x)$')

    # Plot Floater-Hormann error heatmap for f2
    plot_floater_hormann_errors(f2, r'$f_2(x)$')