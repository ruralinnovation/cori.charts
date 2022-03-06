## code to prepare CORI datasets

library(tidyverse)

cori_education <-
  read_csv("data-raw/time_series_sample_data.csv") %>%
  mutate(date = lubridate::mdy(date)) %>%
  pivot_longer(less_than_high_school:bachelors_or_higher,
    names_to = "education",
    values_to = "percent_working_remotely"
  ) %>%
  mutate(education = forcats::fct_inorder(education))
usethis::use_data(cori_education, overwrite = TRUE)

cori_communities <- read_csv("data-raw/cori_network_communities.csv")
usethis::use_data(cori_communities, overwrite = TRUE)

population_sample <- read_csv("data-raw/population_sample_data.csv") %>%
  mutate(
    geoid = as.character(geoid),
    geoid = str_pad(geoid, width = 11, side = "left", pad = "0"),
    geoid_co = stringr::str_sub(geoid, start = 1, end = 5)
  )

set.seed(1)
cori_employment <-
  cori_communities %>%
  slice_sample(n = 10) %>%
  inner_join(population_sample) %>%
  group_by(rin_community, state_abbr, county, geoid_co) %>%
  summarise(across(
    c(
      estimate_pop_2014, estimate_pop_2019,
      estimate_employed_2014, estimate_employed_2019
    ),
    sum
  ), .groups = "drop")
usethis::use_data(cori_employment, overwrite = TRUE)


set.seed(2)
cori_poverty <-
  cori_communities %>%
  slice_sample(n = 10) %>%
  inner_join(population_sample) %>%
  group_by(rin_community, state_abbr, county, geoid_co) %>%
  summarise(across(
    c(
      estimate_pop_2014, estimate_pop_2019,
      estimate_below_poverty_level_2014, estimate_below_poverty_level_2019
    ),
    sum
  ), .groups = "drop")
usethis::use_data(cori_poverty, overwrite = TRUE)
