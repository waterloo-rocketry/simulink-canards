#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <complex.h>
#include <string.h>

#define STATE_SIZE 13
#define MEASUREMENT_SIZE 7

typedef struct {
    double x[STATE_SIZE];
    double P[STATE_SIZE][STATE_SIZE];
    double u[4];
    double y[MEASUREMENT_SIZE];
    double Q[STATE_SIZE][STATE_SIZE];
    double R[MEASUREMENT_SIZE][MEASUREMENT_SIZE];
    double T;
    double step;
} EKFParams;

void model_f(double t, const double x[STATE_SIZE], const double u[4], double x_dot[STATE_SIZE]);
void model_h(double t, const double x[STATE_SIZE], const double u[4], double z[MEASUREMENT_SIZE]);
void jacobian(void (*f)(double, const double*, const double*, double*), double t, const double x[STATE_SIZE], const double u[4], double h, double J[STATE_SIZE][STATE_SIZE]);

void ekf_algorithm(EKFParams *params, double x_new[STATE_SIZE], double P_new[STATE_SIZE][STATE_SIZE]) {
    double x[STATE_SIZE], P[STATE_SIZE][STATE_SIZE], u[4], y[MEASUREMENT_SIZE];
    double Q[STATE_SIZE][STATE_SIZE], R[MEASUREMENT_SIZE][MEASUREMENT_SIZE];
    double T, step;

    // Copy parameters
    memcpy(x, params->x, STATE_SIZE * sizeof(double));
    memcpy(P, params->P, STATE_SIZE * STATE_SIZE * sizeof(double));
    memcpy(Q, params->Q, STATE_SIZE * STATE_SIZE * sizeof(double));
    memcpy(R, params->R, MEASUREMENT_SIZE * MEASUREMENT_SIZE * sizeof(double));
    memcpy(u, params->u, 4 * sizeof(double));
    memcpy(y, params->y, MEASUREMENT_SIZE * sizeof(double));
    T = params->T;
    step = params->step;

    // Prediction step
    double x_dot[STATE_SIZE], x_temp[STATE_SIZE];
    memcpy(x_temp, x, STATE_SIZE * sizeof(double));

    // Use a simple Euler method for ODE solving (replace with RK45 for higher accuracy)
    for (double t = 0; t < T; t += step) {
        model_f(t, x_temp, u, x_dot);
        for (int i = 0; i < STATE_SIZE; i++) {
            x_temp[i] += step * x_dot[i];
        }
    }
    memcpy(x_new, x_temp, STATE_SIZE * sizeof(double));

    // Compute Jacobians
    double F1[STATE_SIZE][STATE_SIZE], F2[STATE_SIZE][STATE_SIZE];
    jacobian(model_f, 0, x, u, 1e-6, F1);
    jacobian(model_f, T, x_new, u, 1e-6, F2);

    // Solve for P
    double P_dot[STATE_SIZE][STATE_SIZE], P2[STATE_SIZE][STATE_SIZE];
    for (int i = 0; i < STATE_SIZE; i++) {
        for (int j = 0; j < STATE_SIZE; j++) {
            P_dot[i][j] = 0;
            for (int k = 0; k < STATE_SIZE; k++) {
              P_dot[i][j] += F1[i][k] * P[k][j] + P[i][k] * F1[k][j];
            }
         P_dot[i][j] += Q[i][j];
         P2[i][j] = P[i][j] + T * P_dot[i][j];
        }
    }

for (int i = 0; i < STATE_SIZE; i++) {
    for (int j = 0; j < STATE_SIZE; j++) {
        P_new[i][j] = P[i][j] + T / 2 * (P_dot[i][j] + (F2[i][j] * P2[j][i] + P2[i][j] * F2[j][i] + Q[i][j]));
    }
}
    // Correction step
    double z[MEASUREMENT_SIZE], innovation[MEASUREMENT_SIZE], H[MEASUREMENT_SIZE][STATE_SIZE], S[MEASUREMENT_SIZE][MEASUREMENT_SIZE], K[STATE_SIZE][MEASUREMENT_SIZE];

    model_h(0, x_new, u, z);
    for (int i = 0; i < MEASUREMENT_SIZE; i++) {
        innovation[i] = y[i] - z[i];
    }

    jacobian(model_h, 0, x_new, u, 1e-6, H);

    // Compute S and K
    for (int i = 0; i < MEASUREMENT_SIZE; i++) {
        for (int j = 0; j < MEASUREMENT_SIZE; j++) {
            S[i][j] = 0;
            for (int k = 0; k < STATE_SIZE; k++) {
                S[i][j] += H[i][k] * P_new[k][j];
            }
            S[i][j] += R[i][j];
        }
    }

    // Compute S_inv and K
    // (Placeholder for matrix inversion)
    // In a practical implementation, use a library function for matrix inversion
    double S_inv[MEASUREMENT_SIZE][MEASUREMENT_SIZE];
    // Invert S to get S_inv

    for (int i = 0; i < STATE_SIZE; i++) {
        for (int j = 0; j < MEASUREMENT_SIZE; j++) {
            K[i][j] = 0;
            for (int k = 0; k < STATE_SIZE; k++) {
                K[i][j] += P_new[i][k] * H[j][k];
            }
            K[i][j] *= S_inv[j][i];
        }
    }

    // Correct state and covariance estimates
    for (int i = 0; i < STATE_SIZE; i++) {
        for (int j = 0; j < MEASUREMENT_SIZE; j++) {
            x_new[i] += K[i][j] * innovation[j];
        }
    }

    double Id[STATE_SIZE][STATE_SIZE] = {0}; // Identity matrix
    for (int i = 0; i < STATE_SIZE; i++) {
        Id[i][i] = 1;
    }

    for (int i = 0; i < STATE_SIZE; i++) {
        for (int j = 0; j < STATE_SIZE; j++) {
            P_new[i][j] = (Id[i][j] - K[i][j] * H[j][i]) * P_new[i][j];
        }
    }
}

