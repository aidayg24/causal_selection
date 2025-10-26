# ===== Setup =====
library(tidyverse)
library(janitor)
library(ggplot2)
library(brms)
library(tidybayes)

# --- File paths (adjust if needed)
file_disj <- "results_34_Causal_selection_V3_final_disj_AR.csv"
file_conj <- "results_35_Causal_selection_V3_final_conj_AR.csv"

# ===== Helper: map normality per dataset =====
map_normality_disj <- function(df) {
  df %>%
    mutate(
      normality = case_when(
        options == "I drew the violin card.|Bob drew the guitar card." &
          response == "I drew the violin card." ~ "normal",
        options == "I drew the violin card.|Bob drew the guitar card." &
          response == "Bob drew the guitar card." ~ "abnormal",
        
        options == "I drew the office worker card.|Bob drew the beer card." &
          response == "I drew the office worker card." ~ "abnormal",
        options == "I drew the office worker card.|Bob drew the beer card." &
          response == "Bob drew the beer card." ~ "normal",
        
        options == "I drew the math card.|Bob drew the biology card." &
          response == "I drew the math card." ~ "normal",
        options == "I drew the math card.|Bob drew the biology card." &
          response == "Bob drew the biology card." ~ "abnormal",
        
        options == "I drew the party card.|Bob drew the game card." &
          response == "I drew the party card." ~ "abnormal",
        options == "I drew the party card.|Bob drew the game card." &
          response == "Bob drew the game card." ~ "normal",
        TRUE ~ NA_character_
      )
    )
}

map_normality_conj <- function(df) {
  df %>%
    mutate(
      normality = case_when(
        options == "I drew the pill card.|Bob drew the bubble tea card." &
          response == "I drew the pill card." ~ "normal",
        options == "I drew the pill card.|Bob drew the bubble tea card." &
          response == "Bob drew the bubble tea card." ~ "abnormal",
        
        options == "I drew the Spider-Man card.|Bob drew the Joker card." &
          response == "I drew the Spider-Man card." ~ "abnormal",
        options == "I drew the Spider-Man card.|Bob drew the Joker card." &
          response == "Bob drew the Joker card." ~ "normal",
        
        options == "I drew the salad card.|Bob drew the lollipop card." &
          response == "I drew the salad card." ~ "abnormal",
        options == "I drew the salad card.|Bob drew the lollipop card." &
          response == "Bob drew the lollipop card." ~ "normal",
        
        options == "I drew the red pill card.|Bob drew the eat card." &
          response == "I drew the red pill card." ~ "normal",
        options == "I drew the red pill card.|Bob drew the eat card." &
          response == "Bob drew the eat card." ~ "abnormal",
        TRUE ~ NA_character_
      )
    )
}

# ===== Read & harmonize (speaker task rows only) =====
read_and_prepare <- function(path, structure_label, mapper) {
  read_csv(path, show_col_types = FALSE) %>%
    filter(question %in% c("I won because", "I lost because")) %>%
    mutate(
      options  = str_trim(options),
      response = str_trim(response),
      valence  = if_else(question == "I won because", "positive", "negative"),
      structure = structure_label
    ) %>%
    mapper() %>%
    mutate(
      normal_choice   = if_else(normality == "normal", 1L, 0L),
      submission_id   = factor(submission_id),
      valence         = factor(valence,   levels = c("positive", "negative"))
    )
}

disj <- read_and_prepare(file_disj, "disjunctive", map_normality_disj)
conj <- read_and_prepare(file_conj, "conjunctive", map_normality_conj)

dat_all <- bind_rows(disj, conj) %>%
  mutate(structure = factor(structure, levels = c("disjunctive","conjunctive")))

# ===== Bayesian models (per structure, as in your original analysis) =====
fit_bayes <- function(df) {
  brm(
    normal_choice ~ valence + (1 + valence || submission_id),
    data = df,
    family = bernoulli(link = "logit"),
    chains = 4, iter = 4000, warmup = 1000, seed = 1702
  )
}

message("Fitting disjunctive model...")
m_disj <- fit_bayes(filter(dat_all, structure == "disjunctive"))
message("Fitting conjunctive model...")
m_conj <- fit_bayes(filter(dat_all, structure == "conjunctive"))

print(summary(m_disj))
print(summary(m_conj))

# Posterior predictive checks
pp_check(m_disj, ndraws = 100)
pp_check(m_conj, ndraws = 100)

# ===== Posterior summaries & directional probabilities =====
dir_prob <- function(model) {
  grid <- tibble(valence = factor(c("positive","negative"), levels=c("positive","negative")))
  draws <- add_epred_draws(model, newdata = grid, re_formula = NA) %>%
    select(.draw, valence, .epred) %>%
    pivot_wider(names_from = valence, values_from = .epred)
  tibble(
    P_negative_lt_positive = mean(draws$negative < draws$positive, na.rm = TRUE),
    mean_pos = mean(draws$positive), lo_pos = quantile(draws$positive, .025), hi_pos = quantile(draws$positive, .975),
    mean_neg = mean(draws$negative), lo_neg = quantile(draws$negative, .025), hi_neg = quantile(draws$negative, .975)
  )
}

