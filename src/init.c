#include "NoC.h"

// C function declarations
extern void revsort(double *a, int *ib, int n);
extern void ReservoirWRS( double *w, int C, int D, double *N_trunc );
extern double minkowski_distance( int* a, int* b, int d, double p );
extern double canberra_distance( int* a, int* b, int d );
extern void C_ABC_Iteration( int *x, int *t, int *x_hat, int *t_hat, double *theta_x, double *theta_l,
                             double *theta_N, int *D, int *C_upper, int *C, int *Tau, int *abundance_hyperprior,
                             double *epsilon, double *distance, double *x_weight, double *t_weight,
                             int *accept, int *dist_met, double *p );

// Define the CallEntries array to map R functions to C functions
static const R_CMethodDef CEntries[] = {
  {"C_ABC_Iteration", (DL_FUNC) &C_ABC_Iteration, 19},
  {NULL, NULL, 0}
};

// Initialize the package with registered routines
void R_init_myPackage(DllInfo *dll) {
  R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
}
