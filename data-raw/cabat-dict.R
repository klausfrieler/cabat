input <- read.csv("data-raw/cabat-dict.csv", stringsAsFactors = FALSE, fileEncoding = "utf-8")
names(input)[[1]] <- "key"

russian <- readr::read_csv("data-raw/dict-russian.csv")
names(russian)[[1]] <- "key"
stopifnot(!anyDuplicated(input$key),
          all(input$key == russian$key))
input$RU <- russian$RU

spanish <- readr::read_csv("data-raw/dict-spanish.csv")
names(spanish)[[1]] <- "key"
stopifnot(all(input$key == spanish$key))
input$ES <- spanish$ES

dutch <- readr::read_csv("data-raw/dict-dutch.csv")
names(dutch)[[1]] <- "key"
stopifnot(all(input$key == dutch$key))
input$NL <- dutch$NL

italian <- readr::read_csv("data-raw/dict-italian.csv")
names(italian)[[1]] <- "key"
stopifnot(all(input$key == italian$key))
input$IT <- italian$IT

latvian <- readr::read_csv("data-raw/dict-latvian.csv")
names(latvian)[[1]] <- "key"
stopifnot(all(input$key == latvian$key))
input$LV <- latvian$lv

de_f <- readr::read_csv("data-raw/dict-german-formal.csv")
names(de_f)[[1]] <- "key"
stopifnot(all(input$key == de_f$key))
input$DE_F <- de_f$DE_F

cabat_dict <- psychTestR::i18n_dict$new(input)
usethis::use_data(cabat_dict, overwrite = TRUE)
