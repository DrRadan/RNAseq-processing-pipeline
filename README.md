# OUTLINE 

This analysis pipeline takes de-multiplexed, single- or paired-end, directional RNA-seq reads, tagged with the PCR duplicates’ marker, and produces a map of where these reads originated from in the genome.


# DIRECTIONS

1) The read files must be de-multiplexed (DGseq demultiplexing) and have the .fastq suffix. Everything that precedes the fastq suffix is the name that will identify all the output files produced. 

2) Log in your NYU HPC account and create a folder containing all the demultiplexed read files you want to analyze. This folder will be the /source/folder.

3) (Optional) Make a second folder that will become the /destination/folder. Alternatively, you can use the same directory every time you are asked for either the /source/folder or /destination/folder.

4) Go to the folder /data/cgsb/gresham/LABSHARE/SHARED/CODE/. You need to be listed as a member of the Gresham lab, registered with the NYU HPC team managing /data/cgsb/, to be able to read, write or execute the programs in this folder.

5) To submit the job and start the analysis of your results type:
