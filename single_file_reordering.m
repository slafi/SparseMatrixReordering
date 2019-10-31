clear;
close all;
clc;
format long e;

% Initialize parameters
algorithm = 'rcm';
field = 'real'; 
precision = 5;
save_permutation_vector = 1;
do_not_show = 1;
get_stats = 1;
do_not_print = 1;

%% File paths
i_mtx_filename = 'data\NIST\bcsstk17.mtx';
ofolder = 'data\NIST\Output\';

%% Get script's folder path
cur_dir = GetScriptFolderFromName('single_file_reordering.m');

%% Add NIST functions directory to path
i_mtx_filename = strcat(cur_dir, i_mtx_filename);

%% Reorder sparse matrix
ret = ReorderAndPrint(i_mtx_filename, ofolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats);
