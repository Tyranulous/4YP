# 4YP
Scripts and data for my final year project and SC21 submission.

_NOTE: This software requires MATLAB with the Deep Learning and Statistics and Machine Learning toolboxes to run._

## Dataset

The dataset is contained on the *data* branch.
This is the raw data that was generated and saved immediately after performing the auto-tune analysis. 
This is found in the HPCAI.Data folder, each subfolder of which indicates a different method of choosing input parameters.
The data is very raw, so for use must be interpreted and inputted programmatically.
MATLAB functions and scripts which do this can be found in the *matlab* branch, or if analysis is to be performed in a different language 
Due to the raw and somewhat badly labelled nature of these data, it is recommended that they aren't used in their raw state but that you use the scripts provided.
Additionally, some subsection of the results are broken but kept for reference and future investigation into why. 
If the *matlab* branch is used, the erroneous data has been removed already.


## Scripts

To run scripts, change to the _matlab_ branch.
All of the scripts and data used for submission to SC21 are contained within the [HPCAI.Data/2080ti_random_pertebation](https://github.com/Tyranulous/4YP/tree/matlab/HPCAI.Data/2080ti_random_dm_pertebation) and [HPCAI.Data/shared_scripts](https://github.com/Tyranulous/4YP/tree/matlab/HPCAI.Data/shared_scripts) folders.
To run them, you  must open the 2080ti_random_dm_pertebation folder in MATLAB and run the dataimporter.m script. 
_(note for this to work on your computer a hardcoded paths will need to be changed so MATLAB can find the rights scripts)._
This goes through all the subfolders (indicating distinct times astro-accelerate ran) and records the data into a structure called datain.
Each record of datain represents one telescope.

To use the MATLAB regression learner on the data, the features must be extracted from datain.
First to split the dataset into a training and validation set run:

    [training_datain, validation_datain] = holdback(datain,p);

This randomly selects *p* percent of the datain provided to be put into a new datain structure called validation_datain and the rest to a training_datain struct.
Next data is extracted into a table.
This is done by running:

    [full_table,reduced_table,~] = combined_feature_tabler(datain);

Where datain can be changed to be the training data and/or validation data.

Now the MATLAB Regression learner can be run on the resultant table.
The regression learner provides a GUI for running some standard models on the data, with options for chaning hyper parameters, this is how the trees based models were created.
You can select what model you want to train, specify hyper parameters, and train.
It will then plot various graphs for you giving an insight into what the model is doing.
These models can then be exported for prediction.


## Neural Networks

The training of neural networks is defined in the *multi_classif_notlive.m* script.
This is a self contained script which, when run, will train multiple neural network models to predict parameter sets.
It will train the models, and then output some performance metrics for the various models along with plotting the percentage offset for each telescope in the validation set.
To change parameters of the neural networks, the trainingOptions function calls and layer matrices can be changed.

When the script is ran it will create neural networks exactly as used in the paper, however if you want to configure this yourself it is relatively simple to change parameters.

To train them, features and responses for both validation and training set are encoded into a matrix which can be read by the Deep Learning Toolbox functions.
A network is specified by making a vector of layer definitions indicating layer type, number of nodes, and any other parameters that may be associated with the layer (such as dropout probability when using dropout).
To change other network specifics such as optimisation algorithm, hyper parameter selection, and early stopping criteria, the values to calls to trainingOptions must be changed.
MATLAB then trains the NN in question.

Predictions are handled by calls to several other functions depending on the prediction scheme.
For Regression alone, use the *just_nn_predictor.m* functions.
For combinations of classification and regression use *combined_predictor.m* and *combined_predictor2.m* for binary classification and multi class classification respectively.
These output a list of locations of predicted optimal parameter sets in the form of numbers between 1 and 275 each of which correspond to one of the 275 parameter sets, selected in the order which they appear in the chans-profile.txt.
This list can be passed to other functions which can extract the real world performance metrics from them and plot various graphs or provide statistics:
    
    location_plotter(predictions,validation_datain,'plot_name');
    location_statter(predictions,validation_datain);
   
If you want to extract the percentage data for analysis in a different program, you can use the _data_extractor.m_ file which takes as input the list of locations and datain file and returns the corresponding percentage offset.

## 


If you run into any problems or need more information on how to use this repo contact me via email or open an issue.


