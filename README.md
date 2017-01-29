Colormaps from MatPlotLib 2.0
=========

The MatPlotLib 2.0 default colormaps ported to MATLAB. This submission also includes the Line Color Order colormaps!

For version 2.0 of MatPlotLib new perceptually uniform colormaps were generated in the CAM02-UCS colorspace. The process is described here: 
<http://matplotlib.org/2.0.0rc2/users/dflt_style_changes.html>
The default MatPlotLib colormap was changed to the newly created VIRIDIS, replacing the rather awful JET/RAINBOW.

Each colormap function consists of just one M-file that provides all data. Downsampling or interpolation of the nodes occurs automatically, if required (interpolation occurs within the Lab colorspace). User who do not wish to bather with Lab interpolation can easily edit the Mfiles and interpolate in RGB.

### Examples ###



### Note ###

The following files are part of GitHub/git repository, and are not required for using this submission in MATLAB:
* .gitattributes
* README.md
