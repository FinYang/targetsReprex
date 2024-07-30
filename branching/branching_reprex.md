``` r
# Checking if static/dynamic branching rerun when one branch changes
library(targets)
tar_invalidate(everything())

# static branching doesn't rerun when simply new values are added

scr <- here::here("branching/_targets.R")
xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tibble)

list(
  tar_map(
    values = tibble(a = c(1, 2, 3)),
    tar_target(b, a)
  )
)
)",
scr
)
targets::tar_make(script = scr)
#> ▶ dispatched target b_1
#> ● completed target b_1 [0.001 seconds]
#> ▶ dispatched target b_2
#> ● completed target b_2 [0 seconds]
#> ▶ dispatched target b_3
#> ● completed target b_3 [0 seconds]
#> ▶ ended pipeline [0.04 seconds]

xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tibble)

list(
  tar_map(
    values = tibble(a = c(1, 2, 3, 4)),
    tar_target(b, a)
  )
)
)", scr
)
tar_make(script = scr)
#> ✔ skipped target b_1
#> ✔ skipped target b_2
#> ✔ skipped target b_3
#> ▶ dispatched target b_4
#> ● completed target b_4 [0.001 seconds]
#> ▶ ended pipeline [0.038 seconds]

# doesn't rerun as long as the values are the same, doesn't matter the order
xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tibble)

list(
  tar_map(
    values = tibble(a = c( 2, 3, 4, 1)),
    tar_target(b, a)
  )
)
)", scr
)
tar_make(script = scr)
#> ✔ skipped target b_1
#> ✔ skipped target b_2
#> ✔ skipped target b_3
#> ✔ skipped target b_4
#> ✔ skipped pipeline [0.035 seconds]

# also doesn't rerun with
# programmatically generate values
tar_invalidate(everything())
scr <- here::here("branching/_targets.R")
xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tidyr)
list(
  tar_map(
    values = expand_grid(a = c(1, 2, 3),
                         b = c("x", "y")),
    tar_target(c, paste0(a, b))
  )
)
)",
scr
)
targets::tar_make(script = scr)
#> ▶ dispatched target c_3_x
#> ● completed target c_3_x [0.001 seconds]
#> ▶ dispatched target c_3_y
#> ● completed target c_3_y [0 seconds]
#> ▶ dispatched target c_2_x
#> ● completed target c_2_x [0 seconds]
#> ▶ dispatched target c_2_y
#> ● completed target c_2_y [0 seconds]
#> ▶ dispatched target c_1_x
#> ● completed target c_1_x [0 seconds]
#> ▶ dispatched target c_1_y
#> ● completed target c_1_y [0.001 seconds]
#> ▶ ended pipeline [0.055 seconds]

xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tidyr)
list(
  tar_map(
    values = expand_grid(a = c(1, 2, 3),
                         b = c("x", "y", "z")),
    tar_target(c, paste0(a, b))
  )
)
)",
scr
)
targets::tar_make(script = scr)
#> ✔ skipped target c_3_x
#> ✔ skipped target c_3_y
#> ▶ dispatched target c_3_z
#> ● completed target c_3_z [0 seconds]
#> ✔ skipped target c_2_x
#> ✔ skipped target c_2_y
#> ▶ dispatched target c_2_z
#> ● completed target c_2_z [0 seconds]
#> ✔ skipped target c_1_x
#> ✔ skipped target c_1_y
#> ▶ dispatched target c_1_z
#> ● completed target c_1_z [0 seconds]
#> ▶ ended pipeline [0.055 seconds]

xfun::write_utf8(
r"(
library(targets)
library(tarchetypes)
library(tidyr)
list(
  tar_map(
    values = expand_grid(a = c(2, 3, 1),
                         b = c("x", "y", "z")),
    tar_target(c, paste0(a, b))
  )
)
)",
scr
)
targets::tar_make(script = scr)
#> ✔ skipped target c_3_x
#> ✔ skipped target c_3_y
#> ✔ skipped target c_3_z
#> ✔ skipped target c_2_x
#> ✔ skipped target c_2_y
#> ✔ skipped target c_2_z
#> ✔ skipped target c_1_x
#> ✔ skipped target c_1_y
#> ✔ skipped target c_1_z
#> ✔ skipped pipeline [0.044 seconds]

# dynamic branching
# Also doesn't rerun for Dynamic branching
tar_invalidate(everything())
scr <- here::here("branching/_targets.R")
xfun::write_utf8(
  r"(
library(targets)
library(tarchetypes)
library(tidyr)
tar_option_set(iteration = "list")

list(
  tar_target(a, 1:3),
  tar_target(b, a, pattern = map(a))
)
)",
scr
)
targets::tar_make(script = scr)
#> ▶ dispatched target a
#> ● completed target a [0 seconds]
#> ▶ dispatched branch b_8177e8a5b15a9ac5
#> ● completed branch b_8177e8a5b15a9ac5 [0 seconds]
#> ▶ dispatched branch b_526e897722449ab2
#> ● completed branch b_526e897722449ab2 [0 seconds]
#> ▶ dispatched branch b_161eedc50ae03d68
#> ● completed branch b_161eedc50ae03d68 [0.001 seconds]
#> ● completed pattern b
#> ▶ ended pipeline [0.045 seconds]

scr <- here::here("branching/_targets.R")
xfun::write_utf8(
  r"(
library(targets)
library(tarchetypes)
library(tidyr)
tar_option_set(iteration = "list")

list(
  tar_target(a, 1:4),
  tar_target(b, a, pattern = map(a))
)
)",
scr
)
targets::tar_make(script = scr)
#> ▶ dispatched target a
#> ● completed target a [0 seconds]
#> ✔ skipped branch b_8177e8a5b15a9ac5
#> ✔ skipped branch b_526e897722449ab2
#> ✔ skipped branch b_161eedc50ae03d68
#> ▶ dispatched branch b_4459bbe0da37ad41
#> ● completed branch b_4459bbe0da37ad41 [0 seconds]
#> ● completed pattern b
#> ▶ ended pipeline [0.045 seconds]

# does rerun when the upstream value orders are different
scr <- here::here("branching/_targets.R")
xfun::write_utf8(
  r"(
library(targets)
library(tarchetypes)
library(tidyr)
tar_option_set(iteration = "list")

list(
  tar_target(a, c(2, 3, 4 ,1)),
  tar_target(b, a, pattern = map(a))
)
)",
scr
)
targets::tar_make(script = scr)
#> ▶ dispatched target a
#> ● completed target a [0 seconds]
#> ▶ dispatched branch b_b99bf625a8be44bc
#> ● completed branch b_b99bf625a8be44bc [0.001 seconds]
#> ▶ dispatched branch b_f34660153a93feb2
#> ● completed branch b_f34660153a93feb2 [0 seconds]
#> ▶ dispatched branch b_5f8b0f76539303dd
#> ● completed branch b_5f8b0f76539303dd [0 seconds]
#> ▶ dispatched branch b_658826bb78e3174f
#> ● completed branch b_658826bb78e3174f [0 seconds]
#> ● completed pattern b
#> ▶ ended pipeline [0.05 seconds]
```

<sup>Created on 2024-07-30 with [reprex v2.1.1](https://reprex.tidyverse.org)</sup>
