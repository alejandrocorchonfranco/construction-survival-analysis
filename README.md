# Survival Analysis of the Construction Sector  
**Kaplan–Meier Estimation and Cox Proportional Hazards Modelling for Spanish Construction Firms**

This repository contains the full survival analysis conducted on a sample of firms operating in the Spanish construction sector, using firm-level microdata obtained from the SABI database. The objective is to characterise time-to-failure dynamics and quantify the effects of financial and operational covariates on the hazard of market exit.

---

## Research Scope
- Estimation of **non-parametric survival functions** using the Kaplan–Meier estimator.  
- Comparison of group-specific survival distributions via **Log-Rank**, **Breslow**, and **Tarone–Ware** tests.  
- Specification and estimation of a **Cox Proportional Hazards (PH) model**, including diagnostics for the PH assumption.  
- Integration of **time-dependent covariates** where proportionality is violated.  
- Identification of statistically significant determinants of the **hazard rate of insolvency**.

---

## Data Description
- **Source:** SABI (Bureau van Dijk)  
- **Initial sample:** 500 firms in NACE Rev.2 code *410 – Construction*.  
- **Final analytical sample:** 194 firms with complete information.  
- **Event definition:**  
  - *Event = 1* → firm dissolved / liquidated / in insolvency proceedings  
  - *Censored = 0* → firm still active or registry closure without confirmed failure  
- **Time variable:** Firm age at censoring or event (years).

Key variables used in modelling:
- **ROA (Return on Assets)** — profitability metric.  
- **N_EMP** — number of employees.  
- **BPE** — profit per employee.  
- **State** — event indicator.  
- **Time** — duration until event/censoring.

---

## Methodology

### Kaplan–Meier Survival Estimation
The non-parametric estimator is computed to obtain the empirical survival function  
- S_hat(t) = Π over all event times t_i ≤ t of (1 − d_i / n_i),

where d_i is the number of events at time t_i and n_i is the number of firms at risk just before t_i.

Survival curves are stratified by autonomous community to assess regional heterogeneity.

### Group Comparison: Log-Rank, Breslow, Tarone–Ware
The equality of survival functions across groups is tested using:
- **Log-Rank** (equal weighting across time)
- **Breslow / Generalized Wilcoxon** (early-time weighting)
- **Tarone–Ware** (intermediate weighting)

All three tests reject equality (p < 0.01), indicating statistically significant differences in survival distributions across regions.

### Cox Proportional Hazards Model
A semiparametric hazard specification is estimated as:
\[
h(t | X) = h_0(t)\exp(\beta' X),
]\
with covariates representing profitability, size, and productivity.

Diagnostics for the PH assumption include:
- Schoenfeld residual-based tests  
- Time-interaction terms (*X × t*)

The number of employees violates proportional hazards; hence a **time-dependent effect** is included.

### Final Model Specification
The final hazard function includes:
- **ROA** (significant, positive effect on hazard)  
- **N_EMP** (significant, initial positive effect)  
- **N_EMP × Time** (significant, attenuating effect over time)  
- **BPE** (non-significant)

Key interpretations:
- A one-unit increase in ROA increases the instantaneous hazard by approx. **0.9%**.  
- Higher employment levels increase early-stage failure risk, but the effect decreases by approx. **0.3% per year of firm age**.
