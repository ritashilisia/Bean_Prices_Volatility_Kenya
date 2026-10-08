# Food Price Volatility Across Kenyan Markets

## Overview
This project investigates which regions in Kenya experience the most unstable
food prices. Using monthly market-level price data, it constructs a volatility
measure for each market, aggregates it to the regional level, and compares
regions to identify which ones are consistently the most (and least) volatile
over time.

## Research Question
**Which regions in Kenya have the most unstable food prices, and how has that
instability evolved over time?**

## Data
- Monthly price data (high/low) collected across 234 markets in Kenya
- Markets are grouped into regions and sub-regions
- Time coverage: 2005–present (monthly panel)

## Method
1. **Data cleaning and structuring** — renamed variables, encoded
   region/sub-region/market identifiers, converted raw date strings into a
   proper Stata monthly date format.
2. **Panel setup** — declared the dataset as a market × month panel using
   `xtset`, and ran basic sanity checks (duplicates, zero-price entries, gaps
   in the time variable).
3. **Volatility estimation** — calculated volatility for each market, each
   month, using the **Parkinson estimator**, which uses the high/low price
   range within a period rather than only closing prices. This gives a more
   information-rich measure of price instability than raw price levels or
   simple standard deviation.
4. **Aggregation** — collapsed market-level volatility to the region-month
   level, preserving the original market-level panel alongside the
   aggregated version.
5. **Comparative analysis** — plotted all regions together, then narrowed the
   focus to four representative regions (two high-volatility, two
   low-volatility) for a clearer comparative view.

## Key Findings
- **Meru and Embu are consistent volatility outliers.** Across the full
  2005–present period, these two regions repeatedly post the sharpest price
  swings in the dataset, well above the rest of the regions.
- **Most other regions form a comparatively stable cluster** — including
  Nairobi, Coast, Rift Valley, Nyanza, and others — with smaller, less
  frequent volatility spikes.
- **Shocks are shared, but not equally absorbed.** Volatility rises across
  nearly all regions around the same broad periods (e.g. 2016, 2019–2020,
  2023), suggesting common shocks (such as drought or supply disruptions),
  but Meru and Embu amplify these shocks far more sharply than other regions.
- **Volatility has trended downward recently.** From around 2024 onward,
  volatility across all regions converges toward a lower, more stable range,
  with one notable exception: an isolated spike in Embu near 2026.

## Limitations and Next Steps
- The apparent seasonality of volatility spikes has been observed visually
  but not yet formally tested (e.g. via month-of-year regression or boxplot
  analysis).
- The 2026 Embu spike appears as a sharp, isolated outlier and should be
  checked against the underlying price data to rule out a data quality issue
  before being interpreted as a genuine market event.
- Future work could explore *why* Meru and Embu are structurally more
  volatile — for example, differences in market access, distance to
  production areas, or storage infrastructure.

## Files
- `Food_price_volatility.do` — full Stata do-file covering data cleaning,
  volatility calculation, aggregation, and visualization.
- Bean Prices.dta - raw data

## Tools
Stata (data cleaning, panel construction, Parkinson volatility calculation,
visualization).

##Data Source
Andrée, B. P. J. (2021). Monthly food price estimates by product and market (Version 2026-05-18). KEN_2021_RTFP_v02_M. Washington, DC: World Bank Microdata Library. https://doi.org/10.48529/2ZH0-JF55
