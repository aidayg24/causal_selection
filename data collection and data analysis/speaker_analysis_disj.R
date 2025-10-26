# Load packages
library(tidyverse)  # for data cleaning & plotting
library(janitor)    # for nice tabulations
library(ggplot2)

# Read your CSV file (adjust the path if needed)
dat <- read_csv("results_34_Causal_selection_V3_final_disj_AR.csv")

# Quick look at the data
#glimpse(dat)
#summary(dat)

library(tidyverse)

#  Step 1. Keep only one row per participant
participants <- dat %>%
  distinct(submission_id, gender, age, .keep_all = FALSE)

participants %>%
  count(gender)

# # 📊 Step 3. Age summary overall
participants %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    sd_age   = sd(age, na.rm = TRUE),
    n_participants = n()
  )


participants %>%
  group_by(gender) %>%
  summarise(
    mean_age = mean(age, na.rm = TRUE),
    sd_age   = sd(age, na.rm = TRUE),
    n = n()
  )
#=========================================================================

library(tidyverse)

dat <- read_csv("results_34_Causal_selection_V3_final_disj_AR.csv")


speaker_dat <- dat %>%
  filter(question %in% c("I won because", "I lost because")) %>%
  mutate(
    # normalize whitespace just in case
    options  = str_trim(options),
    response = str_trim(response)
  )

participants_speaker <- speaker_dat %>%
  distinct(submission_id, gender, age, .keep_all = FALSE)

# Demographics (unique people)
participants_speaker %>% count(gender)

participants_speaker %>%
  summarise(
    n_participants = n(),
    mean_age = mean(age, na.rm = TRUE),
    sd_age   = sd(age, na.rm = TRUE)
  )

speaker_dat <- speaker_dat %>%
  mutate(
    # valence from question text
    valence = if_else(question == "I won because", "positive", "negative"),
    
    # agent from chosen sentence
    agent = case_when(
      str_detect(response, "^I")   ~ "Alice",
      str_detect(response, "^Bob") ~ "Bob",
      TRUE ~ NA_character_
    ),
    
    # normality of the chosen cause, based on *this* option pair + chosen sentence
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

speaker_dat %>%
  count(options, response, valence, agent, normality)

normal_by_valence <- speaker_dat %>%
  group_by(valence, normality) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(percent = 100 * n / sum(n)) %>%
  ungroup()

normal_by_valence

alice_by_valence_normality <- speaker_dat %>%
  group_by(valence, agent, normality) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(percent = 100 * n / sum(n)) %>%
  ungroup()

alice_by_valence_normality

normal_by_valence %>%
  ggplot(aes(x = valence, y = percent, fill = normality)) +
  geom_col(position = "dodge") +
  labs(
    title = "Normal vs Abnormal choices by valence framing",
    x = "Valence framing",
    y = "% of responses",
    fill = "Chosen event"
  ) +
  theme_minimal()

alice_by_valence_normality %>%
  ggplot(aes(x = valence, y = percent, color = normality, group = interaction(normality, agent))) +
  geom_point(aes(shape = agent), size = 3) +
  geom_line(aes(linetype = agent)) +
  labs(
    title = "Blaming Alice/Bob by valence and event normality",
    x = "Valence framing",
    y = "% of responses",
    color = "Chosen event",
    shape = "Agent",
    linetype = "Agent"
  ) +
  theme_minimal()

#================================================================================

speaker_dat <- speaker_dat %>%
  mutate(
    normal_choice = if_else(normality == "normal", 1, 0),
    valence = factor(valence, levels = c("positive", "negative")),
    agent   = factor(agent, levels = c("Alice", "Bob"))
  )

speaker_dat <- speaker_dat %>%
  mutate(
    valence = factor(valence, levels = c("positive","negative")),
    gender  = factor(gender),               # pick your ref level with relevel()
    submission_id = factor(submission_id)
  )


# install.packages("brms")   # only once
library(brms)

m_bayes <- brm(
  formula = normal_choice ~ valence + (1 + valence || submission_id),
  data    = speaker_dat,
  family  = bernoulli(link = "logit"),
  # prior = c(
  #   prior(normal(0, 1.5), class = "Intercept"),   # logit scale, weakly inf.
  #   prior(normal(0, 1),   class = "b"),           # for valence effect
  #   prior(exponential(1), class = "sd")           # shrinks RE sd away from huge funnels
  # ),
  chains  = 4, iter = 4000, warmup = 1000,
  seed    = 1702,
  cores   = parallel::detectCores() - 1
)

# m_bayes <- brm(
#   normal_choice ~ valence * gender + (1 + valence || submission_id),
#   data = speaker_dat,
#   family = bernoulli(link = "logit"),
#   prior = c(
#     prior(normal(0, 1.5), class = "Intercept"),
#     prior(normal(0, 1),   class = "b"),
#     prior(exponential(1), class = "sd")
#   ),
#   chains = 4, iter = 4000, warmup = 1000, seed = 1702
# )


summary(m_bayes)

pp_check(m_bayes, ndraws=100)

# grid <- expand_grid(valence = factor(c("positive","negative"),
#                                      levels=c("positive","negative")))
# fitted(m_bayes, newdata=grid, re_formula=NA, scale="response")



library(tidyverse)
library(tidybayes)

# grid <- expand_grid(
#   valence = factor(c("positive","negative"), levels = c("positive","negative")),
#   agent   = factor(c("Alice","Bob"),         levels = c("Alice","Bob"))
# ) %>%
#   mutate(cond = paste(valence, agent, sep = "-"),
#          cond = as.character(cond))           # ensure character, not factor


# grid <- expand_grid(
#   valence = levels(speaker_dat$valence),
#   gender  = levels(speaker_dat$gender)
# ) %>%
#   mutate(
#     cond = paste(valence, gender, sep = "-"),
#     cond = as.character(cond)          # ensure character, not factor
# )

grid <- expand_grid(
  valence = levels(speaker_dat$valence)
) %>%
  mutate(
    cond = valence,
    cond = as.character(cond)          # ensure character, not factor
)


draws <- m_bayes %>%
  add_epred_draws(newdata = grid, re_formula = NA, ndraws = NULL) %>%
  ungroup() %>%                               # kill accidental grouping
  transmute(.draw, cond, .epred = as.numeric(.epred))  # force numeric

wide <- draws %>%
  pivot_wider(names_from = cond, values_from = .epred) %>%
  arrange(.draw) %>%
  mutate(across(-.draw, as.numeric))          # belt-and-suspenders

conds <- setdiff(names(wide), ".draw")
pairs_tbl <- expand_grid(left = conds, right = conds) %>% filter(left != right)

prob_pairs <- pairs_tbl %>%
  rowwise() %>%
  mutate(probability = mean(wide[[left]] < wide[[right]], na.rm = TRUE)) %>%
  ungroup() %>%
  mutate(hypothesis = paste(left, "<", right)) %>%
  select(hypothesis, probability) %>%
  arrange(desc(probability))





# compare_groups(
# model = m_bayes,
# lower = list(valence = "positive", agent = "Alice"),
# higher = list(valence = "negative", agent = "Alice")
# )


# grid <- tidyr::expand_grid(
#   valence = factor(c("positive","negative"), levels = c("positive","negative"))
# )

# pred_mat <- fitted(
#   m_valence,
#   newdata    = grid,
#   re_formula = NA,
#   scale      = "response",  # convert from log-odds to probabilities
#   summary    = TRUE
# )

# posterior_summary <- bind_cols(
#   grid,
#   as.data.frame(pred_mat) |>
#     rename(
#       mean_prob = Estimate,
#       lower95   = Q2.5,
#       upper95   = Q97.5
#     )
# )

# posterior_summary

# library(ggplot2)

# ggplot(posterior_summary, aes(x = valence, y = mean_prob, fill = valence)) +
#   geom_col(width = 0.6, color = "black", alpha = 0.8) +
#   geom_errorbar(aes(ymin = lower95, ymax = upper95), width = 0.1) +
#   labs(
#     title = "Effect of valence framing on choosing the normal cause",
#     x = "Valence framing",
#     y = "Predicted probability of choosing a normal cause (95% CrI)"
#   ) +
#   theme_minimal() +
#   theme(legend.position = "none")

# #If the bar for negative is clearly lower than positive, it visually confirms the Bayesian estimate: negative framing reduces the chance of choosing the normal cause.

# pred_draws <- fitted(
#   m_valence,
#   newdata    = grid,
#   re_formula = NA,
#   scale      = "response",
#   summary    = FALSE
# )

# diff_prob <- pred_draws[,1] - pred_draws[,2]   # positive - negative
# mean(diff_prob)                                # mean difference in probability
# quantile(diff_prob, c(.025, .975))             # 95% CrI
# mean(diff_prob > 0)                            # P(positive > negative)

