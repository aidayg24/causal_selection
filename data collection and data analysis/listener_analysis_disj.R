# =========================
# Listener analysis (refactored)
# =========================
library(tidyverse)
library(janitor)
library(brms)


# 0) Load — actually treat "NA", "N/A", and empty strings as missing on read
dat <- read_csv(
  "results_34_Causal_selection_V3_final_disj_AR.csv",
  show_col_types = FALSE,
  na = c("", "NA", "N/A")
)

# 1) Helpers
clean_str <- function(x) {
  x %>%
    str_squish() %>%
    na_if("") %>%     # harmless now, but fine to keep
    na_if("NA") %>%
    na_if("N/A")
}

# 2) Apply to character columns only (don’t torch types)
dat <- dat %>%
  mutate(across(where(is.character), clean_str))

# Map many variants to bins: "<5" / "5" / ">5"
norm3 <- function(x) {
  xl <- stringr::str_to_lower(clean_str(x))
  case_when(
    stringr::str_detect(xl, "less") | stringr::str_detect(xl, "^<\\s*5$")         ~ "<5",
    xl %in% c("5","=5","= 5","5.") | stringr::str_detect(xl, "^=??\\s*5\\.?$")    ~ "5",
    stringr::str_detect(xl, "more") | stringr::str_detect(xl, "^>\\s*5$")         ~ ">5",
    TRUE                                                                           ~ NA_character_
  )
}

# Compare strings: relation of A vs B
# "less"/"fewer": A < B ; "more": A > B ; "equal"/"same number": A = B
cmp3 <- function(x) {
  xl <- stringr::str_to_lower(clean_str(x))
  case_when(
    stringr::str_detect(xl, "^(less|fewer)")      ~ "less",
    stringr::str_detect(xl, "^more")              ~ "more",
    stringr::str_detect(xl, "^equal|same number") ~ "equal",
    TRUE                                          ~ NA_character_
  )
}

# Safer bin -> score mapper (works with factors too)
bin_score <- function(bin) {
  m <- c("<5" = 0L, "5" = 1L, ">5" = 2L)
  unname(m[as.character(bin)])
}

# Build a question-specific tibble from full 'dat'
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
  ) %>%
    # keep rows that actually belong to this question (at least one side has an answer)
    filter(!is.na(ANorm) | !is.na(BNorm))
}

normality_score <- function(x) {
  dplyr::recode(as.character(x),
    "abnormal" = 0,
    "equal"    = 0.5,
    "normal"   = 1,
    .default   = NA_real_
  )
}

# -------------------------
# 2) Build per-question tables (order matters: do this BEFORE any mutate on listener_long)
# -------------------------
q1 <- make_question(dat, "drug",      "ANorm_drug",      "BNorm_drug",      "compare_drug",      cause_side = "B")
q2 <- make_question(dat, "superhero", "ANorm_superhero", "BNorm_superhero", "compare_superhero", cause_side = "B")
q3 <- make_question(dat, "matrix",    "ANorm_matrix",    "BNorm_matrix",    "compare_matrix",    cause_side = "A")
q4 <- make_question(dat, "food",      "ANorm_food",      "BNorm_food",      "compare_food",      cause_side = "A")

listener_long <- bind_rows(q1, q2, q3, q4)

# -------------------------
# 3) Vectorised inference of cause normality (RELATIVE rule)
#     - only use compare when bins tie
#     - treat 5/5 with missing compare as "equal"
# -------------------------
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
      is.na(s_cause) | is.na(s_other)                            ~ NA_character_,
      s_cause > s_other                                          ~ "normal",
      s_cause < s_other                                          ~ "abnormal",
      bins_equal & compare3 == "less"  & cause_side_chr == "A"   ~ "abnormal", # A < B
      bins_equal & compare3 == "less"  & cause_side_chr == "B"   ~ "normal",
      bins_equal & compare3 == "more"  & cause_side_chr == "A"   ~ "normal",   # A > B
      bins_equal & compare3 == "more"  & cause_side_chr == "B"   ~ "abnormal",
      bins_equal & compare3 == "equal"                           ~ "equal",
      bins_equal & is.na(compare3)                               ~ "equal",    # your requested rule
      TRUE                                                       ~ NA_character_
    ),
    cause_inferred = factor(cause_inferred, levels = c("abnormal","equal","normal")),
    question_id    = factor(question_id, levels = c("drug","superhero","matrix","food"))
  )

