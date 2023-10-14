# SEIBMRiverFish
A spatially explicit (1D) individual-based model for shovelnose sturgeon populations in a tributary of the Missouri River system

## Description 
SEIBMRiverFish is a spatially explicit, individual-based model designed to simulate population dynamics of shovelnose sturgeon via individual-based processes including movement, foraging, growth, metabolism, maturation, reproduction, and mortality in a large river system, as described in more detail as well as its applications for evaluating spatially and temporally dynamic effects of environmental changes such as climate-induced changes in hydrology and synthetic chemical pollutants in [Goto et al. 2015](https://www.sciencedirect.com/science/article/abs/pii/S0304380014004992), [Goto et al. 2018](https://www.publish.csiro.au/MF/MF17082), and [Goto et al. 2020](https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.6153).

The sturgeon biophysical model simulates sturgeon population dynamics with two types of entities: river and sturgeon. The model river consists of 162 equally divided longitudinal rectangular segments (i.e. 1 river kilometre (rkm) each, where rkm is a measure of distance along a river) with six state variables: daily, depth-averaged discharge (m3);meandepth (gauge height; m); channel width (m); benthic invertebrate prey density (g m2); water temperature (degree-C); and photoperiod (h). Discharge, depth, width and prey density are spatially explicit, whereas temperature and photoperiod are spatially uniform. 

The sturgeon model keeps track of state variables of the entire life cycle. Early life stages (fertilised eggs, yolk-sac larvae, feeding larvae, and age-0 juveniles) are represented as superindividuals, whereas age-1+ juveniles and adults are represented as individual fish. Each superindividual is a collection of individuals (‘cohorts’) from the same mother. The model has 11 state variables: body length (mm), storage mass (g), structural mass (g), gonadal mass (g), the number of individuals in each superindividual, maturity status, reproductive status, physiological condition (the index of physiological condition,sex, age and longitudinal location in the river (rkm).


<img src="https://github.com/dgoto2/SEIBMRiverFish/blob/main/ibm_sns/sturgeonIBM.png?raw=true" width="380"> <img src="https://github.com/dgoto2/SEIBMRiverFish/blob/main/ibm_sns/env.vars.png?raw=true" width="400">

The model simulates the sturgeon population and updates state variables at discrete daily time steps over years and generations. The river habitat conditions are first updated, and the model then evaluates actions by sturgeon in the following order: (1) spawning, (2) hatching and larval development, (3) movement, (4) foraging, (5) growth and (6) mortality. The model updates state variables at the end of each action. At the beginning of each year, maturity is evaluated and, if mature sturgeon are healthy, they enter the reproductive cycle. Spawning normally occurs from late spring to early summer in the study system.

<img src="https://github.com/dgoto2/SEIBMRiverFish/blob/main/ibm_sns/output1.png?raw=true" width="400">

## References
Goto, D., M. J. Hamel, J. J. Hammen, M. L. Rugg, M.A. Pegg, and V.E. Forbes. 2015. [Spatiotemporal variation in flow-dependent recruitment of long-lived riverine fish: Model development and evaluation](https://www.sciencedirect.com/science/article/abs/pii/S0304380014004992). Ecological Modelling. 296: 79–92. doi:10.1016/j.ecolmodel.2014.10.026

Goto, D., M. Hamel, J. Hammen, M. Rugg, M.A. Pegg, and V.E. Forbes. 2018. [Spatially dynamic maternal control of migratory fish recruitment pulses triggered by shifting seasonal cues](https://www.publish.csiro.au/MF/MF17082).  Marine and Freshwater Research. 69(6): 942-961. 10.1071/MF17082

Goto, D., M. Hamel, J. Hammen, M. Rugg, M.A. Pegg, and V.E. Forbes. 2020. [Divergent density feedback control of migratory predator recovery following sex-biased perturbations](https://onlinelibrary.wiley.com/doi/full/10.1002/ece3.6153). Ecology and Evolution. 10(9): 3954-3967. doi.org/10.1002/ece3.6153
