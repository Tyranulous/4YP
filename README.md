# 4YP
Scripts and data for final year project.


_NOTE: This software requires MATLAB with the Deep Learning and Statistics and Machine Learning toolboxes to run._

## Dataset

The dataset is contained on the *data* branch.
This is the raw data that was generated and saved immedately after performing the auto-tune analysis. 
This is found in the HPCAI.Data folder, each subfolder of which indicates a different method of choosing input parameters.
The data is very raw, so for use must be interpreted and inputted programmatically.
MATLAB functions and scripts which do this can be found in the todo branch, or if analysis is to be performed in a different language 
Due to the raw and somewhat badly labeled nature of these data, it is recommended that they aren't used in their raw state but that you use the scripts provided.
Additionally, some subsection of the results are broken but kept their for reference. 


## Scripts

To run scripts, change to the _matlab_ branch.
All of the scripts and data used for submission to SC21 are contained within the [HPCAI.Data/2080ti_random_pertebation](https://github.com/Tyranulous/4YP/tree/matlab/HPCAI.Data/2080ti_random_dm_pertebation) and [HPCAI.Data/shared_scripts](https://github.com/Tyranulous/4YP/tree/matlab/HPCAI.Data/shared_scripts) folders.
To run them, you  must open the 2080ti_random_dm_pertebation folder in matlab and run the dataimporter.m script. 
(_note for this to work on someone elses computer a hardcoded paths will need to be changed so MATLAB can find the rights scripts)._
This goes through all the subfolders (indicateing distinct times astro-accelerate ran) and records the data into a strcutrure called datain.
Each record of datain represents one telescope.

To use the MATLAB regression learner on the data, the features must be extracted from datain.
First to split the dataset into a training and validation set run:

    [training_datain, validation_datain] = holdback(datain,p)

This randomly selects *p* percent of the datain provided to be put into a new datain structure called validation_datain and the rest to a training_datain struct.
Next data is extracted into a table.
This is done by running:

    [full_table,reduced_table,~] = combined_feature_tabler(datain)

Where datain can be changed to be the training data and/or validation data.

Now the MATLAB Regression learner can be run on the resultant table.
The regression learner provides a GUI for running some standard models on the data, with options for chaning hyper parameters, this is how the trees based models were created.

### Neural Networks

To train a neural network, use the *multi_classif_notlive.m* script.
This is a self contained script which will generate multiple neural network models to predict parameter sets.
It will train the models, and then output some performance metrics for the various models along with plotting the percentage offset for each telelescope in the validation set.
To change paramters of the neural networks, the trainingOptions function calls and layer matrices can be changed.

If you run into any problems or need more information on how to use this repo contact me via email or on github by opening an issue.


