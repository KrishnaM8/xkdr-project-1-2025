# xkdr-project-1-2025

This repository contains one of many projects completed during my research internship with the Legal Systems Team at XKDR.

The project explored the use of survival analysis to model and predict the time to key events in the court system, such as case disposal and first hearing. The objective was to develop a methodological foundation that could later be applied to judicial case data.

Project Overview

Court cases often involve significant variation in the amount of time taken to reach important procedural events. Survival analysis provides a useful framework for studying this time-to-event problem, particularly because it can account for cases where the event has not yet occurred.

As part of establishing a base exercise for the project, I developed model profiles and analyses for:

Kaplan–Meier survival models — to estimate and visualize the probability of cases remaining unresolved over time.
Cox proportional hazards models — to examine how different covariates may affect the hazard, or likelihood, of a case reaching a particular event at a given point in time.
Conditional survival analysis — to explore survival probabilities conditional on a case having already remained unresolved for a given period.

Potential events of interest include:

First hearing
Case disposal
Other key procedural milestones in the judicial process

Purpose

The work was designed as a base analytical exercise to establish the modelling workflow before the underlying judicial dataset became available. The resulting profiles provide a framework that can be adapted to real court data once the relevant variables and event timelines are available.

Presentation

The work and methodology were presented to the Judicial Reforms Team, covering the motivation for survival analysis, Kaplan–Meier estimation, Cox proportional hazards modelling, and potential applications to judicial case timelines.

Methods

The project focuses on the following concepts:

Defining the event and time-to-event variables
Handling censored observations
Estimating survival functions using Kaplan–Meier methods
Comparing survival curves across groups
Modelling covariate effects using Cox proportional hazards
Interpreting hazard ratios
Exploring conditional survival probabilities
Translating survival-analysis outputs into questions relevant to judicial reform
Repository Structure
.
├── README.md
├── kaplan_meier/
├── cox_proportional_hazards/
├── conditional_survival/
├── notebooks/
└── results/

Repository structure may vary depending on the final organization of the project.

Context

This project was undertaken as part of my Research Internship at XKDR, working with the Legal Systems Team on quantitative approaches to understanding judicial processes and timelines.

The work is intended primarily as a methodological and exploratory foundation for subsequent analysis using judicial case data.