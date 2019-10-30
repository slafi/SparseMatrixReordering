%
% Function: path = GetScriptFolderFromName(filename)
%
%    This function returns the full path given the script filename.
%
% Required arguments: 
%
%    filename - script filename
%
% Returned values: 
%
%    path - the script parent folder path
%
function path = GetScriptFolderFromName(filename)
  
  script_dir = which(filename);
  script_dir = char(script_dir);

  i = length(script_dir);
  found = 0;
  while (i >= 1 && (found == 0))
    
    if(script_dir(i) == '/' || script_dir(i) == '\')
      found = 1;
    else
      script_dir(i) = '';
      i = i - 1;
    end
    
  end
  
  path = script_dir;
  
end
