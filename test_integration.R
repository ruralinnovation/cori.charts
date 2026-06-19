library(cori.charts)
library(coriverse)
library(ggplot2)
library(tidyverse)
library(scales)

load_fonts()

test_data <- tibble(
  year = rep(2015:2023, 2),
  category = rep(c("Rural", "Non-Rural"), each = 9),
  employment_index = c(
    100, 98, 97, 99, 101, 103, 105, 104, 106,
    100, 102, 104, 106, 108, 110, 112, 111, 113
  )
) %>%
  mutate(employment_pct = employment_index / 100)

fig <- test_data %>%
  ggplot(aes(x = year, y = employment_pct, color = category, group = category)) +
  geom_hline(yintercept = 1, color = "white", linewidth = 1) +
  geom_hline(yintercept = 1, linewidth = 0.5, linetype = "dashed", color = "#8e8e8e") +
  geom_line(linewidth = 1.2) +
  label_lines(
    data = test_data,
    x_col = year,
    y_col = employment_pct,
    label_col = category,
    color_col = category,
    min_gap = 0.02
  ) +
  set_chart_limits(test_data, x_col = year) +
  scale_y_continuous(
    limits = c(.9, 1.2),
    labels = scales::label_percent(accuracy = 1)
  ) + 
  # scale_x_continuous(
  #   expand = expansion(.01, 1)
  # ) +
  scale_color_manual(
    values = c("Rural" = "#00835D", "Non-Rural" = "#211448")
  ) +
  theme_cori_line() +
  theme(
    legend.position = "none",
    plot.margin = margin(13, 60, 13, 13, "pt")
    ) +
  labs(
    title = "Employment Index: Rural vs. Non-Rural",
    subtitle = "Indexed to 2015 = 100",
    caption = "Source: Test data for integration verification",
    x = NULL,
    y = NULL
  )

print(fig)

# Test exports
save_plot(fig, "test_report.png", preset = "report", add_logo = TRUE)
save_plot(fig, "test_slide.png", preset = "slide", add_logo = TRUE)
save_plot(fig, "test_old_style.png", chart_width = 9, chart_height = 6, add_logo = TRUE)