post_disj <- dir_prob(m_disj) %>% mutate(structure = "disjunctive", .before = 1)
post_conj <- dir_prob(m_conj) %>% mutate(structure = "conjunctive", .before = 1)
post_summary <- bind_rows(post_disj, post_conj)
print(post_summary)

# ===== Descriptive summaries for plotting =====
boot_ci <- function(x, R = 1000) {
  means <- replicate(R, mean(sample(x, length(x), replace = TRUE)))
  quantile(means, c(0.025, 0.975))
}

agg_over_valence <- dat_all %>%
  group_by(structure) %>%
  summarise(
    pct_normal = mean(normal_choice, na.rm = TRUE) * 100,
    ci_low = boot_ci(normal_choice * 100)[1],
    ci_high = boot_ci(normal_choice * 100)[2],
    .groups = "drop"
  )

by_valence <- dat_all %>%
  group_by(structure, valence) %>%
  summarise(
    pct_normal = mean(normal_choice, na.rm = TRUE) * 100,
    ci_low = boot_ci(normal_choice * 100)[1],
    ci_high = boot_ci(normal_choice * 100)[2],
    .groups = "drop"
  )

geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.2, linewidth = 0.6)


# ===== Plots (with bootstrapped 95% CIs) =====
fmt_y <- scales::label_percent(accuracy = 1, scale = 1)

# (2) Observed (aggregated over valence)
p2_observed_agg <- ggplot(agg_over_valence, aes(x = structure, y = pct_normal)) +
  geom_col(width = 0.6, fill = "#999999") +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.2, linewidth = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0, 100),
                     expand = expansion(mult = c(0, .1))) +
  labs(
    title = "Observed (aggregated over valence framing)",
    x = "Causal structure",
    y = "Percentage choosing the normal cause"
  ) +
  theme_minimal()

# (3) Positive framing
p3_pos <- by_valence %>%
  filter(valence == "positive") %>%
  ggplot(aes(x = structure, y = pct_normal)) +
  geom_col(width = 0.6, fill = "#0072B2") +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.2, linewidth = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0, 100),
                     expand = expansion(mult = c(0, .1))) +
  labs(
    title = "Positive framing",
    x = "Causal structure",
    y = "Percentage choosing the normal cause"
  ) +
  theme_minimal()

# (4) Negative framing
p4_neg <- by_valence %>%
  filter(valence == "negative") %>%
  ggplot(aes(x = structure, y = pct_normal)) +
  geom_col(width = 0.6, fill = "#E69F00") +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.2, linewidth = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0, 100),
                     expand = expansion(mult = c(0, .1))) +
  labs(
    title = "Negative framing",
    x = "Causal structure",
    y = "Percentage choosing the normal cause"
  ) +
  theme_minimal()

# (Main) Faceted by valence
p_main_facets <- ggplot(by_valence, aes(x = structure, y = pct_normal, fill = valence)) +
  geom_col(width = 0.6) +
  geom_errorbar(aes(ymin = ci_low, ymax = ci_high), width = 0.2, linewidth = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 3.8) +
  facet_wrap(~ valence) +
  scale_fill_manual(values = c("positive" = "#0072B2", "negative" = "#E69F00")) +
  scale_y_continuous(labels = fmt_y, limits = c(0, 100),
                     expand = expansion(mult = c(0, .12))) +
  labs(
    title = "Percentage choosing the normal cause by causal structure",
    subtitle = "Faceted by valence framing (with 95% bootstrapped CIs)",
    x = "Causal structure",
    y = "Percentage choosing the normal cause"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# (1) Expected pattern from prior literature — no CI
expected <- tibble(
  structure  = factor(c("disjunctive", "conjunctive"),
                      levels = c("disjunctive", "conjunctive")),
  pct_normal = c(68, 12)
)

p1_prior <- ggplot(expected, aes(x = structure, y = pct_normal, fill = structure)) +
  geom_col(width = 0.6, color = "black", alpha = 0.85) +
  geom_text(aes(label = paste0(pct_normal, "%")), vjust = -0.6, size = 4.2) +
  scale_fill_manual(values = c("#4C72B0", "#DD8452")) +
  scale_y_continuous(labels = fmt_y, limits = c(0, 100),
                     expand = expansion(mult = c(0, .1))) +
  labs(
    title = "Expected pattern from prior literature (Kirfel & Icard, 2021)",
    subtitle = "Average normal-cause selection rates across Experiments 1–2",
    x = "Causal structure",
    y = "Percentage choosing the normal cause"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# ===== Save Plots =====
ggsave("fig-observed-agg.png",  p2_observed_agg, width = 5.5, height = 4, dpi = 300)
ggsave("fig-positive.png",      p3_pos, width = 5.5, height = 4, dpi = 300)
ggsave("fig-negative.png",      p4_neg, width = 5.5, height = 4, dpi = 300)
ggsave("fig-main-facets.png",   p_main_facets, width = 7, height = 4.5, dpi = 300)
ggsave("fig-expected-prior.png", p1_prior, width = 7, height = 4, dpi = 300)
