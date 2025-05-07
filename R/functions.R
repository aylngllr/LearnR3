#' Import data from the DIME dataset
#'
#' @param file_path Path to CSV file
#'
#' @returns A data frame
#'
import_dime <- function(file_path) {
  data <- file_path %>%
    readr::read_csv(
      show_col_types = FALSE,
      name_repair = snakecase::to_snake_case,
      n_max = 100
    )

  return(data)
}

#' Import all DIME CSV files in a folder into one data frame.
#'
#' @param folder_path The path to the folder that has the CSV files.
#'
#' @return A single data frame/tibble.
#'
import_csv_files <- function(folder_path) {
  files <- folder_path |>
    fs::dir_ls(glob = "*.csv")

  data <- files |>
    purrr::map(import_dime) |>
    purrr::list_rbind(names_to = "file_path_id")
  return(data)
}

#' Participant ID from the file path
#'
#' @param Data with file_path_id
#'
#' @returns A data
#'
get_participant_id <- function(data) {
  data_with_id <- data |>
    dplyr::mutate(
      id = stringr::str_extract(
        file_path_id,
        "[:digit:]+\\.csv$"
      ) |>
        stringr::str_remove("\\.csv$") |>
        as.integer(),
      .before = file_path_id
    ) |>
    dplyr::select(-file_path_id)
  return(data_with_id)
}

#' Renaming the date in Sleep file
#'
#' @param data data
#' @param column column
#'
#' @returns a data
#'
prepare_dates <- function(data, column) {
  prepared_dates <- data |>
    mutate(
      date = as_date({{ column }}),
      hour = hour({{ column }}),
      .before = {{ column }}
    )
  return(prepared_dates)
}



#' Clean and prepare the CGM data
#'
#' @param data the cgm dataset
#'
#' @returns a cleaner data
#'
clean_cgm <- function(data) {
  cleaned <- data |>
    get_participant_id() |>
    prepare_dates(device_timestamp) |>
    dplyr::rename(glucose = historic_glucose_mmol_l)
  return(cleaned)
}
