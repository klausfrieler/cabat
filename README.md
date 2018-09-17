# Computerised Adaptive Beat Alignment Test (CA-BAT) 

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1415353.svg)](https://doi.org/10.5281/zenodo.1415353)

The CA-BAT is an adaptive test of beat perception ability.
We invite you to try the test [here](http://shiny.pmcharrison.com/cabat-demo), and
to read the paper [here](https://doi.org/10.1038/s41598-018-30318-8).

## Citation

When using the CA-BAT in your own research, you can cite the original CA-BAT research paper:

> Harrison, P. M. C., & Müllensiefen, D. (2018). 
Development and validation of the Computerised Adaptive Beat Alignment Test (CA-BAT). 
Scientific Reports, 8(12395), 1–19. https://doi.org/10.1038/s41598-018-30318-8

and this implementation:

> Harrison, P. M. C., & Müllensiefen, D. (2018). 
Computerised Adaptive Beat Alignment Test (CA-BAT), psychTestR implementation. Zenodo.
https://doi.org/10.5281/zenodo.1415353

We also advise mentioning the software versions you used,
in particular the versions of the `cabat`, `psychTestR`, and `psychTestRCAT` packages.
You can find these version numbers from R by running the following commands:

``` r
library(cabat)
library(psychTestR)
library(psychTestRCAT)
if (!require(devtools)) install.packages("devtools")
x <- devtools::session_info()
x$packages[x$packages$package %in% c("cabat", "psychTestR", "psychTestRCAT"), ]
```

## Installation instructions (local use)

1. If you don't have R installed, install it from here: https://cloud.r-project.org/

2. Open R.

3. Install the ‘devtools’ package with the following command:

`install.packages('devtools')`

4. Install the CA-BAT:

`devtools::install_github('pmcharrison/cabat')`

## Usage

### Quick demo 

You can demo the melodic discrimination test at the R console, as follows:

``` r
# Load the cabat package
library(cabat)

# Run a demo test, with feedback as you progress through the test,
# and not saving your data
demo_cabat()

# Run a demo test, skipping the training phase, and only asking 5 questions
demo_cabat(num_items = 5, take_training = FALSE)
```

### Testing a participant

The `standalone_cabat()` function is designed for real data collection.
In particular, the participant doesn't receive feedback during this version.

``` r
# Load the cabat package
library(cabat)

# Run the test as if for a participant, using default settings,
# saving data, and with a custom admin password
standalone_cabat(admin_password = "put-your-password-here")
```

You will need to enter a participant ID for each participant.
This will be stored along with their results.

Each time you test a new participant,
rerun the `standalone_cabat()` function,
and a new participation session will begin.

You can retrieve your data by starting up a participation session,
entering the admin panel using your admin password,
and downloading your data.
For more details on the psychTestR interface, 
see http://psychtestr.com/.

The CA-BAT currently supports English and German.
You can select one of these languages by passing a language code as 
an argument to `standalone_cabat()`, e.g. `standalone_cabat(languages = "DE")`,
or alternatively by passing it as a URL parameter to the test browser,
eg. http://127.0.0.1:4412/?language=DE (note that the `p_id` argument must be empty).

### Results

CA-BAT scores are given on an [item response theory](https://en.wikipedia.org/wiki/Item_response_theory) metric.
These scores are similar to *z*-scores: 
an average score is about 0, and the typical standard deviation is around 1.
See [Harrison et al. (2018)](https://doi.org/10.1038/s41598-018-30318-8) for more precise benchmarks.

psychTestR provides several ways of retrieving test results (see http://psychtestr.com/).
Most are accessed through the test's admin panel.

* If you are just interested in the participants' final scores,
the easiest solution is usually to download the results in CSV format from the admin panel.
* If you are interested in trial-by-trial results, you can run the command
`compile_trial_by_trial_results()` from the R console
(having loaded the CA-BAT package using `library(cabat)`).
Type `?compile_trial_by_trial_results()` for more details.
* If you want still more detail, you can examine the individual RDS output files using `readRDS()`. 
Detailed results are stored as the 'metadata' attribute for the ability field. 
You can access it something like this: 

``` r
x <- readRDS("output/results/id=1&p_id=german_test&save_id=1&pilot=false&complete=true.rds")
attr(x$BAT$ability, "metadata")
```

## Installation instructions (Shiny Server)

1. Complete the installation instructions described under 'Local use'.
2. If not already installed, install Shiny Server Open Source:
https://www.rstudio.com/products/shiny/download-server/
3. Navigate to the Shiny Server app directory.

`cd /srv/shiny-server`

4. Make a folder to contain your new Shiny app.
The name of this folder will correspond to the URL.

`sudo mkdir cabat`

5. Make a text file in this folder called `app.R`
specifying the R code to run the app.

- To open the text editor: `sudo nano cabat/app.R`
- Write the following in the text file:

``` r
library(cabat)
standalone_cabat(admin_password = "put-your-password-here")
```

- Save the file (CTRL-O).

6. Change the permissions of your app directory so that `psychTestR`
can write its temporary files there.

`sudo chown -R shiny cabat`

where `shiny` is the username for the Shiny process user
(this is the usual default).

7. Navigate to your new shiny app, with a URL that looks like this:
http://my-web-page.org:3838/cabat

## Usage notes

- The CA-BAT runs in your web browser.
- By default, audio files are hosted online on our servers.
The test therefore requires internet connectivity.

## Implementation notes

By default, the CA-BAT implementation always estimates participant abilities
using weighted-likelihood estimation.
This differs from our validation study, 
where online abilities were scored using Bayes modal estimation.
We adopt weighted-likelihood estimation for this release 
because this technique makes fewer assumptions about the participant group being tested.
This makes the test better suited to testing with diverse participant groups
(e.g. children, clinical populations).
