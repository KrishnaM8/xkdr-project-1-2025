# Conditional Survival Analysis of Judicial Case Timelines

## Overview

The project built on an **existing survival-analysis framework for judicial case timelines** and focused specifically on extending the analysis through **conditional survival analysis**.

The central question was:

> **Given that a case has already remained unresolved through a particular number of hearings, how does its probability of eventual disposal change?**

This approach shifts the analysis from simply asking how long cases take to resolve to examining **how the likelihood of disposal evolves conditional on the procedural history of the case**.

## Project Overview

Judicial cases often pass through multiple hearings before reaching disposal. A case that has already survived several hearings without being disposed of may have a different probability of disposal than a newly filed case.

To study this, the project applied **conditional survival analysis conditioned on the number of hearings a case had undergone**.

The analysis builds on existing survival models and examines survival probabilities after conditioning on prior hearings, providing a way to understand how case duration and procedural progression interact.

## Conditional Survival Analysis

The key analytical framework was to estimate survival probabilities conditional on a case having already remained unresolved through a specified number of hearings.

For example:

* What is the probability that a case remains unresolved after **5 hearings**, given that it has already reached its 5th hearing?
* How does the probability of eventual disposal change after **10, 20, or more hearings**?
* Does the likelihood of disposal increase or decrease as a case progresses through successive hearings?

This provides a more granular view of judicial timelines than an unconditional survival curve alone.

## Methodology

The project worked with the existing survival-analysis framework and focused on extending it through conditional analysis.

Key components included:

* Defining **case disposal as the event of interest**
* Measuring time-to-event within the existing survival framework
* Accounting for **censored cases** that had not yet been disposed
* Conditioning survival probabilities on the **number of hearings already completed**
* Comparing survival patterns across different points in a case's procedural history
* Interpreting conditional survival probabilities in the context of judicial case progression

## Why Hearings Matter

The number of hearings provides an important measure of a case's procedural progression.

Two cases with similar overall ages may be at very different stages of the judicial process if one has undergone substantially more hearings. Conditioning survival estimates on hearings therefore allows the analysis to capture an aspect of case progression that a simple time-based survival estimate may not fully represent.

The resulting framework can help examine questions around **case persistence, procedural progression, and the likelihood of disposal as hearings accumulate**.

## Key Analytical Question

The project can be summarized as:

**How does the probability of case disposal change conditional on the number of hearings a case has already experienced?**

This makes conditional survival analysis particularly relevant for understanding prolonged litigation and identifying points in the judicial process where cases may become increasingly persistent.

## Context

This work was undertaken as part of my **Research Internship at XKDR**, working with the **Legal Systems Team** on quantitative approaches to understanding judicial processes and timelines.

The project builds on the team's existing survival-analysis work and focuses specifically on **conditional survival analysis using hearings as the conditioning variable**.

## Repository Structure

```text
.
├── README.md
├── conditional_survival/
├── notebooks/
└── results/
```

The repository structure may vary depending on the final organization of the project.
