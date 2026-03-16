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

```text
.
├── data collection and data analysis/    # Raw and cleaned data from the experiment and R programs for analysis
├── src/                                  # Experiment code and resources
├── public/images                         # Images used in the experiment
├── The Effect of Valence Framing on Inferring Cause Normalities.pdf   # Thesis PDF (soon to be uploaded)
├── *rest                                 # Dependencies for building the experiment
└── README.md                             # This file

```

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

The core analysis scripts are located in the [/data collection and data analysis/](./data%20collection%20and%20data%20analysis) folder.

Each model and plot corresponds to the results presented in **Chapter 4** of the thesis.


---
## License

The code in this repository is licensed under the MIT License.

The thesis document (`Effect of valence framing on inferring cause normalities.pdf`) is licensed under
Creative Commons Attribution 4.0 International (CC BY 4.0),
unless stated otherwise.

---

## 💬 Contact

For questions or collaboration inquiries, feel free to contact me via GitHub or email:  
📧 **aidayg24@gmail.com**

