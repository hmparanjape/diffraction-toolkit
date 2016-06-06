#Diffraction Toolkit

A toolkit to complement existing High Energy Diffraction Microscopy (HEDM) frameworks
for reconstructing crystallite-scale microstructures in metals and alloys. This toolkit,
written in Python, currently adds two capabilities.

* HEDM pattern clean-up and analysis tools: Provide methods to obtain local maxima 
of the spots and generate clean patterns from the local maxima. Methods to obtain
spot shape and size through a scheme inspired by Principal Component Analysis (PCA).
* Forward modeling of diffraction patterns from microstructural data: Simulation of
HEDM far-field spot patterns from microstructural data comprising of position,
phase information, crystal orientation and lattice strain.

##Background

[heXRD](https://github.com/praxes/hexrd) and [MIDAS](https://github.com/marinerhemant/MIDAS)
are two widely used HEDM microstructure reconstruction frameworks. While they have been
extensively used to reconstruct microstructures in materials with symmetric crystal structures
(e.g. cubic, HCP), certain practical aspects have proved reconstruction of microstructures
in phase transforming materials challenging. Phase transforming materials, e.g. shape memory alloys
undergo a transformation in crystal structure from cubic to a low symmetry phase (e.g. tetragonal,
monoclinic). Compared to cubic materials, the diffraction patterns from the low symmetry phases are busier due to lower
multiplicity of atomic planes and fuzzier due to finer microstructural length scales. To
make the reconstruction of microstructures with low symmetry phases more practical,
we have developed this toolkit.

##Development

Written by Harshad Paranjape with contributions from developers at Colorado School of Mines.
All rights reserved. Please consult Harshad Paranjape (hparanja@mines.edu) for usage instructions.