# -------------------------
# 4) Attach valence (EDIT here if your mapping differs)
# -------------------------
valence_map <- tribble(
  ~question_id,  ~valence,
  "drug",        "positive",
  "superhero",   "negative",
  "matrix",      "positive",
  "food",        "negative"
)
listener_long <- listener_long %>%
  left_join(valence_map, by = "question_id") %>%
  mutate(valence = factor(valence, levels = c("positive","negative")))

# -------------------------
# 5) Descriptives
# -------------------------
listener_long %>% tabyl(question_id, cause_inferred)

listener_long %>%
  count(question_id, cause_inferred) %>%
  group_by(question_id) %>%
  mutate(percent = round(100*n/sum(n), 1)) %>%
  ungroup()

listener_long %>%
  group_by(valence, cause_inferred) %>%
  summarise(n = n(), .groups = "drop_last") %>%
  mutate(p = n / sum(n)) %>%
  ggplot(aes(valence, p, fill = cause_inferred)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  labs(title="Listener: inferred normality of the CAUSE by valence",
       x="Valence framing", y="% within valence", fill="Inferred normality") +
  theme_minimal()

# -------------------------
# 6) Modeling datasetsl
# -------------------------

listener_ord <- listener_long %>%
  filter(!is.na(valence), !is.na(cause_inferred)) %>%
  mutate(
    submission_id = factor(submission_id),
    cause_inferred = factor(cause_inferred,
                            levels = c("abnormal","equal","normal"),
                            ordered = TRUE)
  )


# (b) Ordinal: abnormal < equal < normal

m_listener_ord <- brm(
  cause_inferred ~ valence + (1 + valence || submission_id),
  data   = listener_ord,
  family = cumulative(link = "logit"),
  prior  = c(
    prior(normal(0, 1.5), class = "Intercept"),   # thresholds
    prior(normal(0, 1.0), class = "b"),
    prior(exponential(1), class = "sd")
  ),
  chains = 4, iter = 4000, warmup = 1000, seed = 1702
)
summary(m_listener_ord)
pp_check(m_listener_ord, ndraws = 100)
loo(m_listener_ord)


# -------------------------
# 8) Neat "effect table" for valence (like speaker)
# -------------------------
# Marginal predicted probabilities by valence (binary model)
grid_val <- tibble(
  valence = factor(c("positive","negative"), levels = c("positive","negative")),
  submission_id = NA   # marginalize random effects
)

# draws x 2(valence) x 3(categories: 1=abnormal, 2=equal, 3=normal)
pred_ord <- posterior_epred(m_listener_ord, newdata = grid_val, re_formula = NA)

# pred_ord: draws x V (valence) x K (categories)
stopifnot(length(dim(pred_ord)) == 3)
V <- dim(pred_ord)[2]   # should be 2 (positive, negative)
K <- dim(pred_ord)[3]   # should be 3 (abnormal, equal, normal)

valence_levels <- c("positive","negative")[seq_len(V)]
cat_levels     <- c("abnormal","equal","normal")[seq_len(K)]

# Build a summary cube with explicit dimnames to avoid name-matching issues
stats <- c("mean","l95","u95")
summ_cube <- array(NA_real_,
                   dim = c(length(stats), V, K),
                   dimnames = list(stats, valence_levels, cat_levels))

for (j in seq_len(V)) {
  for (k in seq_len(K)) {
    v <- pred_ord[, j, k]
    summ_cube["mean", j, k] <- mean(v)
    summ_cube["l95",  j, k] <- unname(quantile(v, 0.025))
    summ_cube["u95",  j, k] <- unname(quantile(v, 0.975))
  }
}

# Tidy table for the thesis
prob_tab <- tibble::tibble(
  valence  = rep(valence_levels, each = K),
  category = rep(cat_levels,     times = V),
  mean     = as.vector(summ_cube["mean", , ]),
  l95      = as.vector(summ_cube["l95",  , ]),
  u95      = as.vector(summ_cube["u95",  , ])
)

prob_tab

# Directional "hypothesis table" on the NORMAL category (negative < positive)
p_pos_norm <- pred_ord[, 1, 3]  # positive valence, category=normal
p_neg_norm <- pred_ord[, 2, 3]  # negative valence, category=normal

hypo_tab <- tibble(
  hypothesis  = c("negative < positive", "positive < negative"),
  probability = c(mean(p_neg_norm < p_pos_norm), mean(p_pos_norm < p_neg_norm))
)

hypo_tab