// Implementations of model_f, model_h, jacobian, and other helper functions

void model_f(double t, const double x[STATE_SIZE], const double u[4], double x_dot[STATE_SIZE]) {
    // Decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    double q[4], w[3], v[3], alt, Cl, delta;
    memcpy(q, x, 4 * sizeof(double));
    memcpy(w, x + 4, 3 * sizeof(double));
    memcpy(v, x + 7, 3 * sizeof(double));
    alt = x[10];
    Cl = x[11];
    delta = x[12];

    // Decompose input vector: [delta_u, A(3)]
    double delta_u = u[0], A[3];
    memcpy(A, u + 1, 3 * sizeof(double));

    // Get parameters
    double m = 70;
    double J[3][3] = {{0.5, 0, 0}, {0, 50, 0}, {0, 0, 50}};
    double S[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    double S_SA[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    double length_cs[3] = {0, 0, 0};
    double c_canard = 0.005;
    double tau = 1 / 60.0;
    double tau_cl_alpha = 0.01;
    double Cl_alpha = 1.5;
    double c_aero = 1;
    double g[3] = {-9.8, 0, 0};

    // Compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    // Placeholder for quaternion to rotation matrix conversion
    // S = model_quaternion_rotmatrix(q);

    // Calculate air data
    double rho = 1.225; // Placeholder for air density at altitude
    double airspeed = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    double alpha, beta;
    if (v[0] != 0) {
        alpha = v[1] / v[0];
        beta = v[2] / v[0];
    } else {
        alpha = beta = 0;
    }
    double p_dyn = 0.5 * rho * airspeed * airspeed;

    // Forces (specific)
    double force_aero[3] = {0}; // Placeholder for aerodynamic force calculation
    double force[3];
    for (int i = 0; i < 3; i++) {
        force[i] = force_aero[i] / m;
    }

    // Torques
    double torque_canards = Cl * c_canard * p_dyn * delta;
    double torque_aero = c_aero * p_dyn;
    double torque[3] = {torque_aero * 0 + torque_canards, torque_aero * alpha, torque_aero * beta};

    // Derivatives
    double q_dot[4]; // Placeholder for quaternion derivatives calculation
    // q_dot = model_quaternion_deriv(q, w);

    double w_dot[3];
    for (int i = 0; i < 3; i++) {
        w_dot[i] = 0;
        for (int j = 0; j < 3; j++) {
            w_dot[i] += (torque[j] - (w[j] * J[j][i])) / J[i][i];
        }
    }

    double a[3];
    for (int i = 0; i < 3; i++) {
        a[i] = S_SA[i][0] * A[0] + S_SA[i][1] * A[1] + S_SA[i][2] * A[2] - length_cs[i];
    }

    double v_dot[3];
    for (int i = 0; i < 3; i++) {
        v_dot[i] = a[i] - 2 * (w[i] * v[i]) + S[i][0] * g[0] + S[i][1] * g[1] + S[i][2] * g[2];
    }

    double pos_dot[3] = {S[0][0] * v[0] + S[0][1] * v[1] + S[0][2] * v[2], S[1][0] * v[0] + S[1][1] * v[1] + S[1][2] * v[2], S[2][0] * v[0] + S[2][1] * v[1] + S[2][2] * v[2]};
    double alt_dot = pos_dot[0];

    double Cl_dot = -1 / tau_cl_alpha * (Cl - Cl_alpha);

    double delta_dot = -1 / tau * (delta - delta_u);

    // Concoct state derivative vector
    memcpy(x_dot, q_dot, 4 * sizeof(double));
    memcpy(x_dot + 4, w_dot, 3 * sizeof(double));
    memcpy(x_dot + 7, v_dot, 3 * sizeof(double));
    x_dot[10] = alt_dot;
    x_dot[11] = Cl_dot;
    x_dot[12] = delta_dot;
}

void model_h(double t, const double x[STATE_SIZE], const double u[4], double z[MEASUREMENT_SIZE]) {
    // Decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    double q[4], w[3], v[3], alt, Cl, delta;
    memcpy(q, x, 4 * sizeof(double));
    memcpy(w, x + 4, 3 * sizeof(double));
    memcpy(v, x + 7, 3 * sizeof(double));
    alt = x[10];
    Cl = x[11];
    delta = x[12];

    // Get parameters
    double S_SW[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    double S_SM[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    double S[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    double P = 101325; // Placeholder for pressure at altitude
    double T = 288.15; // Placeholder for temperature at altitude

    // Rates
    double W[3];
    for (int i = 0; i < 3; i++) {
        W[i] = 0;
        for (int j = 0; j < 3; j++) {
            W[i] += S_SW[i][j] * w[j];
        }
    }

    // Magnetic field model
    // S = model_quaternion_rotmatrix(q);
    double M[3];
    for (int i = 0; i < 3; i++) {
        M[i] = 0;
        for (int j = 0; j < 3; j++) {
            M[i] += S_SM[i][j] * S[j][0];
        }
    }

    // Concoct measurement vector
    memcpy(z, W, 3 * sizeof(double));
    memcpy(z + 3, M, 3 * sizeof(double));
    z[6] = P;
    z[7] = T;
}

void jacobian(void (*f)(double, const double*, const double*, double*), double t, const double x[STATE_SIZE], const double u[4], double h, double J[STATE_SIZE][STATE_SIZE]) {
    double y[STATE_SIZE];
    f(t, x, u, y);

    for (int k = 0; k < STATE_SIZE; k++) {
        double x_perturbed[STATE_SIZE];
        memcpy(x_perturbed, x, STATE_SIZE * sizeof(double));
        x_perturbed[k] += I * h;
        double y_perturbed[STATE_SIZE];
        f(t, x_perturbed, u, y_perturbed);

        for (int j = 0; j < STATE_SIZE; j++) {
            J[j][k] = cimag(y_perturbed[j]) / h;
        }
    }
}

void initialize_params(EKFParams *params) {
    // Initialize the state vector x with some example values
    double x[STATE_SIZE] = {1, 0, 0, 0,   // Quaternion (identity)
                            0, 0, 0,      // Angular velocity
                            0, 0, 0,      // Linear velocity
                            1000,         // Altitude
                            0,            // Lift coefficient
                            0};           // Control surface deflection
    memcpy(params->x, x, STATE_SIZE * sizeof(double));

    // Initialize the covariance matrix P as an identity matrix
    double P[STATE_SIZE][STATE_SIZE] = {0};
    for (int i = 0; i < STATE_SIZE; i++) {
        P[i][i] = 1.0;
    }
    memcpy(params->P, P, STATE_SIZE * STATE_SIZE * sizeof(double));

    // Initialize the control vector u with zeros
    double u[4] = {0, 0, 0, 0};  // No control input
    memcpy(params->u, u, 4 * sizeof(double));

    // Initialize the measurement vector y with some example values
    double y[MEASUREMENT_SIZE] = {0, 0, 0,  // Angular velocity (no rotation)
                                  1, 0, 0,  // Magnetic field (aligned with x-axis)
                                  101325,   // Pressure at sea level
                                  288.15};  // Temperature at sea level
    memcpy(params->y, y, MEASUREMENT_SIZE * sizeof(double));

    // Initialize the process noise covariance matrix Q with small values
    double Q[STATE_SIZE][STATE_SIZE] = {0};
    for (int i = 0; i < STATE_SIZE; i++) {
        Q[i][i] = 0.1;
    }
    memcpy(params->Q, Q, STATE_SIZE * STATE_SIZE * sizeof(double));

    // Initialize the measurement noise covariance matrix R with small values
    double R[MEASUREMENT_SIZE][MEASUREMENT_SIZE] = {0};
    for (int i = 0; i < MEASUREMENT_SIZE; i++) {
        R[i][i] = 0.01;
    }
    memcpy(params->R, R, MEASUREMENT_SIZE * MEASUREMENT_SIZE * sizeof(double));

    // Set the time step T and integration step size step
    params->T = 0.1;    // Time step of 0.1 seconds
    params->step = 0.01; // Integration step size of 0.01 seconds
}


int main() {
    EKFParams params;
    double x_new[STATE_SIZE];
    double P_new[STATE_SIZE][STATE_SIZE];
    initialize_params(&params);

    // Initialize params with required values

    ekf_algorithm(&params, x_new, P_new);

    // Print the new state vector x_new
    printf("New state vector x_new:\n");
    for (int i = 0; i < STATE_SIZE; i++) {
        printf("%f ", x_new[i]);
    }
    printf("\n");

    // Print the new covariance matrix P_new
    printf("New covariance matrix P_new:\n");
    for (int i = 0; i < STATE_SIZE; i++) {
        for (int j = 0; j < STATE_SIZE; j++) {
            printf("%f ", P_new[i][j]);
        }
        printf("\n");
    }

    return 0;
}