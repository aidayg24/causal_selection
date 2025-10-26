# ===== Setup =====
library(tidyverse)
library(janitor)
library(brms)
library(tidybayes)

# --- File paths
file_disj <- "results_34_Causal_selection_V3_final_disj_AR.csv"
file_conj <- "results_35_Causal_selection_V3_final_conj_AR.csv"

# ===== Helpers =====
clean_str <- function(x) {
  x %>% str_squish() %>% na_if("") %>% na_if("NA") %>% na_if("N/A")
}
norm3 <- function(x) {
  xl <- stringr::str_to_lower(clean_str(x))
  case_when(
    str_detect(xl, "less") | str_detect(xl, "^<\\s*5$") ~ "<5",
    xl %in% c("5","=5","= 5","5.") | str_detect(xl, "^=??\\s*5\\.?$") ~ "5",
    str_detect(xl, "more") | str_detect(xl, "^>\\s*5$") ~ ">5",
    TRUE ~ NA_character_
  )
}
cmp3 <- function(x) {
  xl <- stringr::str_to_lower(clean_str(x))
  case_when(
    str_detect(xl, "^(less|fewer)") ~ "less",
    str_detect(xl, "^more") ~ "more",
    str_detect(xl, "^equal|same number") ~ "equal",
    TRUE ~ NA_character_
  )
}
bin_score <- function(bin) {
  m <- c("<5" = 0L, "5" = 1L, ">5" = 2L)
  unname(m[as.character(bin)])
}
make_question <- function(df, qid, colA, colB, colC = NULL, cause_side = c("A","B")) {
  cause_side <- match.arg(cause_side)
  A_raw <- df[[colA]]; B_raw <- df[[colB]]
  C_raw <- if (!is.null(colC) && colC %in% names(df)) df[[colC]] else NA_character_
  tibble(
    submission_id = factor(df$submission_id),
    gender = df$gender,
    age = df$age,
    question_id = qid,
    ANorm = A_raw,
    BNorm = B_raw,
    compare = C_raw,
    cause_side = cause_side
  ) %>% filter(!is.na(ANorm) | !is.na(BNorm))
}

# ===== Build listener data per structure =====
read_listener_disj <- function(path) {
  dat <- read_csv(path, show_col_types = FALSE, na = c("", "NA", "N/A")) %>%
    mutate(across(where(is.character), clean_str))
  
  q1 <- make_question(dat, "drug",      "ANorm_drug",      "BNorm_drug",      "compare_drug",      cause_side = "B")
  q2 <- make_question(dat, "superhero", "ANorm_superhero", "BNorm_superhero", "compare_superhero", cause_side = "B")
  q3 <- make_question(dat, "matrix",    "ANorm_matrix",    "BNorm_matrix",    "compare_matrix",    cause_side = "A")
  q4 <- make_question(dat, "food",      "ANorm_food",      "BNorm_food",      "compare_food",      cause_side = "A")
  bind_rows(q1,q2,q3,q4) %>%
    mutate(question_id = factor(question_id, levels = c("drug","superhero","matrix","food"))) %>%
    mutate(structure = "disjunctive")
}
read_listener_conj <- function(path) {
  dat <- read_csv(path, show_col_types = FALSE, na = c("", "NA", "N/A")) %>%
    mutate(across(where(is.character), clean_str))
  
  q1 <- make_question(dat, "instrument",   "ANorm_instrument",   "BNorm_instrument",   "compare_instrument",   cause_side = "A")
  q2 <- make_question(dat, "game",         "ANorm_game",         "BNorm_game",         "compare_game",         cause_side = "B")
  q3 <- make_question(dat, "study",        "ANorm_study",        "BNorm_study",        "compare_study",        cause_side = "A")
  q4 <- make_question(dat, "superpower",   "ANorm_superpower",   "BNorm_superpower",   "compare_superpower",   cause_side = "B")
  bind_rows(q1,q2,q3,q4) %>%
    mutate(question_id = factor(question_id, levels = c("instrument","game","study","superpower"))) %>%
    mutate(structure = "conjunctive")
}

