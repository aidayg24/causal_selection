# 🧠 The Effect of Valence Framing on Inferring Causal Normalities

This repository contains all materials, data, and analysis scripts for my bachelor’s thesis:  
**“The Effect of Valence Framing on Inferring Causal Normalities”**  
completed at the **University of Tübingen** under the supervision of **Prof. Dr. Michael Franke**.

---

## 📄 Overview

This study investigates how **event normality**, **causal structure**, and **valence framing** influence people’s causal judgments.  
Building on the framework by *Kirfel & Icard (2021)*, it tests whether outcome valence (positive vs. negative) affects how people **select** or **interpret** causes in **conjunctive** and **disjunctive** causal structures.

The project includes two main parts:

- 🗣 **Speaker Task** – participants chose which cause best explained an outcome  
- 👂 **Listener Task** – participants inferred how normal each event was, given an explanation

---

## 📊 Repository Structure
.
├── data collection and data analysis/ # Raw and cleaned data from the experiment and R programs for analysis
├── src/ # Experiment codes and resources
├── public/images # images used in the experiment
├── The Effect of Valence Framing on Inferring Cause Normalities.pdf # Thesis pdf (soon to be uploaded)
├── *rest # dependencies for building the experiment
└── README.md # This file


---

## 🧩 Experiment

The interactive online version of the experiment can be accessed here:  
👉 [**aidayg24.github.io/causal_selection**](https://aidayg24.github.io/causal_selection)

The experiment was built using **Vue**, and **magpie**,  with data collection conducted via **Prolific**.

---

## 🧮 Data Analysis

All analyses were performed in **R** (version 3.5.0), primarily using the following packages:

- [`brms`](https://paul-buerkner.github.io/brms/) – hierarchical Bayesian logistic regression  
- [`tidyverse`](https://www.tidyverse.org/) – data wrangling and visualization  
- [`ggplot2`](https://ggplot2.tidyverse.org/) – plotting  
- [`bayesplot`](https://mc-stan.org/bayesplot/) – posterior checks and diagnostics  

The core analysis scripts are located in the [`/data collection and data analysis/`](./data collection and data analysis) folder.  
Each model and plot corresponds to the results presented in **Chapter 4** of the thesis.


---

## 💬 Contact

For questions or collaboration inquiries, feel free to contact me via GitHub or email:  
📧 **aidayg24@gmail.com**

