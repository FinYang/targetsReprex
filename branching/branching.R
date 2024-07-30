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

