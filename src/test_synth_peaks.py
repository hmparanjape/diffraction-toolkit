from ge_processor.ge_pre_processor import *
import numpy as np
from scipy.ndimage.filters import gaussian_filter

# Setup logger
log_level = logging.DEBUG
logger = logging.getLogger('hexrd')
logger.setLevel(log_level)
ch = logging.StreamHandler()
ch.setLevel(log_level)
cf = logging.Formatter('%(asctime)s - %(message)s', '%y-%m-%d %H:%M:%S')
ch.setFormatter(cf)
logger.addHandler(ch)

try:
    test_peaks_data = np.loadtxt('test_peak_input.data')
except:
    test_peaks_data = np.array([[10.0, 100.0, 500.0], \
                                [32.0, 456.0, 1100.0], \
                                [50.0, 900.0, 200.0], \
                                [74.0, 733.0, 499.0], \
                                [90.0, 15.0, 2004.0], \
                                [104.0, 722.0, 1788.0]])

logger.info("Using test peak data")

template = "{0:>12}{1:>12}{2:>12}"
print template.format("O", "X", "Y")

for o, x, y in test_peaks_data:
    print template.format(o, x, y)

# Create empty array for GE2
o_size = np.amax(test_peaks_data[:, 0], axis=0) + 10
x_size = 2048
y_size = 2048

logger.info("Creating a GE2 stack with size (%d, %d, %d)", o_size, x_size, y_size)

arr = np.zeros((o_size, x_size, y_size))

for o, x, y in test_peaks_data:
    for ii in range(-2, 2):
        for jj in range(-2, 2):
            for kk in range(-2, 2):
                arr[o + ii][y + jj][x + kk] = 10000.;
# Add a blur
arr_blur = gaussian_filter(arr, sigma=3)

# Write GE2
write_ge2("synth_00000.ge2", arr_blur)
