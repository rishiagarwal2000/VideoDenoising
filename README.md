# Video Denoising
A compressed sensing approach to denoise videos.

We have implemented a paper on robust video denoising. This method works for any noise model.
There are two important algorithms in this method
- Median filtering with adaptive window size
- Low rank matrix recovery algorithm

We exploit the fact that a matrix in which the columns are vectors of similar patches will have a low rank.
We have tried our implementation on various datasets from this website: https://media.xiph.org/video/derf/

We have attached a report which gives the proof of correctness for the algorithm. It also shows the experimental results.
