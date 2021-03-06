###############################################################################
# Diffraction-toolkit (https://github.com/hmparanjape/diffraction-toolkit)
# HEDM Forward Modeling Library
#
# Either generate a synthetic microstructure or simulate HEDM patterns
# from the microstructural data provided by the user.
#
# Written by Harshad Paranjape (hparanja@mines.edu) and contributors.
# All rights reserved.
# Released under GNU Lesser General Public License v2.1 or above
# https://www.gnu.org/licenses/old-licenses/lgpl-2.1.en.html
#
###############################################################################
import copy
import logging
import os
import sys
import time
import warnings

import yaml

from hexrd import config

from forward_modeling.fwd_modeling_from_micro import *
from forward_modeling.microstructure_generation import *

if __name__ == '__main__':
    # Read args
    if len(sys.argv) < 2:
        print 'USAGE: python synth_fwd_modeling_patterns.py config.yml'
        sys.exit(1)
    elif sys.argv[1] == '-h' or sys.argv[1] == '--help':
        print 'USAGE: python synth_fwd_modeling_patterns.py config.yml'
        sys.exit(1)
    else:
        cfg_file = sys.argv[1]

    # Setup logger
    log_level = logging.DEBUG
    logger = logging.getLogger('hexrd')
    logger.setLevel(log_level)
    ch = logging.StreamHandler()
    ch.setLevel(log_level)
    cf = logging.Formatter('%(asctime)s - %(message)s', '%y-%m-%d %H:%M:%S')
    ch.setFormatter(cf)
    logger.addHandler(ch)
    # load the configuration settings
    cfgs = config.open(cfg_file)

    # cfg is a list. We will loop over each cfg set.
    for cfg in cfgs:
    	logger.info('=== begin forward-modeling ===')

        try:
            fwd_model_mode = cfg.get('forward_modeling')['modeling_mode'].strip()
        except:
            logger.error('Invalid forward modeling mode. Choices are datagen and fwdmodel')

	# If datagen then generate synthetic microstructure data.
	# Certain functions are predefined in the microstructure_generation library.
	# Implement other functions there.
        if fwd_model_mode == "datagen":
            try:
	        fwd_model_nipt = cfg.get('forward_modeling')['datagen']['number_of_points']
            except:
                logger.error('Invalid value for number of data points to generate for forward modeling input.')

            try:
	        fwd_model_op_file = cfg.get('forward_modeling')['datagen']['output_file_name'].strip()
            except:
                logger.info('Invalid name for text output file. Defaulting to ms-synth.csv')
                fwd_model_op_file = 'ms-synth.csv'

            logger.info('=== generating synthetic microstructural data ===')
	    logger.info('=== writing output to %s ===', fwd_model_op_file)

	    # Generate a monoclinic single crystal with mosaicity and strain spread.
	    generate_mono_grain_mosaicity(nipt=fwd_model_nipt, output_file=fwd_model_op_file, \
					  material_name='NiTi_mono', mosaicity=0.0001, defgrad_spread=0.0001)
	    # Generate a cubic single crystal with mosaicity and strain spread.
	    #generate_cubic_grain_mosaicity(nipt=fwd_model_nipt, output_file=fwd_model_op_file)
	    # Generate an ideal cubic single crystal - without mosaicity or strain.
            #generate_cubic_grain_ideal(nipt=fwd_model_nipt, output_file=fwd_model_op_file)
	    # Generate an ideal polycrystal. Each point is a grain. No mosaicity or strain.
            #generate_cubic_grains_random_ideal(nipt=fwd_model_nipt, output_file=fwd_model_op_file)

	# If fwdmodel then simulate diffraction patterns
        elif fwd_model_mode == "fwdmodel":
	    # Get microstructural input file name. See Github documentation for the format of this file.
            try:
                fwd_model_ip_filename = \
                    cfg.get('forward_modeling')['fwdmodel']['input_file_name'].strip()
            except:
                fwd_model_ip_filename = 'ms-data.csv'
	    # Get the file name for output data - two-theta, eta, omega for spots.
            try:
                fwd_model_op_filename = cfg.get('forward_modeling')['fwdmodel']['output_file_name'].strip()
            except:
                logger.info('Invalid output text file name. Defaulting to synth-data.out.')
                fwd_model_op_filename = 'synth-data.out'

	    # Create a Microstructure object. This stores all data related to input and simulated output.
	    # TODO: Decide if we want to read everything from cfg into Microstructure or from cfg to here.
            ms = Microstructure(cfg, logger, fwd_model_ip_filename)
	    # Read microstructural input froma  CSV file.
            ms.read_csv()
	    # Obtain diffraction angles using routines implemented in heXRD
            ms.get_diffraction_angles()
	    # Project the two-theta, eta, omega angles to X, Y using heXRD detector routines.
            ms.project_angs_to_detector(output_file=fwd_model_op_filename)

	    try:
	        output_ge2_flag = cfg.get('forward_modeling')['fwdmodel']['output_ge']
	    except:
		output_ge2_flag = False

	    if output_ge2_flag is not False:
                # Write output to GE2
                try:
                    output_ge2 = cfg.get('forward_modeling')['fwdmodel']['output_ge_name']
                except:
                    logger.info('Invalid name for output GE2 file. Defaulting to ff_00000.ge2.')
                    output_ge2 = 'ff_00000.ge2'

                try:
                    omega_start = cfg.get('forward_modeling')['fwdmodel']['output_omega']['start']
                    omega_step = cfg.get('forward_modeling')['fwdmodel']['output_omega']['step']
                    omega_stop = cfg.get('forward_modeling')['fwdmodel']['output_omega']['stop']
                except:
                    logger.info('Invalid omega start, stop or end parameters. Defaulting to the range of 0 to 360 degrees with 0.1 degree step size.')
                    omega_start = 0.0
                    omega_step = 0.1
                    omega_stop = 360.0

	        ms.write_xyo_to_ge2(output_ge2=output_ge2, omega_start=omega_start, omega_step=omega_step, omega_stop=omega_stop)

        else:
            logger.error('Invalid forward modeling mode: %s. Choices are datagen and fwdmodel', fwd_model_mode)
