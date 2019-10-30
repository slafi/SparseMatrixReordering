%
% Function: [A, A_ord, nz, pct, bw, bw_ord, p] = ReorderMarketMatrix (i_mtx_filename, o_mtx_filename, algorithm, field, precision, get_stats)
%
%    Reads a sparse matrix A from a Matrix Market (MM)-formatted file, 
%    applies either Reverse Cuthill-McKee or Nested Dissection reordoering 
%    to it and writes it to an output MM file. It also can optionnally 
%    return few statistics about both matrices.
%
% Required arguments: 
%
%    i_mtx_filename - input MM filename
%
%    o_mtx_filename - output MM filename
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
%    get_stats - A flag which determines if the statistics
%                will be computed for both matrices
%
% Returned values:
%
%
%    A - the input sparse matrix
%                      
%    A_ord - the output sparse matrix
% 
%    nz - the number of matrix non-zeros
%
%    pct - the percentage of non-zeros
% 
%    bw - the bandwidth of the input matrix
%         
%    bw_ord - the bandwidth of the reordered matrix
%
%    p - permutation array
%
% Disclaimer: This function uses mmread() and mmwrite() provided by the NIST as part of the
%             MatrixMarket I/O Functions for Matlab 
%             For more information, see: https://math.nist.gov/MatrixMarket/mmio/matlab/mmiomatlab.html
%
function [A, A_ord, nz, pct, bw, bw_ord, p] = ReorderMarketMatrix (i_mtx_filename, o_mtx_filename, algorithm, field, precision, get_stats)
  
    %% Initialize stats parameters
    nz = -1;
    pct = -1;
    bw = -1;
    bw_ord = -1;
    A = [];
    A_ord = [];
    
    %% Check if the input file already exists
    err = exist(i_mtx_filename);
    
    if(err == 0)
      error('The file %s does not exist', i_mtx_filename);
    end
    
    %% Check if the input file already exists
    if(strcmpi(algorithm, 'rcm') == 0 && strcmpi(algorithm, 'nd') == 0)
      error('The reordering algorithm (%s) is invalid', algorithm);
    end
    
    %% Read sparse matrix file (matrix market format)
    [A, rows, cols, entries, rep, field_r, symm] = mmread(i_mtx_filename);
    
    %% Reordering
    err = 0;
    if(strcmpi(algorithm, 'rcm') == 1)
        %% Reorder sparse matrix using reverse Cuthill-McKee algorithm
        p = symrcm(A);
    elseif(strcmpi(algorithm, 'nd') == 1)
        %% Reorder sparse matrix using Nested Dissection algorithm
        p = dissect(A);
    else
        err = 1;
    end
    
    if(err == 0)
        %% Apply permutation to original matrix
        A_ord = A(p, p);
    
        %% Read sparse matrix file (matrix market format)
        comment = sprintf('Created on %s', datestr(now));

        mmwrite(o_mtx_filename, A_ord, comment, field, precision);

        %% Compute statistics 
        if(get_stats == 1)

          %% Percentage of fill
          pct = 100 / numel(A);

          %% Number of non-zeros
          nz = nnz(A);

          %% Input matrix bandwidth
          [i, j] = find(A);
          bw = max(i-j) + 1;

          %% Output matrix bandwidth
          [i, j] = find(A_ord);
          bw_ord = max(i-j) + 1;

        end
    end  
    
end