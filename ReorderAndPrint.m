%
% Function: ret = ReorderAndPrint(i_mtx_filename, ofolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats)
%
%    This function reorders a matrix using the selected algorithm, and if
%    required, it views the output, saves the permutation vector and saves
%    the plot as a PNG image
%
% Required arguments: 
%    
%    i_mtx_filename - input Matrix Market filename
%
%    ofolder - the folder where the output files are saved
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
%
% Returned values: 
%
%    ret - 0 if success, -1 if the input file is unreachable, -2 if the
%          reordering algorithm is not supported, -3 if the file is not
%          matrix-market formatted
%
function ret = ReorderAndPrint(i_mtx_filename, ofolder, algorithm, field, precision, save_permutation_vector, do_not_show, do_not_print, get_stats)
  
  ret = 0;
  
  %% Check if the input file exists
  err = exist(i_mtx_filename);
    
  %% Check if the input file exists
  if(err == 0)
    ret = -1;
    error('The input file does not exist!\n');
  end
  
  if(strcmpi(algorithm, 'rcm') ~= 1 && strcmpi(algorithm, 'nd') ~= 1)
      ret = -2;
      error('The provided algorithm is not supported!\n');
  end
  
  %o_mtx_filename = extractBetween(i_mtx_filename, 1, strlength(str) - 4);
 
  [filepath, ifname, ext] = fileparts(i_mtx_filename);
  if(strcmpi(ext, '.mtx') ~= 1)
      ret = -3;
      error('The provided filename is not a matrix-market file!\n');
  end
  
  o_mtx_filename = strcat(ofolder, ifname, '_', algorithm,'.mtx');
   
  %% Invoke the RCM reordering function
  %% Reorder sparse matrix using RCM algorithm
  fprintf('Processing file: %s . . . . . . ', i_mtx_filename);
  tic;
  [A, A_ord, nz, pct, bw, bw_ord, p] = ReorderMarketMatrix (i_mtx_filename, o_mtx_filename, algorithm, field, precision, get_stats);
  elapsed_time = toc();

  fprintf('Done!\nMatrix reordering using %s took %f seconds.\n', algorithm, elapsed_time);
  fprintf('Statistics:\n\tNNZ: %d\n\tBW(perct): %e\n\tBW(in): %d\n\tBW(out): %d\n\n', nz, pct, bw, bw_ord);
   
  %% Save the permutation vector if required 
  %% For instance, the permutation vector can be used to reorder an RHS vector
  if (save_permutation_vector == 1)
      p_mtx_filename = strcat(ofolder, strrep(ifname, '.mtx', ''), '_p.mtx');
      fprintf('Saving permutation vector to file: %s . . . . . . ', p_mtx_filename);
      mmwrite(p_mtx_filename, p, '', 'real', 5);
      fprintf('Done!\n');
  end
  fprintf('\n');
  
  %% Plot the original and RCM-matrices side by side
  output_filename = strcat(ofolder, strrep(ifname, '.mtx', ''), '_', algorithm,'.png');
  ViewMatrixAfterReordering(A, A_ord, nz, pct, bw, bw_ord, algorithm, output_filename, do_not_show, do_not_print);
      
end