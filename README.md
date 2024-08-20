#Burst-classifier: Automated Classification of Solar Radio Burst Type II, III and IV for CALLISTO Spectra using Physical Properties during Maximum of Solar Cycle 24

This MATLAB code implements an automatic classification algorithm for CALLISTO spectra, categorizing them into Solar Radio Burst Types II, III, and IV. 
The algorithm is designed based on the physical properties of bursts collected during the solar maximum 2014 (Solar Cycle 24). 
Four characteristic parameters were chosen from a collection of training dataset files, derived from the intensity bursts observed in the frequency channels and time steps of the spectrum.

#Limitation
This code only works with positive burst spectra from CALLISTO that have been verified through manual observation.

#Usage
1. The spectrum data to classify must be placed in a specific folder, and the folder path should be copied and pasted into Line 6 of the main script.
2. The location for the final classification results must also be specified and pasted into the corresponding line in the main script.
   
#License
This code is released under the Universiti Sultan Zainal Abidin license. You may use it in personal or commercial projects.