disj <- read_listener_disj(file_disj)
conj <- read_listener_conj(file_conj)

listener_long <- bind_rows(disj, conj)

# ----- derive inferred normality (relative rule) -----
listener_long <- listener_long %>%
  mutate(
    ANorm_bin = norm3(ANorm),
    BNorm_bin = norm3(BNorm),
    compare3  = cmp3(compare),
    sA = bin_score(ANorm_bin),
    sB = bin_score(BNorm_bin),
    cause_side_chr = as.character(cause_side),
    s_cause = ifelse(cause_side_chr == "A", sA, sB),
    s_other = ifelse(cause_side_chr == "A", sB, sA),
    bins_equal = s_cause == s_other,
    cause_inferred = case_when(
      is.na(s_cause) | is.na(s_other) ~ NA_character_,
      s_cause > s_other               ~ "normal",
      s_cause < s_other               ~ "abnormal",
      bins_equal & compare3 == "less"  & cause_side_chr == "A" ~ "abnormal",
      bins_equal & compare3 == "less"  & cause_side_chr == "B" ~ "normal",
      bins_equal & compare3 == "more"  & cause_side_chr == "A" ~ "normal",
      bins_equal & compare3 == "more"  & cause_side_chr == "B" ~ "abnormal",
      bins_equal & compare3 == "equal" ~ "equal",
      bins_equal & is.na(compare3)     ~ "equal",
      TRUE                             ~ NA_character_
    ),
    cause_inferred = factor(cause_inferred, levels = c("abnormal","equal","normal")),
    structure = factor(structure, levels = c("disjunctive","conjunctive"))
  )

# ----- attach valence per question id (both sets) -----
val_map <- tribble(
  ~question_id,   ~valence,
  "drug",         "positive",
  "superhero",    "negative",
  "matrix",       "positive",
  "food",         "negative",
  "instrument",   "positive",
  "game",         "negative",
  "superpower",   "positive",
  "study",        "negative"
)

listener_long <- listener_long %>%
  left_join(val_map, by = "question_id") %>%
  mutate(valence = factor(valence, levels = c("positive","negative")))

# ===== Descriptive summaries for the 4-plot layout (percent 'normal') =====
listener_slim <- listener_long %>%
  filter(!is.na(cause_inferred), !is.na(valence)) %>%
  mutate(normal_choice = as.integer(cause_inferred == "normal"))

# (A) aggregated over valence
agg_over_valence <- listener_slim %>%
  group_by(structure) %>%
  summarise(pct_normal = mean(normal_choice) * 100, n = n(), .groups = "drop")

# (B) by valence
by_valence <- listener_slim %>%
  group_by(structure, valence) %>%
  summarise(pct_normal = mean(normal_choice) * 100, n = n(), .groups = "drop")

# ===== Plots (match the speaker style) =====
fmt_y <- scales::label_percent(accuracy = 1, scale = 1)

# expected (use same numbers you used for speaker, from Kirfel & Icard)
expected <- tibble(
  structure  = factor(c("disjunctive","conjunctive"), levels = c("disjunctive","conjunctive")),
  pct_normal = c(68, 12)
)
pL_prior <- ggplot(expected, aes(structure, pct_normal)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0,100), expand = expansion(mult = c(0,.1))) +
  labs(title = "Listener (expected from prior literature)",
       x = "Causal structure", y = "Percentage inferring a normal cause") +
  theme_minimal()

pL_agg <- ggplot(agg_over_valence, aes(structure, pct_normal)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0,100), expand = expansion(mult = c(0,.1))) +
  labs(title = "Listener (aggregated over valence framing)",
       x = "Causal structure", y = "Percentage inferring a normal cause") +
  theme_minimal()

pL_pos <- by_valence %>% filter(valence == "positive") %>%
  ggplot(aes(structure, pct_normal)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0,100), expand = expansion(mult = c(0,.1))) +
  labs(title = "Listener: positive framing",
       x = "Causal structure", y = "Percentage inferring a normal cause") +
  theme_minimal()

