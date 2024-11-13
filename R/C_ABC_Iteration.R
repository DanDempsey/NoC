R_ABC_Iteration <- function( iter, x, t, x_hat, t_hat, theta_x, theta_l, theta_N,
                             D, C_upper, C, Tau, abundance_hyperprior, epsilon, distance,
                             x_weight, t_weight, accept, dist_met, p ) {

  res <- .C( 'C_ABC_Iteration', x, t, x_hat, t_hat, theta_x, theta_l, theta_N, D, C_upper,
             C, Tau, abundance_hyperprior, epsilon, distance, x_weight, t_weight,
             accept, dist_met, p, PACKAGE = 'NoC' )

  if ( res[[17]] == 0 ) { return(NULL) }
  list( C = res[[10]], x = res[[3]], t = res[[4]], distance = res[[14]] )

}
