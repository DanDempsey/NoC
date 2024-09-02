#' Estimate Number of Classes via ABC
#'
#' Fits a generative model for class discovery via ABC to approximate a posterior for the total number of classes.
#'
#' @param iters The number of iterations for the ABC algorithm.
#' @param x Numeric vector corresponding the effort proxy.
#' @param t Numeric vector corresponding the discovery times. Must be the same length as x.
#' @param theta_N A numeric vector of length two if abundance_hyperprior = FALSE and length three otherwise. The first component always corresponds to the mean of the species abundance prior. If abundance_hyperpior = FALSE, the second component is the variance; if abundance_hyperprior = TRUE, then the second and third components correspond to the bounds of the uniform hyperprior for the abundance variance.
#' @param theta_x A single numeric. Corresponds to the log difference in the mean of the effort proxy and the latent effort process.
#' @param theta_l A numeric vector of length 2. The first component is the starting position of the latent effort process, and the second component is the variance parameter of the IGMRF that the latent effort is assumed to follow.
#' @param m A single numeric. Multiple of the upper boundary of the prior for C.
#' @param metric Either "minkowski" or "canberra", corresponding to the distance metric. Partial matching is supported.
#' @param p The order of the minkowski distance. p = 1 corresponds to the Manhattan distance, 2 corresponds to the Euclidean distance. Unused if metric = "canberra".
#' @param epsilon The distance threshold for acceptance. If set to a negative number, then treated as infinity.
#' @param x_weight The weight applied to the distance component corresponding to the effort proxy.
#' @param t_weight The weight applied to the distance component corresponding to the discovery times.
#' @param abundance_hyperprior A logical that indicates if the user wants to use a uniform hyperprior for the abundance prior variance parameter.
#' @param cores This function supports parallelisation. This parameter sets the number of cores the number wants to utilise.
#' @return A list containing the approximate posterior draws for the number of classes (denoted 'C'), the value of the corresponding distance metric, and the corresponding simulations of the effort proxy and discovery times.
#' @details This function fits a generative model of class discovery via Approximate Bayesian Computation (ABC), for the purpose of estimating the total number of classes that exist overall. For example, the number of species of a type of animal. The model requires data inputs x (a numeric proxy of the amount of effort per year) and t (the number of discoveries per year). It also requires prior specification on the abundance of each species (assumed lognormally distributed), the latent effort process (assumed to be an intrinsic Gaussian random process) and mean difference between the observed effort proxy and the latent effort process on the log scale. The ABC algorithm simulates x and t every iteration and measures the distance between these simulations and the observed value of x and t. If the distance is within a given threshold, that iteration (and accompyaning value of the total number of classes) is accecpted as a draw from a distribution that approximates the posterior distribution of the number of classes.
#' @examples
#' data( Aves )
#' set.seed( 100 )
#' pilot_run <- CD_ABC( 1e3, x = Aves$Effort_Proxy, t = Aves$Discovery_Times,
#'                      theta_N = c(log(1e9), 1.1), theta_x = log(2),
#'                      theta_l = c(log(30), 0.08), m = 20 )
#'
#' thresh <- quantile( pilot_run$distance, 0.1 )
#'
#' actual_run <- CD_ABC( 1e4, x = Aves$Effort_Proxy, t = Aves$Discovery_Times,
#'                       theta_N = c(log(1e9), 1.1), theta_x = log(2),
#'                       theta_l = c(log(30), 0.08), m = 20, epsilon = thresh )
#'
#' plot( density(actual_run$C), type = 'l' )
#' @import parallel
#' @import magrittr
#' @export

### Wrapper for the ABC algorithm
CD_ABC <- function( iters, x, t, theta_N, theta_x, theta_l, m = 10, metric = 'minkowski',
                    p = 2, epsilon = -1, x_weight = 1, t_weight = 1,
                    abundance_hyperprior = FALSE, cores = 1 ) {

  # Error handling
  dist_met <- pmatch( metric, c('minkowski', 'canberra') )
  if ( is.na(metric) ) {
    stop( "metric must be one of: 'minkowski' or 'canberra'." )
  }

  if ( length(x) != length(t) ) {
    stop( "x and t must be the same length." )
  }

  if ( abundance_hyperprior & (length(theta_N) < 3) ) {
    stop( "theta_N must have a length of 3 when abundance_hyperprior is TRUE.")
  }

  # Initialisation
  Tau <- length( x )
  D <- sum( t )
  C_upper <- m * D

  # Set distance threshold
  if ( abs(epsilon) == Inf ) {
    epsilon <- -1
  }

  # Main run
  if ( cores > 1 ) {
    cl <- makeCluster( cores )
    #full_run <- mclapply( 1:iters, R_ABC_Iteration, x = as.integer(x),
    #                      t = as.integer(t), x_hat = as.integer(rep(0, Tau)),
    #                      t_hat = as.integer(rep(0, Tau)),
    #                      theta_N = as.double(theta_N), theta_x = as.double(theta_x),
    #                      theta_l = as.double(theta_l), C_upper = as.integer(C_upper),
    #                      C = as.integer(0), D = as.integer(D), Tau = as.integer(Tau),
    #                      abundance_hyperprior = as.integer(abundance_hyperprior),
    #                      epsilon = as.double(epsilon), distance = as.double(0),
    #                      x_weight = as.double(x_weight), t_weight = as.double(t_weight),
    #                      accept = as.integer(0), dist_met = as.integer(dist_met),
    #                      p = as.double(p), mc.cores = cores )
    full_run <- parLapply( cl, X = 1:iters, fun = R_ABC_Iteration,
                           x = as.integer(x), t = as.integer(t), x_hat = as.integer(rep(0, Tau)),
                           t_hat = as.integer(rep(0, Tau)), theta_N = as.double(theta_N),
                           theta_x = as.double(theta_x), theta_l = as.double(theta_l),
                           C_upper = as.integer(C_upper), C = as.integer(0), D = as.integer(D),
                           Tau = as.integer(Tau), abundance_hyperprior = as.integer(abundance_hyperprior),
                           epsilon = as.double(epsilon), distance = as.double(0),
                           x_weight = as.double(x_weight), t_weight = as.double(t_weight),
                           accept = as.integer(0), dist_met = as.integer(dist_met),
                           p = as.double(p) )
    stopCluster( cl )
  }
  else {
    full_run <- lapply( X = 1:iters, FUN = R_ABC_Iteration,
                        x = as.integer(x), t = as.integer(t), x_hat = as.integer(rep(0, Tau)),
                        t_hat = as.integer(rep(0, Tau)), theta_N = as.double(theta_N),
                        theta_x = as.double(theta_x), theta_l = as.double(theta_l),
                        C_upper = as.integer(C_upper), C = as.integer(0), D = as.integer(D),
                        Tau = as.integer(Tau), abundance_hyperprior = as.integer(abundance_hyperprior),
                        epsilon = as.double(epsilon), distance = as.double(0),
                        x_weight = as.double(x_weight), t_weight = as.double(t_weight),
                        accept = as.integer(0), dist_met = as.integer(dist_met),
                        p = as.double(p) )
  }

  keep_inds <- !sapply( full_run, is.null )
  accept_run <- full_run[ keep_inds ]

  # Return accepted results
  list( C = sapply( accept_run, '[[', 'C' ),
        distance = sapply( accept_run, '[[', 'distance' ),
        x_hat = lapply( accept_run, '[[', 'x' ) %>% do.call( what = 'rbind' ),
        t_hat = lapply( accept_run, '[[', 't' ) %>% do.call( what = 'rbind' ) )

}

