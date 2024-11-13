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

