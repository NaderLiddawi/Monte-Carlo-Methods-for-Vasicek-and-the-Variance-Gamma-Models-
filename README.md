# Jackpot Model: Mathematical Theory and Implementation

The Jackpot Model combines two key stochastic models: the **Vasicek model** for interest rate simulation and the **Variance-Gamma model** for asset price dynamics. This combination enables the modeling of asset price paths influenced by stochastic interest rates and non-Gaussian return distributions, incorporating skewness and heavy tails. Below is a detailed explanation of the mathematical framework behind the model.

---

## 1. Vasicek Model for Stochastic Interest Rates

The Vasicek model is a mean-reverting stochastic process used for modeling interest rates. It is defined as:

$$
dr(t) = a (\mu_r - r(t)) dt + \sigma_r dB(t),
$$

where:
- $$\( a > 0 \)$$: The rate of mean reversion, dictating how quickly the interest rate $$\( r(t) \)$$ reverts to its long-term mean $$\( \mu_r \)$$.
- $$\( \mu_r \)$$: The long-term mean interest rate.
- $$\( r(t) \)$$: The interest rate at time \( t \).
- $$\( \sigma_r > 0 \)$$: The instantaneous volatility of the interest rate.
- $$\( dB(t) \)$$: A standard Wiener process capturing randomness.

The solution to this stochastic differential equation (SDE) is:

$$
r(t) = r(0)e^{-a t} + \mu_r(1 - e^{-a t}) + \sigma_r \int_0^t e^{-a (t-s)} dB(s).
$$

In a discrete-time setting, this is approximated as:

$$
r(t_{j}) = r(t_{j-1}) + a (\mu_r - r(t_{j-1})) \Delta t + \sigma_r \sqrt{\Delta t} Z_j,
$$

where:
- $$\( \Delta t \)$$: The time step size.
- $$\( Z_j \sim N(0, 1) \)$$: Independent standard normal random variables.

---

## 2. Variance-Gamma Model for Asset Prices

The Variance-Gamma model generalizes the Geometric Brownian Motion (GBM) model to account for skewness and heavy tails in asset returns. The model is expressed as:

$$
S(t_j) = S(t_{j-1}) e^{\left( r(t_{j-1}) + \frac{\ln(1 - 0.15\sigma^2 / 2)}{0.15} \right) \Delta t + \sigma \sqrt{Y_j}  X_j},
$$

where:
- $$\( S(t_j) \)$$: The asset price at time $$\( t_j \)$$.
- $$\( r(t_{j-1}) \)$$: The interest rate at time $$\( t_{j-1} \)$$.
- $$\( X_j \sim N(0, 1) \)$$: Standard normal random variables.
- $$\( Y_j \sim \text{Gamma}(\Delta t / 0.15, 0.15) \)$$: Gamma-distributed random variables with shape parameter $$\( \Delta t / 0.15 \)$$ and scale parameter $$\( 0.15 \)$$.
- $$\( \sigma \)$$: The volatility of the asset price.

This model introduces a stochastic variance component, $$\( \sqrt{Y_j} \)$$, capturing time-dependent changes in volatility. The term $$\( \frac{\ln(1 - 0.15\sigma^2 / 2)}{0.15} \)$$ adjusts for the reduction in volatility caused by gamma-distributed variance.

---

## 3. Fair Pricing of a European Call Option

The Jackpot model estimates the fair price of a European call option using Monte Carlo methods. The option payoff is defined as:

$$
\text{Payoff} = \max(S(T) - K, 0),
$$

where:
- $$\( S(T) \)$$: The asset price at maturity \( T \).
- $$\( K \)$$: The strike price of the option.

The payoff is discounted using the simulated interest rates:

$$
\text{Discount Factor} = e^{-\Delta t \sum_{j=1}^d r(t_j)}.
$$

The fair price of the option is then computed as:

$$
\text{Option Price} = \frac{1}{n} \sum_{i=1}^n \text{Payoff}_i \times \text{Discount Factor}_i,
$$

where:
- $$\( n \)$$: The number of simulated paths.
- $$\( \text{Payoff}_i \)$$: The payoff for the \( i \)-th simulation path.
- $$\( \text{Discount Factor}_i \)$$: The discount factor for the \( i \)-th simulation path.

---

## 4. Monte Carlo Error Analysis and Sample Size Determination

Monte Carlo simulation introduces sampling error, which decreases as the number of simulations \( n \) increases. The confidence interval for the estimated option price is:

$$
\text{CI} = \hat{P} \pm z_{\alpha/2} \frac{\hat{\sigma}}{\sqrt{n}},
$$

where:
- $$\( \hat{P} \)$$: The estimated option price.
- $$\( \hat{\sigma} \)$$: The standard deviation of the simulated payoffs.
- $$\( z_{\alpha/2} \)$$: The critical value for a given confidence level (e.g., 2.58 for 99%).

To achieve a target error tolerance \( \epsilon \), the required sample size \( n \) is:

$$
n \geq \left( \frac{z_{\alpha/2} \hat{\sigma}}{\epsilon} \right)^2.
$$

---

## 5. Integration of Vasicek and Variance-Gamma Models

The Jackpot model combines the Vasicek interest rate process with the Variance-Gamma asset price dynamics. At each time step $$\( t_j \)$$:

**Simulate** $$\( r(t_j) \)$$ using the Vasicek model:

$$
r(t_j) = r(t_{j-1}) + a (\mu_r - r(t_{j-1})) \Delta t + \sigma_r \sqrt{\Delta t} Z_j
$$

**Update** $$\( S(t_j) \)$$ using the Variance-Gamma model:

$$
S(t_j) = S(t_{j-1}) e^{\left( r(t_{j-1}) + \frac{\ln(1 - 0.15\sigma^2 / 2)}{0.15} \right) \Delta t + \sigma \sqrt{Y_j} X_j}.
$$


This integration ensures consistency between the stochastic processes of interest rates and asset prices.

---

## 6. Comparison to Geometric Brownian Motion (GBM)

In the GBM model, the asset price follows:

$$
S(t_j) = S(t_{j-1}) e^{\left( r - \frac{\sigma^2}{2} \right) \Delta t + \sigma \sqrt{\Delta t} Z_j},
$$

where:
- $$\( S(t_j) \)$$: The asset price at time \( t_j \).
- $$\( r \)$$: The constant interest rate.
- $$\( \sigma \)$$: The constant volatility.
- $$\( Z_j \sim N(0, 1) \)$$: Independent standard normal random variables.

Unlike the Jackpot model, GBM assumes constant volatility and interest rates, leading to log-normal price distributions without skewness or heavy tails. Consequently, GBM prices may deviate from real-world market behavior, especially under varying interest rates or significant market events.

---

## Key Features of the Jackpot Model

- **Stochastic Interest Rates**: Modeled using the Vasicek process with mean reversion.
- **Non-Gaussian Returns**: Captured via the Variance-Gamma model for asset price dynamics.
- **Monte Carlo Simulation**: Estimates the fair price of European options by averaging discounted payoffs over simulated paths.
- **Improved Realism**: Incorporates skewness and heavy tails, reflecting more realistic market behavior compared to GBM.

---

For more details or to run the code, see the implementation in the `Jackpot Model.R` file.
