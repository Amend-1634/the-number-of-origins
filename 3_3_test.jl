#test file for all 3_*.jl

##Why the number of origins in time-series is half of Joejyn's simulation?(2020/2/19)



##Test the geneerating of frequency cell array "3_1_2notrack_cons.jl"
pwd()
cd("D:\\Julia\\func")
using Profile
using BenchmarkTools
include("3_1_2notrack_cons.jl")
@time D=gaussian_1d_localmig(1e6,10,0.05,5e-5,200,3, 1)
       #gaussian_1d_localmig(N,twoNmu,s0,mig,T,nDemes, Gauss)

using Plots
plot(D[1]',yscale=:log10,ylims=(1e-6,1))


##Test sparse matrix version 3_1_2notrack_cons.jl
include("3_1_2notrack_cons_sparse.jl")
println("sparse")
@time D= gaussian_1d_localmig(5e3,10,0.1,5e-5,50,5, 1) # 0.287747s
#7 times of time--3/4 space
#will be only used for large dataset
#use sparse matrix and avoid @threads to avoid Outofmemory() error

#used in fixsamp instead of tsamp
typeof(D[1])
typeof(sparse(rand(2,3)))

D[2]
extrema(D[2])
plot(D[2]',yscale=:log10,ylims=(1e-5,1),legend=false)
plot(D[2]')
#finally function well

include("4_1_1nonlocal_frequency_sparse.jl")
D, X_D= gaussian_1d_nonlocalmig(1e5,10,0.1,5e-5,100,5,1,1)
      # gaussian_1d_nonlocalmig(N,twoNmu,s0,mig,T,nDemes, Gauss,nu)#N




##"3_1_3notrack_osci.jl"

a=collect(1:50)
b=0.5(Nmax+Nmin) .+ 0.5(Nmax-Nmin)*sin.(2pi*a/12)
# the lowest point won't reach 0
b=b/1e8
plot!(b,color=:red)

include("3_1_3notrack_osci.jl")
N=1e7; phi=10
@time D= gaussian_1d_localmig(N, phi, "H",       1, 0.1,5e-7,2000,5, 1) #132.452806 s
#function gaussian_1d_localmig(N, phi, har_geo, twoNmu,s0,mig,T,nDemes,Gauss)#N
plot(D[1]')

plot(D[5]',alpha=0.8,legend=false,dpi=300,yscale=:log10,ylims=(1e-7,1))
#the mutant frequency is extremly low?
#mig lower(mig=5e-7)=>bit more but same level
#longer time (2000)

plot!(b,color=:red)
savefig("..\\photo\\osci_period")

xlabel!("generations")
ylabel!("allele frequency or red total N*10^(-8)")
title!("allele frequency of oscillating total N")
savefig("..\\photo\\osci_freq")


##tsamp

N=1e7;
N=1e9; nDemes=10;twoNmu=1;s0=0.1;mig=5e-5;M=10;T=2000
 # N=1e8;

include("3_1_1track_cons.jl")
include("3_2_1d_tsamp.jl")
Gauss=1
@time avn, se, tsamp = num_origin_1d_t(N,nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3] #40.9s
plot(tsamp, avn, yerror=se,lab="Gaussian",dpi=300)

Gauss=0
@time avn, se, tsamp = num_origin_1d_t(N,nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3] #48s

N=1e9; nDemes=10;twoNmu=1;s0=0.1;mig=5e-5;M=10;T=2000;Gauss=1
include("3_1_1track_cons.jl")
include("3_2_1d_tsamp.jl")
using Profile
@profiler avn, se, tsamp = num_origin_1d_t(N,nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3] #40.9s


plot!(tsamp, avn, yerror=se,lab="Multinomial",legend=:inside)
xlabel!("generations")
ylabel!("the number of origins")
# savefig("..\\photo\\1d_N1e7_Gaussian_multinomial_vary") #differ
savefig("..\\photo\\1d_N1e9_Gaus_multino_vary")#differ
#Conclusion: for 1d model, Gaussian may not substitute multinomial distribution
 #for 1e7,8,9 so later on I will use Multinomial distribution
-----------
#compare multinomial and Gaussian in tsamp
include("3_1_2notrack_cons.jl")
include("3_2_1d_tsamp.jl")
Gauss=1
@time avn, se, tsamp = num_origin_1d_t(N,nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3] #40.9s
plot(tsamp, avn, yerror=se,lab="Gaussian",dpi=300)

Gauss=0
@time avn, se, tsamp = num_origin_1d_t(N,nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3] #48s
plot!(tsamp, avn, yerror=se,lab="Multinomial",legend=:inside)
xlabel!("generations")
ylabel!("the number of origins")
# savefig("..\\photo\\1d_N1e7_Gaussian_multinomial_vary") #differ
savefig("..\\photo\\1d_N1e8_Gaus_multino_vary")#differ

----------
#sampling at time points in oscillating population size
nDemes=5;twoNmu=1;s0=0.1;mig=5e-5;M=3;T=1000
Nmax=5.5e7
Nmin=5.5e6
Gauss=0
har_geo="H"
include("3_2_1d_tsamp_osci.jl")
@time avn, se, tsamp = num_origin_1d_t_osci(Nmax, Nmin, har_geo, nDemes,twoNmu,s0,mig,M,T,Gauss)[1:3]
#157s
avn
plot(tsamp, avn, yerror=se,lab="Multinomial",dpi=300)
xlabel!("generations")
ylabel!("the number of origins")
savefig("..\\photo\\tsamp_osci_test")


##fixsamp
include("3_3_1d_fixsamp.jl")
using Profile
@profiler t_avn, t_se, eta_avn, eta_se, fix_M = num_origin_1d_fix(1e3,5,50,0.1,0.05,3,200,1)

include("3_3_1d_fixsamp.jl")
using Profile
@profiler t_avn, t_se, eta_avn, eta_se, fix_M = num_origin_1d_fix(1e3,5,50,0.1,0.05,3,200,1)

@time t_avn, t_se, eta_avn, eta_se, fix_M = num_origin_1d_fix(1e3,5,10,0.1,0.05,3,200,1)
                                # num_origin_1d_fix(N,nDemes,twoNmu,s0,mig,M,T,Gauss)
t_avn
t_se
eta_avn
eta_se
fix_M

#checked, function well

#oscillating population size
pwd()
include("3_3_1d_fixsamp_osci.jl")
@time t_avn, t_se, eta_avn, eta_se, fix_M = num_origin_1d_fix(1e3,5,10,0.1,0.05,3,200,1)

t_avn
eta_avn


##Large nDemes (100)
# include("3_1_1track_cons.jl")
include("3_1_2notrack_cons.jl") #Bhavin preferred
#Compare between different deme nubmers:
#nDemes changing:
 #1.should the NDeme be the constant (//I preferred)?
    #as constant N will make the NDeme in accordance with higher nDemes
    #more senesitive to genetic drift
    #as spatially expand-not influence local density
 #2.should population-scaled parameter (twoNmu, twoNs, twoNmig) be the constant
  #in comparison? or mu s mig themself (//I preferred)?
@time D1= gaussian_1d_localmig(1e9,100,0.1,5e-7,2000,100, 0) #14.17hr
         #gaussian_1d_localmig(N,twoNmu,s0,mig,T,nDemes, Gauss
@time D2= gaussian_1d_localmig(5e7,5,0.1,5e-7,2000,5, 0) #8s @Clifford
@time D3= gaussian_1d_localmig(1e10,1000,0.1,5e-7,2000,1000, 0) #
 #assume that twoNmu for nDemes=1 NDeme=1e7 is 1


using JLD
pwd()
readdir()
save("nDemes_100_D1.jld","D1",D1) #am
save("nDemes_5_D2.jld","D2",D2) #am2
save("nDemes_1000_D3.jld","D3",D3) #am2


readdir()
using JLD
@load "notracking_100nDemes.jld"


"notracking_NDeme1e7.jld"
"tracking_100nDemes.jld"
"tracking_100nDemes_1e7deme.jld"


using JLD
@load "nDemes_100_D1.jld"
@load "nDemes_5_D2.jld"


using Plots

# the mutation rate of spatial one seems to be less than non-spatial

#populatio size of each deme too small so the effect of genetic drift is too significant?
plot(D[1]',yscale=:log10,ylims=(1e-5,1),legend=false,dpi=300)
plot(D1[2]',yscale=:log10,ylims=(1e-7,1),legend=false,dpi=300)
plot(D1[3]',yscale=:log10,ylims=(1e-7,1),legend=false,dpi=300)

plot(D2[4]',yscale=:log10,ylims=(1e-7,1),legend=false,dpi=300)
plot(D2[5]',yscale=:log10,ylims=(1e-7,1),legend=false,dpi=300)

# why quick mutation and reach fixation during 500~1500 generations
# Is the dispersal  rate set too large? (range of dispersal rate)


##"3_4_figjoejyn_series_threads.jl"
N_vec=[5e3 5e2]

N=5e3
s0_vec=[0.5 0.1]
twoNmu_vec=[0.1 1]
nDemes=5
mig=0.005
Gauss=1
M=2
T=100

include("3_1_2notrack_cons.jl")
include("3_2_1d_tsamp.jl")
include("3_4_figjoejyn_series_threads.jl")
tsamp, legend, avn_mtx, se_mtx=s0_twoNmu_N_series(nDemes,N,twoNmu_vec,s0_vec, mig, M, T, Gauss)
plot(tsamp,avn_mtx,yerror=se_mtx)
legend
