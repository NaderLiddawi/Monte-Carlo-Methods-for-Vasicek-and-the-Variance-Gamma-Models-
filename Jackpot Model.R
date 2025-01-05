# Project program for Jackpot model
library(pracma)  # Import the `pracma` library for numerical computations.

# Parameters for the simulation
S_0 <- 50         # Initial stock price.
K <- 50           # Strike price of the option.
r_0 <- 0.07       # Initial interest rate.
sigma <- 0.13     # Volatility of the asset price.
T <- 1            # Time to maturity in years.
d <- 12           # Number of time steps (12 = monthly); change to 52 for weekly.
delta <- T / d    # Time step size (∆ = T / d).

# Monte Carlo parameters
n <- 87281        # Number of simulations; adjust to 92609 for d = 52.

tic()  # Start the timer to monitor computation time.

# Generate sample paths for interest rate in the Jackpot model (Vasicek model)
r <- matrix(numeric(n * d), nrow = n)  # Create a matrix to store interest rates.
z <- matrix(rnorm(n * d), nrow = n)    # Generate standard normal random variables.

# Initialize the first column of interest rate matrix
r[, 1] <- r_0 + 0.18 * (0.086 - r_0) * delta + 0.02 * sqrt(delta) * z[, 1]

# Loop to calculate interest rates iteratively
for (i in 2:d) {
  r[, i] <- r[, i - 1] + 0.18 * (0.086 - r[, i - 1]) * delta + 0.02 * sqrt(delta) * z[, i]
}

# Generate sample paths for asset prices in the Jackpot model
y <- matrix(rgamma(n * d, delta / 0.15, scale = 0.15), nrow = n)  # Gamma-distributed variables.
x <- matrix(rnorm(n * d), nrow = n)                              # Normal random variables.
S <- matrix(numeric(n * d), nrow = n)                            # Create asset price matrix.

# Initialize first column of asset price matrix
S[, 1] <- S_0 * exp((r[, 1] + log(1 - 0.15 * sigma^2 / 2) / 0.15) * delta + sigma * sqrt(y[, 1]) * x[, 1])

# Loop to calculate asset prices iteratively
for (i in 2:d) {
  S[, i] <- S[, i - 1] * exp((r[, i] + log(1 - 0.15 * sigma^2 / 2) / 0.15) * delta + sigma * sqrt(y[, i]) * x[, i])
}

# Calculate the discounted payoff
payoff <- pmax(S[, d] - K, 0) * exp(-delta * apply(r, 1, sum))

# Estimate the fair price of the option
fairprice <- mean(payoff)           # Compute the average of the payoffs.
est_error <- 2.58 * sd(payoff) / sqrt(n)  # Compute the standard error (99% confidence interval).

toc()  # End the timer to calculate computation time.

# Additional computations for error tolerance and variance
hat_sigma <- sd(payoff)   # Find standard deviation of the payoffs.
C <- 1 - 1 / n            # Amplifying constant for variance adjustment.
N <- ceiling((2.58 * hat_sigma / (0.05))^2)  # Calculate required sample size for specified error tolerance.

# Regular Geometric Brownian motion (GBM) model
# Find option price using the GBM model as a comparison
ExactEuroCall <- S_0 * pnorm(log(S_0 / K) + (r_0 - sigma^2 / 2) * T / (sigma * sqrt(T))) -
  K * exp(-r_0 * T) * pnorm(log(S_0 / K) + (r_0 - sigma^2 / 2) * T / (sigma * sqrt(T)))

