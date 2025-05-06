library(here)
dime_link <- "https://github.com/rostools/r-cubed-intermediate/raw/refs/heads/main/data/dime.zip"
download.file(dime_link, destfile = here("data-raw/dime.zip"))
# Comment out so it doesn't download again.
# download.file(dime_link, destfile = here("data-raw/dime.zip"))
library(here)
library(here)
library(fs)
# Remove leftover folder so unzipping is always clean
dir_delete(here("data-raw/dime"))
unzip(
  here("data-raw/dime.zip"),
  exdir = here("data-raw/dime/")
)
