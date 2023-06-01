function jObject = java_create(objClass, objProto, varargin)
% JAVA_CREATE: Create a Java Swing object in the best possible way with the current Matlab version

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2018 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Francois Tadel, 2013

% Parse inputs
if (nargin < 2)
    objProto = [];
    nParam = 0;
else
    nParam = length(varargin);
end
% Call the creation with the latest available function
if exist('javaObjectEDT', 'builtin')
    if (nParam == 0)
        jObject = javaObjectEDT(objClass);
    else
        jObject = javaObjectEDT(objClass, varargin{:});
    end
else
    if (nParam == 0)
        jObject = awtcreate(objClass);
    else
        jObject = awtcreate(objClass, objProto, varargin{:});
    end
end



