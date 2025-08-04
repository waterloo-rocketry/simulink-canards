#ifndef GAIN_TABLE_H_ 
 #define GAIN_TABLE_H_

/**
 * Controller gains 

 * Conversion from flight conditions to natural table coordinates:
 * float x_nat = (x_fc - x_OFFSET) / x_SCALE;

 * Array creation order:
 * for gain_number = 1:gain_amount
 *      for p = 1:P_size
 *          for c = 1:C_size
 *              Ks(p, c, gain_number)
*/

// Gain table information 
#define GAIN_NUM 4

#define GAIN_P_SIZE 200
#define GAIN_C_SIZE 30

#define PRESSURE_DYNAMIC_SCALE 3.0766E+03
#define CANARD_COEFF_SCALE 1.0345E+00

#define PRESSURE_DYNAMIC_OFFSET 2.5000E+02
#define CANARD_COEFF_OFFSET -1.5000E+01

extern const float gain_table[GAIN_NUM][GAIN_P_SIZE * GAIN_C_SIZE];

#endif // GAIN_TABLE_H_