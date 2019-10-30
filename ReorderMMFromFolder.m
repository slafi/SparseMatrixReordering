%
% Function: [ret] = ReorderMMFromFolder (ifolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats)
%
%    Reads a sparse matrix A from a Matrix Market (MM)-formatted file, 
%    applies Reverse Cuthill-McKee reordoering to it and writes it to 
%    an output MM file. It also can optionnally return few statistics 
%    about both matrices.
%
% Required arguments: 
%    
%    ifolder - the folder where the MM files are stored
%
%    algorithm - 'rcm'
%                'nd'
%
%    field     - 'real'
%                'complex'
%                'integer'
%                'pattern'
%                If ommitted, data will determine type.
%
%    precision - number of digits to display for real 
%                or complex values
%                If ommitted, full working precision is used.
%
%    save_permutation_vector - a flag which indicates if the permutation
%                              vector is saved in an output file
%                              (1: save, otherwise: do not save)
%
%    do_not_show - a flag which indicates if the plot figure is shown
%                  (1: show, otherwise: do not show)
%
%    do_not_print - a flag which indicates if the plot is saved as a PNG
%                   image (1: save, otherwise: do not save)
%
%    get_stats - A flag which determines if the statistics will be
%                computed for both matrices
%
% Returned values:
%
%    ret - return code: 
%                   0: success, 
%                   -1: folder not found
%                   -2: no matrix market files found
%                   -3: folder could not be created
%
function [ret] = ReorderMMFromFolder (ifolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats)
    
    ret = 0;
    %% Check if the folder exists
    err = exist(ifolder);
    
    %% Check if the folder exists
    if(err == 0)
        ret = -1;
    	error('The folder does not exist!\n');
    end
    
    folder = char(ifolder);
    
    %% substr for compatibility with GNU Octave, endswith can be used on Matlab
    if((folder(length(folder)-1) == '/') || (folder(length(folder)-1) == '\'))
      pattern = strcat (ifolder, '*.mtx');
      lfolder = ifolder;
    else
      pattern = strcat (ifolder , '/*.mtx');
      lfolder = strcat (ifolder, '/');
    end
    
    ofolder = strcat (lfolder, 'Output/');      %% output folder
    
    %% Check if market files are available in the folder
    listing = struct2cell(dir(pattern));
    
    files = (listing(1,:));
    
    err = isempty(files);
    if(err == 1)
        ret = -2;
        error('The folder does not contain any market matrix files!\n');      
    end
    
    %% Create output directory    
    err = mkdir(ofolder);
    if(err == 0)        
        ret = -3;
    	error('The output folder %s could not be created!\n', ofolder);     
    end
    
    %% reorder and save each market matrix file    
    for i=1:1:length(files)
        
      % Get the next MTX filename
      file = files{i};
      
      % Create the full filename and path
      i_mtx_filename = strcat(lfolder, file);
      
      %% Reorder the sparse matrix
      ret = ReorderAndPrint(i_mtx_filename, ofolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats);

    end
    
end