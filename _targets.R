# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(crew)
library(crew.cluster)
library(tarchetypes)
library(dplyr)
# library(tarchetypes) # Load other packages as needed.

crew_default <-
  crew::crew_controller_local(
    name = "controller_default",
    workers = 2L

  )

tar_config_set(
  store = "/ddn/gs1/group/set/Projects/storage_test_0715/"
)

# Set target options:
tar_option_set(
  packages = c("tibble","dplyr"), # Packages that your targets need for their tasks.
  # format = "qs", # Optionally set the default storage format. qs is fast.
  #
  repository = "local",
  controller = crew_controller_group(crew_default),
  resources =  tar_resources(
    crew = tar_resources_crew(
      controller = "controller_default"
    )),
  # Pipelines that take a long time to run may benefit from
  # optional distributed computing. To use this capability
  # in tar_make(), supply a {crew} controller
  # as discussed at https://books.ropensci.org/targets/crew.html.
  # Choose a controller that suits your needs. For example, the following
  # sets a controller that scales up to a maximum of two workers
  # which run as local R processes. Each worker launches when there is work
  # to do and exits if 60 seconds pass with no tasks to run.
  #
  #   controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
  #
  # Alternatively, if you want workers to run on a high-performance computing
  # cluster, select a controller from the {crew.cluster} package.
  # For the cloud, see plugin packages like {crew.aws.batch}.
  # The following example is a controller for Sun Grid Engine (SGE).
  # 
  #   controller = crew.cluster::crew_controller_sge(
  #     # Number of workers that the pipeline can scale up to:
  #     workers = 10,
  #     # It is recommended to set an idle time so workers can shut themselves
  #     # down if they are not running tasks.
  #     seconds_idle = 120,
  #     # Many clusters install R as an environment module, and you can load it
  #     # with the script_lines argument. To select a specific verison of R,
  #     # you may need to include a version string, e.g. "module load R/4.3.2".
  #     # Check with your system administrator if you are unsure.
  #     script_lines = "module load R"
  #   )
  #
  # Set other options as needed.
)

# Run the R scripts in the R/ folder with your custom functions:
#tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_target(
    name = data,
    command = tibble(x = rnorm(100), y = rnorm(100))
    # format = "qs" # Efficient storage for general data objects.
  ),
  tar_target(
    name = data2,
    command = mutate(data,
    x2 = x^2,
    x3 = x^3,
    x4 = x^4)
  ),
  tar_target(
    name = model,
    command = coefficients(lm(y ~ x, data = data))
  ),
  tar_target(
    name = model2,
    command = lm( y ~ x + x2, data = data2)
  ),
  tar_target(
    name = model3,
    command = lm( y ~ x + x2 + x3, data = data2)
  ),
  tar_target(
    name = mdl3_sum,
    command = summary(model3)
  ),
    tar_target(
    name = model4,
    command = lm( y ~ x + x2 + x3 + x4, data = data2)
  )
)
