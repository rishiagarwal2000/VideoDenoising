## Guide through the code

- The file 'main.m' executes experiments.
 - Variables 'kappa, s, sigma' represent noise levels for poisson, impulsive, gaussian models respectively.
 - 'K' is the number of frames.
 - 'H, W' represent the height and width of the frames.
 - 'px, py' represent patch size.
- 'fpi.m' contains the implementation of the low rank matrix recovery algorithm.
  - 'tau' is a parameter which you can set to any value between 0 and 2. Play around with it to find the most appropriate value for your problem.
  - 'max_iter' the maximum number of iterations for which you want the optimization to run.
- 'admedfilt.m' contains the implementation of adaptive median filtering. This version requires the knowledge of values of impulses.
 - In the image case we have set the max. impulse to 255, and min. impulse to 0. You should change these according to your setting.
- 'admedfilt_2.m' is a more general version for adaptive median filtering. It requires no knowledge of values of impulses.
- 'gen_adapt_stats.m' generates stats for normal vs adaptive median filtering.
- 'basicPM.m' implements patch matching.
