# Currently under heavy development, file names and org will change
substantially. 

Current flow is: 

Run monkey_recon to:

- correctly orient the MRI
- segragate brain matter from neck/skin/skull
- segregate white matter from gray matter
- construct pial and white matter surfaces

monkey_recon has an MRI definition file, which it reads, similar to 
analyze/procDay.m, to determine the order of execution of processing
functions. In the future, these can be swapped out where necessary. 


To come: 

coregister: 
- anatomical atlases
- recorded anatomical data (e.g. DTI)
- electrode locations
- fMRI-identified ROI's


