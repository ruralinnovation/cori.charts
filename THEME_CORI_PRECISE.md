# `theme_cori_precise()` — Pixel-Perfect Chart System

## What Changed

Added a new precision theming system to `cori.charts` that eliminates the post-export Figma editing workflow. All charts can now be finalized entirely in R with physically-locked dimensions and typography.

### Old Workflow
1. Create chart in R (with relative font sizes, arbitrary gridline widths)
2. Export PNG
3. Open in Figma and manually adjust:
   - Gridline length
   - Gridline and axis stroke widths (0.25mm, 0.4mm)
   - Axis tick lengths (4pt)
   - Data labels to be left-alignted spaced out correctly
4. Export final PNG from Figma

### New Workflow
1. Create chart in R using `theme_cori_precise()`
2. Call `save_chart()` with preset
3. Export PNG and SVG directly—ready to use

## Why It's Better

**Consistency:** All font sizes, line widths, and dimensions are defined in one place (`cori_chart_spec()`), ensuring every chart in a report uses identical typography and spacing.

**Accessibility:** By basing all sizes on true points (8pt, 9pt, 11pt), we ensure readability across different report formats and print sizes.

**Automation:** No more manual Figma work. Presets ("report" or "slide") automatically select the right canvas size, font sizes, and aspect ratios.

**Version Control:** Chart code is the source of truth. Design decisions are documented and reproducible.

---

## Core Functions

### 1. `cori_chart_spec()`

A named list of constants that controls all physical dimensions.

```r
spec <- cori_chart_spec(
  width_report = 6.5,       # inches
  width_slide = 4.75,       # inches
  dpi = 300,
  aspect_ratio = 0.625,     # report preset; slide preset = 0.65
  font_title = 12,          # points (report); slide = 11
  font_subtitle = 9,
  font_axis = 8,
  font_caption = 8,         # report; slide preset = 6
  font_label = 9,
  font_legend = 9,
  tick_length = 4,          # points
  gridline_width = 0.25,    # mm
  axis_line_width = 0.4     # mm
)
```

**Presets:**
- `"report"` (default): 6.5" wide, font_caption = 8, aspect_ratio = 0.625
- `"slide"`: 4.75" wide, font_caption = 6, aspect_ratio = 0.65

### 2. `theme_cori_precise()`

Applies physically-locked theme overrides to a ggplot object.

```r
fig <- chart_data |>
  ggplot(aes(...)) +
  geom_line(...) +
  theme_cori_precise(type = "line", preset = "report")
```

**Parameters:**
- `type`: `"line"`, `"bar"`, `"scatter"`, `"map"`
- `preset`: `"report"` or `"slide"` (selects font sizes + aspect ratio)
- `spec`: Optional custom spec (overrides preset)

### 3. `set_chart_limits()`

Truncates gridlines at the last data point while allowing labels to extend into the margin.

```r
fig <- fig +
  set_chart_limits(chart_data, x_col = year)
```

**What it does:**
- Sets `xlim = c(NA, max_x)` in `coord_cartesian(clip = "off")`
- Gridlines stop at final data point
- Labels can render in white space to the right

### 4. `label_lines()`

Adds end-of-line labels with automatic overlap prevention.

```r
fig <- fig +
  label_lines(
    data = chart_data,
    x_col = year,
    y_col = value,
    label_col = category,
    color_col = category,
    min_gap = 0.035
  )
```

**Parameters:**
- `min_gap`: Minimum vertical spacing in data units (tune per chart based on value range)
- `x_offset`: Horizontal distance from last data point (default 0.3 in data units)
- `spec`: Pulls font size and family from spec

### 5. `save_chart()`

Exports at precise physical dimensions with both PNG and SVG formats.

```r
save_chart(
  fig,
  "export/path",
  preset = "report",        # controls width + aspect_ratio
  formats = c("png", "svg"),
  add_logo = TRUE
)
```

**Behavior:**
- If `preset = "report"`: 6.5" × 4.06" (with default 0.625 aspect ratio)
- If `preset = "slide"`: 4.75" × 3.09" (with default 0.65 aspect ratio)
- PNG rendered with ragg at declared DPI
- SVG rendered with svglite for accurate text sizing
- Logo composited onto PNG (not SVG)

---

## Line Chart Template

Standard pattern for line charts with direct labeling:

```r
library(coriverse)
library(cori.charts)
library(ggplot2)

load_fonts()

# Prepare data
chart_data <- tibble(
  year = c(2007, 2008, 2009),
  category = c("A", "A", "A"),
  value = c(1.0, 0.95, 1.05)
)

# Create chart
fig <- chart_data |>
  ggplot(aes(x = year, y = value, color = category, group = category)) +
  annotate("rect", xmin = 2007, xmax = 2009, ymin = -Inf, ymax = Inf,
           fill = "grey90", alpha = 0.5) +  # optional recession shading
  geom_hline(yintercept = 1, color = "white", linewidth = 1) +
  geom_hline(yintercept = 1, linewidth = 0.5, linetype = "dashed") +
  geom_line(linewidth = 1) +
  label_lines(
    data = chart_data,
    x_col = year,
    y_col = value,
    label_col = category,
    color_col = category,
    min_gap = 0.035
  ) +
  set_chart_limits(chart_data, x_col = year) +
  scale_color_manual(
    values = c("A" = "#10828A", "B" = "#BA578C")
  ) +
  theme_cori_precise(type = "line", preset = "report") +
  theme(legend.position = "none") +
  labs(
    title = "Chart Title",
    subtitle = "Descriptive subtitle",
    caption = "Source and notes"
  )

save_chart(fig, "export/my_chart", preset = "report")
```

### Key Points

- **No manual spec needed** if using defaults—just specify `preset`
- **Min-gap tuning**: If lines converge closely, increase `min_gap` (e.g., 0.05, 0.08)
- **Margin adjustment**: If labels still clip, override with `theme(plot.margin = margin(...))`
- **Text wrapping**: Use `stringr::str_wrap(label, width = 12)` in data prep if needed

---

## Bar Chart Pattern

```r
fig <- chart_data |>
  ggplot(aes(x = category, y = value, fill = group)) +
  geom_col(position = "stack") +
  geom_text(
    aes(label = scales::percent(value, accuracy = 1)),
    position = position_stack(vjust = 0.5),
    size = 9 / ggplot2::.pt,
    family = "Lato"
  ) +
  scale_fill_manual(values = ...) +
  theme_cori_precise(type = "bar", preset = "report") +
  labs(...)

save_chart(fig, "export/my_chart", preset = "report")
```

---

## Font Size Conversion Notes

**In `element_text()` (theme):**
```r
element_text(size = 11)  # Takes points directly
```

**In `geom_text()` (data labels):**
```r
geom_text(size = 11 / ggplot2::.pt)  # Convert from points to ggplot units
```

This distinction is critical—using `size = 11` in geom_text produces wrong output.

---

## Custom Specs

For reports with unique requirements:

```r
# Smaller fonts for dense multi-chart layouts
compact_spec <- cori_chart_spec(
  font_title = 10,
  font_axis = 7,
  font_caption = 7
)

fig <- chart_data |>
  ggplot(...) +
  theme_cori_precise(type = "line", spec = compact_spec) +
  label_lines(data = chart_data, ..., spec = compact_spec)

save_chart(fig, "export/path", spec = compact_spec)
```

**Important:** Pass the same `spec` to all three functions (`theme_cori_precise`, `label_lines`, `save_chart`) for consistency.

---

## Testing the System

All functions have been tested on real charts across:
- **data-rural-economic-outlook**: Employment and income line charts
- **proj_rwjf_stories**: Tech employment, beeswarm, and stacked bar charts
- **proj_rwjf_seed_of_change**: Multi-sector employment, small multiples

Charts export at correct physical dimensions with no post-processing needed.
