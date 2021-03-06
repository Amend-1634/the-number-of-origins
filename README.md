# The number of origins  
Estimation of the number of origin of populaiton with spatial structure for inferring the effective population size

## Flowchart
<img src="flowchart.png" alt="flowchart" width="450"/>

**all_pkg.jl** #before start: download all the packages + all questions summarized

## 1_\*.jl, 2_\*.jl: Non-spatial model  
###### 1_*.jl #multinomial distribution for genetic drift (Non-spatial model)
- 1_1allele_frequency.jl # the process of selection, genetic drift and mutation   
                       a. selection (adjust the frequency entering genetic drift)  
                       b. genetic drift (multinomial distribution) 
                       c. mutation (Poisson distribution)  
- 1_2num_origin.jl # count the existant allele (frequency not=0) along the generations   


test file:
  - 1_1plot.jl #for testing whether 1_1allele_frequency.jl function well
  - 1_3multinomial_plot.jl # test 1_2*.jl and plot  

###### 2_*.jl #Gaussian distribution for population size > 10^6 (Non-spatial model)
- 2_1allele_var_mtx.jl #covaraiance matrix  
- 2_2gaussian_multinomial.jl #multivariate normal distribution (MvNormal) incorporating covariance  
- 2_3allele_frequency_gaussian.jl # same process as 1_allele_frequency.jl, except replacing multinomial sampling for genetic drift by Gaussian approximation  
- 2_4num_origin_gaussian.jl #count the existant allele
test file:
  - 2_5gaussian_test.jl #test 2_4*.jl and plot  

## 3_*.jl: One-dimensional model with local migration merely
       # a. use 1_allele_frequency.jl or 2_3allele_frequency_gaussian.jl  
       # b. local migration:  
              # total migration cases of each deme (Poisson sampling)--leaving  
               # dispersal direction of cases (Binomial: left or right)  
                # add the immigrants to the destination deme--entering  

###### 3_1*.jl allele frequency  
- 3_1_1track_cons.jl   
              # trial: migration is tracked in individuals along with generations  
- 3_1_2notrack_cons.jl #**employed** version for later series of functions, assumming          #constant deme population size, migration only   #change the frequeny of each advantageous haplotype  
- 3_1_2notrack_cons_sparse.jl # sparse matrix based on 3_1_2notrack_cons.jl but for large data--more demes  
- 3_1_2notrack_cons_t-1.jl # trial: mutation and migration taking the frequency of last generation as input of sampling instead of the      #output of last process like Pac-Man  
- 3_1_3notrack_osci.jl # **employed** oscillating population size  

###### 3_2*.jl Sampling 3_1*.jl   
- 3_2_1d_tsamp.jl #time-series for constant population size  
- 3_2_1d_tsamp_osci.jl #time-series for oscillating population size  
- 3_3_1d_fixsamp.jl #collect the generation and asymptotic number of origin at fixation  
- 3_3_1d_fixsamp_osci.jl # collect for oscillating population size  
- 3_3_test.jl #check 3_*.jl series function right or not  

###### 3_4*.jl: compare parameters and plot
- 3_4_figjoejyn_series.jl # aligning the output from different parameters for later comparison  
- 3_4_figjoejyn_series_threads.jl #multi-threads for speeding up (not for large data)  
- 3_4_figjoejyn_series_test.jl #later comparison by plotting  

## 4_*.jl: 1d model with migration in Student's t distribution (local + non-local)  
- 4_1_1nonlocal_frequency.jl  
                        - selection + genetic drift + mutation  
                        - migration:  
                          - total migrants of each deme (Poisson sampling)  
                          - dispersal direction and how many deme the individual jump accross (t distribution sampling)  
- 4_1_1nonlocal_frequency_sparse.jl # sparse matrix for large data--more demes  
- 4_2_1d_tsamp.jl #time-series sampling of existant haplotype  
- 4_3_1d_fixsamp.jl #collect the time to fixation and asymptotic number of origins  
- 4_4_figjoejyn_series.jl #function collection for output with different parameters  
- 4_4_figjoejyn_series_threads.jl #multi-thread added compared to 4_4_figjoejyn_series.jl

###### interest in comparison  
- compare_nu.jl #compare the degree of freedom in sampling migration in t distribution
- 4and3_largenDemes.jl #large deme (nDemes = 500)
                       #4 represent model with migration in t distribution
                       #3 represent model with migration in binomial distribution
- 4_series_test_new.jl #all else  
- test_sampling_distribution.jl #plotting different migration distribution

- time_cost.xlsx #time for simulation corresponding to the comparison and parameters applied
                 #4_* represent in model with migration in t distribution
                 #3_* represent in model with migration in binomial distribution
