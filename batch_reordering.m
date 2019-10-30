clear;
close all;
clc;
format short;

%% Initialize parameters
algorithm = 'rcm';
field = 'real'; 
precision = 5;
save_permutation_vector = 1;
do_not_show = 0;
get_stats = 1;
do_not_print = 1;

%% Adjust Octave file path to start in the current directory
script_dir = GetScriptFolderFromName('batch_reordering');
cd(script_dir);
cur_dir = pwd();

%% Add NIST functions directory to Octave path
addpath('./NIST_functions');

%% Specify the folder where the Matrix Market files are stored
folder = './data/nist';

%% Invoke batch reordering function to process files one by one
ret = ReorderMMFromFolder(folder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats);