pL_neg <- by_valence %>% filter(valence == "negative") %>%
  ggplot(aes(structure, pct_normal)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 4) +
  scale_y_continuous(labels = fmt_y, limits = c(0,100), expand = expansion(mult = c(0,.1))) +
  labs(title = "Listener: negative framing",
       x = "Causal structure", y = "Percentage inferring a normal cause") +
  theme_minimal()

pL_facets <- ggplot(by_valence, aes(structure, pct_normal)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(pct_normal), "%")), vjust = -0.6, size = 3.8) +
  facet_wrap(~ valence) +
  scale_y_continuous(labels = fmt_y, limits = c(0,100), expand = expansion(mult = c(0,.12))) +
  labs(title = "Listener: % inferring a normal cause by structure",
       subtitle = "Faceted by valence framing",
       x = "Causal structure", y = "Percentage inferring a normal cause") +
  theme_minimal()

# save
dir.create("images/listener's plots", showWarnings = FALSE, recursive = TRUE)
ggsave("images/listener's plots/figL-expected-prior.png", pL_prior, width = 5.5, height = 4, dpi = 300)
ggsave("images/listener's plots/figL-observed-agg.png",  pL_agg,   width = 5.5, height = 4, dpi = 300)
ggsave("images/listener's plots/figL-positive.png",      pL_pos,   width = 5.5, height = 4, dpi = 300)
ggsave("images/listener's plots/figL-negative.png",      pL_neg,   width = 5.5, height = 4, dpi = 300)
ggsave("images/listener's plots/figL-main-facets.png",   pL_facets,width = 7,   height = 4.5, dpi = 300)

# ===== Ordinal models per structure (as in your draft) =====
fit_listener <- function(df) {
  df %>%
    filter(!is.na(valence), !is.na(cause_inferred)) %>%
    mutate(
      submission_id = factor(submission_id),
      cause_inferred = factor(cause_inferred, levels = c("abnormal","equal","normal"), ordered = TRUE)
    ) %>%
    brm(
      cause_inferred ~ valence + (1 + valence || submission_id),
      data   = .,
      family = cumulative(link = "logit"),
      prior  = c(
        prior(normal(0, 1.5), class = "Intercept"),
        prior(normal(0, 1.0), class = "b"),
        prior(exponential(1), class = "sd")
      ),
      chains = 4, iter = 4000, warmup = 1000, seed = 1702
    )
}

mL_disj <- fit_listener(filter(listener_long, structure == "disjunctive"))
mL_conj <- fit_listener(filter(listener_long, structure == "conjunctive"))

print(summary(mL_disj))
print(summary(mL_conj))
pp_check(mL_disj, ndraws = 100); pp_check(mL_conj, ndraws = 100)

# ----- directional probability on 'normal' category: P(negative < positive) -----
dir_prob_listener <- function(model) {
  grid <- tibble(valence = factor(c("positive","negative"), levels = c("positive","negative")),
                 submission_id = NA)
  pred <- posterior_epred(model, newdata = grid, re_formula = NA)  # draws x 2 x 3
  p_pos_norm <- pred[,1,3]; p_neg_norm <- pred[,2,3]
  tibble(
    P_negative_lt_positive = mean(p_neg_norm < p_pos_norm),
    mean_pos = mean(p_pos_norm), lo_pos = quantile(p_pos_norm, .025), hi_pos = quantile(p_pos_norm, .975),
    mean_neg = mean(p_neg_norm), lo_neg = quantile(p_neg_norm, .025), hi_neg = quantile(p_neg_norm, .975)
  )
}
postL_disj <- dir_prob_listener(mL_disj) %>% mutate(structure = "disjunctive", .before = 1)
postL_conj <- dir_prob_listener(mL_conj) %>% mutate(structure = "conjunctive", .before = 1)
postL_summary <- bind_rows(postL_disj, postL_conj)
print(postL_summary)
