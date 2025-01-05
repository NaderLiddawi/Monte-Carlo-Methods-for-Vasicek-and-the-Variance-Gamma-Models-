# Jackpot Model: Mathematical Theory and Implementation

The Jackpot Model combines two key stochastic models: the **Vasicek model** for interest rate simulation and the **Variance-Gamma model** for asset price dynamics. This combination enables the modeling of asset price paths influenced by stochastic interest rates and non-Gaussian return distributions, incorporating skewness and heavy tails. Below is a detailed explanation of the mathematical framework behind the model.

---

## 1. Vasicek Model for Stochastic Interest Rates

The Vasicek model is a mean-reverting stochastic process used for modeling interest rates. It is defined as:

\[
dr(t) = a (\mu_r - r(t)) dt + \sigma_r dB(t),
\]

where:
- \( a > 0 \): The rate of mean reversion, dictating how quickly the interest rate \( r(t) \) reverts to its long-term mean \( \mu_r \).
- \( \mu_r \): The long-term mean interest rate.
- \( r(t) \): The interest rate at time \( t \).
- \( \sigma_r > 0 \): The instantaneous volatility of the interest rate.
- \( dB(t) \): A standard Wiener process capturing randomness.

The solution to this stochastic differential equation (SDE) is:

\[
r(t) = r(0)e^{-a t} + \mu_r(1 - e^{-a t}) + \sigma_r \int_0^t e^{-a (t-s)} dB(s).
\]

In a discrete-time setting, this is approximated as:

\[
r(t_{j}) = r(t_{j-1}) + a (\mu_r - r(t_{j-1})) \Delta t + \sigma_r \sqrt{\Delta t} Z_j,
\]

where \( \Delta t \) is the time step, and \( Z_j \sim N(0, 1) \) are independent standard normal random variables.

---

## 2. Variance-Gamma Model for Asset Prices

The Variance-Gamma model generalizes the Geometric Brownian Motion (GBM) model to account for skewness and heavy tails in asset returns. The model is expressed as:

\[
S(t_j) = S(t_{j-1}) e^{\left( r(t_{j-1}) + \frac{\ln(1 - 0.15\sigma^2 / 2)}{0.15} \right) \Delta t + \sigma \sqrt{Y_j} X_j},
\]

where:
- \( X_j \sim N(0, 1) \): Standard normal random variables.
- \( Y_j \sim \text{Gamma}(\Delta t / 0.15, 0.15) \): Gamma-distributed random variables with shape and scale parameters defined to match the time step \( \Delta t \).

This model introduces a stochastic variance component, \( \sqrt{Y_j} \), capturing time-dependent changes in volatility. The term \( \frac{\ln(1 - 0.15\sigma^2 / 2)}{0.15} \) adjusts for the reduction in volatility caused by gamma-distributed variance.

---

## 3. Fair Pricing of a European Call Option

The Jackpot model estimates the fair price of a European call option using Monte Carlo methods. The option payoff is defined as:

\[
\text{Payoff} = \max(S(T) - K, 0),
\]

where:
- \( S(T) \): Asset price at maturity \( T \).
- \( K \): Strike price.

The payoff is discounted using the simulated interest rates:

\[
\text{Discount Factor} = e^{-\Delta t \sum_{j=1}^d r(t_j)}.
\]

The fair price of the option is then computed as:

\[
\text{Option Price} = \frac{1}{n} \sum_{i=1}^n \text{Payoff}_i \times \text{Discount Factor}_i,
\]

where \( n \) is the number of simulation paths, and \( \text{Payoff}_i \) and \( \text{Discount Factor}_i \) are the respective payoff and discount factor for the \( i \)-th simulation.

---

## 4. Monte Carlo Error Analysis and Sample Size Determination

Monte Carlo simulation introduces sampling error, which decreases as the number of simulations \( n \) increases. The confidence interval for the estimated option price is:

\[
\text{CI} = \hat{P} \pm z_{\alpha/2} \frac{\hat{\sigma}}{\sqrt{n}},
\]

where:
- \( \hat{P} \): Estimated option price.
- \( \hat{\sigma} \): Standard deviation of the simulated payoffs.
- \( z_{\alpha/2} \): Critical value for a given confidence level (e.g., 2.58 for 99%).

To achieve a target error tolerance \( \epsilon \), the required sample size \( n \) is:

\[
n \geq \left( \frac{z_{\alpha/2} \hat{\sigma}}{\epsilon} \right)^2.
\]

---

## 5. Integration of Vasicek and Variance-Gamma Models

The Jackpot model combines the Vasicek interest rate process with the Variance-Gamma asset price dynamics. At each time step \( t_j \):
1. Simulate \( r(t_j) \) using the Vasicek model.
2. Update \( S(t_j) \) using the Variance-Gamma model, with \( r(t_j) \) influencing the asset price dynamics.

This integration ensures consistency between the stochastic processes of interest rates and asset prices.

---

## 6. Comparison to Geometric Brownian Motion (GBM)

In the GBM model, the asset price follows:

\[
S(t_j) = S(t_{j-1}) e^{\left( r - \frac{\sigma^2}{2} \right) \Delta t + \sigma \sqrt{\Delta t} Z_j},
\]

where \( Z_j \sim N(0, 1) \). Unlike the Jackpot model, GBM assumes constant volatility and interest rates, leading to log-normal price distributions without skewness or heavy tails. Consequently, GBM prices may deviate from real-world market behavior, especially under varying interest rates or significant market events.

---

## Key Features of the Jackpot Model

- **Stochastic Interest Rates**: Modeled using the Vasicek process with mean reversion.
- **Non-Gaussian Returns**: Captured via the Variance-Gamma model for asset price dynamics.
- **Monte Carlo Simulation**: Estimates the fair price of European options by averaging discounted payoffs over simulated paths.
- **Improved Realism**: Incorporates skewness and heavy tails, reflecting more realistic market behavior compared to GBM.

---

For more details or to run the code, see the implementation in the `Jackpot Model.R` file.
