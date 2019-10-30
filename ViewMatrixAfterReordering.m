%
% Function: ret = ViewMatrixAfterReordering (A, A_ord, nz, pct, bw, bw_ord, algorithm, output_filename, do_not_show, do_not_print)
%
%    This function views two matrices side by side. It also shows the fill 
%    in percentage, number of non-zeros, and bandwidth of each matrix.
%
% Required arguments: 
%
%    A - first matrix
%
%    A_ord - reordered matrix
%
%    nz - number of non-zeros
%
%    pct - fill-in percentage
%
%    bw - bandwidth of the first matrix
%
%    bw_ord - bandwidth of the reordered matrix
%
%    output_filename - the PNG filename
%
%    do_not_show - a flag indicating whether the plot window is shown
%
%    do_not_print - a flag indicating whether the plot window is saved as a
%                   PNG file
%
%
% Returned values: 
%
%    ret - error code: 0  = success
%                      -1 = an exception occured
%
function ret = ViewMatrixAfterReordering (A, A_ord, nz, pct, bw, bw_ord, algorithm, output_filename, do_not_show, do_not_print)
  
  ret = 0;
  
  try
      %% Hide the plot if required
      if(do_not_show == 1)
          fh = figure();
      else
          fh = figure('visible', 'off');
      end

      %% Plot the original matrix
      subplot(1, 2, 1);
      spy(A);
      title(sprintf('Original (n=%d)', size(A, 2)));
      xlabel(sprintf('Nonzeros = %d (%.3f%%), BW=%d', nz, nz*pct, bw));

      %% Plot the reordered matrix
      subplot(1, 2, 2);
      spy(A_ord);
      title(sprintf('After Reordering (%s)', upper(algorithm)));
      xlabel(sprintf('Nonzeros = %d (%.3f%%), BW=%d', nz, nz*pct, bw_ord));

      %% Save as a PNG image if required
      if(do_not_print == 1)
         print(fh, '-dpng', output_filename, '-r200');
         fprintf('Plot saved as image in the file %s\n', output_filename);
      end
      
      %% Close the figure if not to be shown
      if(do_not_show ~= 1)
           close(fh);
      end
      
  catch ME
      ret = -1;
      error('An exception occured: %s\n', ME.identifier);
  end
  
end
