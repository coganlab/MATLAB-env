function [ iDepStudies, iDepItems, targetNodeType ] = tree_dependencies( bstNodes, targetNodeType, NodelistOptions, GetBadTrials )
% TREE_DEPENDENCIES: Get all the data or results files that depend on the input nodes.
%
% USAGE:  [ iDepStudies, iDepItems, targetNodeType ] = tree_dependencies( bstNodes, targetNodeType, NodelistOptions, GetBadTrials )
%         [ iDepStudies, iDepItems, targetNodeType ] = tree_dependencies( bstNodes, targetNodeType, NodelistOptions )
%         [ iDepStudies, iDepItems, targetNodeType ] = tree_dependencies( bstNodes, targetNodeType )
%
% INPUT:
%     - bstNodes       : Array of BstNode
%     - targetNodeType : {'data', 'results', 'pdata', 'presults','ptimefreq','pspectrum', 'pmatrix', 'raw', 'rawcondition', 'matrix', 'any'}
%     - NodelistOptions: Structure to filter the files by name or comment
%     - GetBadTrials   : If 1, get all the data files (default)
%                        If 0, get only the data files that are NOT marked as bad trials 
%
% OUTPUT:
%     - iDepStudies     : Indices of the studies that were found
%     - iDepItems       : Indices of the data or results files, in each study
%     - targetNodeType  : Data type that is selected in the case of "any" nodetype

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
% Authors: Francois Tadel, 2008-2013

% Parse inputs
if (nargin < 3) || isempty(NodelistOptions)
    NodelistOptions = [];
end
if (nargin < 4) || isempty(GetBadTrials)
    GetBadTrials = 1;
end

% Get all nodes descriptions
for i = 1:length(bstNodes)
    nodeTypes{i}     = char(bstNodes(i).getType());
    nodeStudies(i)   = bstNodes(i).getStudyIndex();
    nodeSubItems(i)  = bstNodes(i).getItemIndex();
    nodeFileNames{i} = char(bstNodes(i).getFileName());
    nodeComments{i}  = char(bstNodes(i).getComment());
end

% Auto-detect data type: use first node
if strcmpi(targetNodeType, 'any') && (length(bstNodes) >= 1)
    switch (lower(nodeTypes{1}))
        case {'data', 'rawdata', 'datalist'}
            targetNodeType = 'data';
        case {'results', 'link'}
            targetNodeType = 'results';
        case {'timefreq', 'spectrum'}
            targetNodeType = 'timefreq';
        case {'ptimefreq', 'pspectrum'}
            targetNodeType = 'ptimefreq';
        case {'matrix', 'matrixlist'}
            targetNodeType = 'matrix';
        case {'pdata', 'presults', 'dipoles', 'pmatrix'}
            targetNodeType = lower(nodeTypes{1});
        otherwise
            iDepStudies = [];
            iDepItems = [];
            targetNodeType = 'none';
            return;
    end
end

% Pre-process file filters
if ~isempty(NodelistOptions)
    % If nothing entered
    if isempty(NodelistOptions.String) || isempty(strtrim(NodelistOptions.String))
        NodelistOptions = [];
    else
        % Options
        NodelistOptions.isSelect  = strcmpi(NodelistOptions.Action, 'Select');
        % Make search case insensitive
        NodelistOptions.String = lower(NodelistOptions.String);
        % Create filter eval expression
        NodelistOptions.Eval = CreateFilterEvalExpression(NodelistOptions.String);
    end
end

% Capture selection errors
try
    % Define target studies
    iTargetStudies = [];
    iDepStudies = [];
    iDepItems   = [];
    % Process all the selected nodes
    for iNode = 1:length(bstNodes)
        % Process all the studies of this node
        switch (lower(nodeTypes{iNode}))
            % ==== DATABASE ====
            case {'studydbsubj', 'studydbcond'}
                % Get the whole database
                ProtocolSubjects = bst_get('ProtocolSubjects');
                % Get list of subjects (sorted alphabetically => same order as in the tree)
                [uniqueSubjects, iUniqueSubjects] = sort({ProtocolSubjects.Subject.Name});
                % Add inter-subject node
                iTargetStudies = [iTargetStudies, -2];
                % Process each subject
                for iSubj = 1:length(uniqueSubjects)
                    % Get subject filename
                    iSubject = iUniqueSubjects(iSubj);
                    SubjectFile = ProtocolSubjects.Subject(iSubject).FileName;
                    % Get all the studies for this subject
                    [sStudies, iStudies] = bst_get('StudyWithSubject', SubjectFile, 'intra_subject');
                    iTargetStudies = [iTargetStudies, iStudies];
                end

            % ==== SUBJECT ====
            case 'studysubject'
                % If directory (in subject/condition display, StudyIndex = 0)
                if (nodeStudies(iNode) == 0)
                    % Get all the studies related to this subject
                    [sStudies, iStudies] = bst_get('StudyWithSubject', nodeFileNames{iNode}, 'intra_subject');
                    iTargetStudies = [iTargetStudies, iStudies];
                % Else : study node (in condition/subject display, StudyIndex = 0)
                else
                    % Just add the study
                    iTargetStudies = [iTargetStudies, nodeStudies(iNode)];
                end

            % ==== STUDY ====
            case {'study', 'defaultstudy'}
                % Intra-subject node in display by condition: Treat as a condition
                if (nodeStudies(iNode) == 0)
                    [sStudies, iStudies] = bst_get('StudyWithCondition', nodeFileNames{iNode});
                    iTargetStudies = [iTargetStudies, iStudies];
                % Else: regular study
                else
                    % Just add the study
                    iTargetStudies = [iTargetStudies, nodeStudies(iNode)];
                end
            % ==== CONDITION ====
            case {'condition', 'rawcondition'}
                % Get all the studies related with the condition name
                [sStudies, iStudies] = bst_get('StudyWithCondition', nodeFileNames{iNode});
                iTargetStudies = [iTargetStudies, iStudies];

            % ==== HEADMODEL ====
            case 'headmodel'
                % If looking for headmodel in headmodel, return headmodel
                if strcmpi(targetNodeType, 'headmodel')
                     iTargetStudies = [iTargetStudies, nodeStudies(iNode)];
                end

            % ==== DATA ====
            case {'data', 'rawdata'}
                iStudy = nodeStudies(iNode);
                % Check for bad trials
                if ~GetBadTrials
                    % Get study
                    [sStudy, tmp__, iData] = bst_get('DataFile', nodeFileNames{iNode}, iStudy);
                    % Ignore bad trials
                    if sStudy.Data(iData).BadTrial
                        continue;
                    end
                end
                % Items to include depend on the node type to include
                switch lower(targetNodeType)
                    case 'data'
                        % Check search options
                        if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions);
                            continue;
                        end
                        % Include the selected data nodes
                        iDepStudies = [iDepStudies nodeStudies(iNode)];
                        iDepItems   = [iDepItems   nodeSubItems(iNode)];

                    case 'results'
                        % Find the results associated with this data node
                        [sStudy, tmp_, iFoundResults] = bst_get('ResultsForDataFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundResults) && ~isempty(sStudy.Result(iFoundResults))
                            ResultsFiles = {sStudy.Result(iFoundResults).FileName};
                            ResultsComments = {sStudy.Result(iFoundResults).Comment};
                            % The results that were found
                            if ~isempty(iFoundResults)
                                % === Check file filters ===
                                if ~isempty(NodelistOptions)
                                    iFoundResults = iFoundResults(isFileSelected(ResultsFiles, ResultsComments, NodelistOptions, iStudy));
                                end
                                iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundResults))];
                                iDepItems   = [iDepItems iFoundResults];
                            end
                        end

                    case 'timefreq'
                        iStudy = nodeStudies(iNode);
                        % Find the results associated with this data node
                        [sStudy, tmp_, iFoundTf] = bst_get('TimefreqForFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundTf) && ~isempty(sStudy.Timefreq(iFoundTf))
                            TimefreqFiles = {sStudy.Timefreq(iFoundTf).FileName};
                            TimefreqComments = {sStudy.Timefreq(iFoundTf).Comment};                            
                            % The files that were found
                            if ~isempty(iFoundTf)
                                % === Check file filters ===
                                if ~isempty(NodelistOptions)
                                    iFoundTf = iFoundTf(isFileSelected(TimefreqFiles, TimefreqComments, NodelistOptions));
                                end
                                iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundTf))];
                                iDepItems   = [iDepItems iFoundTf];
                            end
                        end

                    case 'dipoles'
                        iStudy = nodeStudies(iNode);
                        % Find the files associated with this data node
                        [sStudy, tmp_, iFoundDip] = bst_get('DipolesForFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundDip) && ~isempty(sStudy.Dipoles(iFoundDip))
                            DipolesFiles = {sStudy.Dipoles(iFoundDip).FileName};
                            DipolesComments = {sStudy.Dipoles(iFoundDip).Comment};                            
                            % The files that were found
                            if ~isempty(iFoundDip)
                                % === Check file filters ===
                                if ~isempty(NodelistOptions)
                                    iFoundDip = iFoundDip(isFileSelected(DipolesFiles, DipolesComments, NodelistOptions));
                                end
                                iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundDip))];
                                iDepItems   = [iDepItems iFoundDip];
                            end
                        end
                end

            % ==== DATA LIST ====
            case 'datalist'
                % Get selected study
                iStudy = nodeStudies(iNode);
                sStudy = bst_get('Study', iStudy);
                if isempty(sStudy)
                    continue;
                end
                % Get all the data files held by this datalist
                iFoundData = bst_get('DataForDataList', iStudy, nodeFileNames{iNode});
                % Remove bad trials
                if ~GetBadTrials
                    iFoundData = iFoundData([sStudy.Data(iFoundData).BadTrial] == 0);
                end
                % If some files were found
                if ~isempty(iFoundData)
                    % Items to include depend on the node type to include
                    switch lower(targetNodeType)
                        case 'data'
                            % === Check file filters ===
                            FoundDataFiles = {sStudy.Data(iFoundData).FileName};
                            FoundDataComments = {sStudy.Data(iFoundData).Comment};
                            if ~isempty(NodelistOptions)
                                iFoundData = iFoundData(isFileSelected(FoundDataFiles, FoundDataComments, NodelistOptions));
                            end
                            iDepItems = [iDepItems, iFoundData];
                            iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundData))];

                        case 'results'
                            iResWithData = find(~cellfun(@isempty, {sStudy.Result.DataFile}));
                            if ~isempty(iResWithData)
                                for id = 1:length(iFoundData)
                                    iData = iFoundData(id);
                                    % Find the results associated with this data node
                                    %[tmp_, tmp_, iFoundResults] = bst_get('ResultsForDataFile', sStudy.Data(iData).FileName, iStudy);
                                    iFoundResults = iResWithData(file_compare(sStudy.Data(iData).FileName, {sStudy.Result(iResWithData).DataFile}));
                                    ResultsFiles = {sStudy.Result(iFoundResults).FileName};
                                    ResultsComment = {sStudy.Result(iFoundResults).Comment};
                                    % The results that were found
                                    if ~isempty(iFoundResults)
                                        % === Check file filters ===
                                        if ~isempty(NodelistOptions)
                                            iFoundResults = iFoundResults(isFileSelected(ResultsFiles, ResultsComment, NodelistOptions, iStudy));
                                        end
                                        iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundResults))];
                                        iDepItems   = [iDepItems iFoundResults];
                                    end
                                end
                            end

                        case 'timefreq'
                            for id = 1:length(iFoundData)
                                iData = iFoundData(id);
                                % Find the files associated with this data node
                                [tmp_, tmp_, iFoundTf] = bst_get('TimefreqForFile', sStudy.Data(iData).FileName, iStudy);
                                TimefreqFiles = {sStudy.Timefreq(iFoundTf).FileName};
                                TimefreqComments = {sStudy.Timefreq(iFoundTf).Comment};
                                % The files that were found
                                if ~isempty(iFoundTf)
                                    % === Check file filters ===
                                    if ~isempty(NodelistOptions)
                                        iFoundTf = iFoundTf(isFileSelected(TimefreqFiles, TimefreqComments, NodelistOptions));
                                    end
                                    iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundTf))];
                                    iDepItems   = [iDepItems iFoundTf];
                                end
                            end

                        case 'dipoles'
                            for id = 1:length(iFoundData)
                                iData = iFoundData(id);
                                % Find the files associated with this data node
                                [tmp_, tmp_, iFoundDip] = bst_get('DipolesForFile', sStudy.Data(iData).FileName, iStudy);
                                DipolesFiles = {sStudy.Dipoles(iFoundDip).FileName};
                                DipolesComments = {sStudy.Dipoles(iFoundDip).Comment};
                                % The files that were found
                                if ~isempty(iFoundDip)
                                    % === Check file filters ===
                                    if ~isempty(NodelistOptions)
                                        iFoundDip = iFoundDip(isFileSelected(DipolesFiles, DipolesComments, NodelistOptions));
                                    end
                                    iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundDip))];
                                    iDepItems   = [iDepItems iFoundDip];
                                end
                            end
                    end
                end

            % ==== RESULTS ====
            case {'results', 'link'}
                % Items to include depend on the node type to include
                switch lower(targetNodeType)
                    case 'data'
                        % Nothing to include
                    case 'results'
                        % Get selected study
                        iStudy = nodeStudies(iNode);
                        sStudy = bst_get('Study', iStudy);
                        if isempty(sStudy)
                            continue;
                        end
                        iResult = nodeSubItems(iNode);
                        fileName = nodeFileNames{iNode};
                        fileComment = nodeComments{iNode};
                        % If results is not a shared kernel (not attached to a datafile)
                        if ~isPureKernel(sStudy.Result(iResult)) 
                            if isempty(NodelistOptions) || isFileSelected(fileName, fileComment, NodelistOptions, iStudy)
                                % Include results list
                                iDepStudies = [iDepStudies iStudy];
                                iDepItems   = [iDepItems   iResult];
                            end
                        end
                    case 'timefreq'
                        iStudy = nodeStudies(iNode);
                        % Find the results associated with this data node
                        [sStudy, tmp_, iFoundTf] = bst_get('TimefreqForFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundTf) && ~isempty(sStudy.Timefreq(iFoundTf))
                            TimefreqFiles = {sStudy.Timefreq(iFoundTf).FileName};
                            TimefreqComments = {sStudy.Timefreq(iFoundTf).Comment};
                            % The files that were found
                            if ~isempty(iFoundTf)
                                % === Check file filters ===
                                if ~isempty(NodelistOptions)
                                    iFoundTf = iFoundTf(isFileSelected(TimefreqFiles, TimefreqComments, NodelistOptions));
                                end
                                iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundTf))];
                                iDepItems   = [iDepItems iFoundTf];
                            end
                        end
                    case 'dipoles'
                        iStudy = nodeStudies(iNode);
                        % Find the file associated with this data node
                        [sStudy, tmp_, iFoundDip] = bst_get('DipolesForFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundDip) && ~isempty(sStudy.Dipoles(iFoundDip))
                            DipolesFiles = {sStudy.Dipoles(iFoundDip).FileName};
                            DipolesComments = {sStudy.Dipoles(iFoundDip).Comment};
                            % The files that were found
                            if ~isempty(iFoundDip)
                                % === Check file filters ===
                                if ~isempty(NodelistOptions)
                                    iFoundDip = iFoundDip(isFileSelected(DipolesFiles, DipolesComments, NodelistOptions));
                                end
                                iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundDip))];
                                iDepItems   = [iDepItems iFoundDip];
                            end
                        end
                end

            % ==== TIMEFREQ ====
            case {'timefreq', 'spectrum'}
                % Get file
                if strcmpi(targetNodeType, 'timefreq')
                    % Check search options
                    if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions);
                        continue;
                    end
                    iDepStudies = [iDepStudies nodeStudies(iNode)];
                    iDepItems   = [iDepItems   nodeSubItems(iNode)];
                end

            % ==== STAT: TIMEFREQ ====
            case {'ptimefreq', 'pspectrum'}
                % Get file
                if strcmpi(targetNodeType, 'ptimefreq')
                    % Check search options
                    if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions);
                        continue;
                    end
                    iDepStudies = [iDepStudies nodeStudies(iNode)];
                    iDepItems   = [iDepItems   nodeSubItems(iNode)];
                end
                
            % ==== STAT: OTHER ====
            case {'pdata', 'presults', 'pmatrix'}
                if strcmpi(targetNodeType, nodeTypes{iNode})
                    % Check search options
                    if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions);
                        continue;
                    end
                    iDepStudies = [iDepStudies nodeStudies(iNode)];
                    iDepItems   = [iDepItems   nodeSubItems(iNode)];
                end
                
            % ==== DIPOLES ====
            case 'dipoles'
                if strcmpi(targetNodeType, nodeTypes{iNode})
                    % Check search options
                    if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions);
                        continue;
                    end
                    iDepStudies = [iDepStudies nodeStudies(iNode)];
                    iDepItems   = [iDepItems   nodeSubItems(iNode)];
                end
                
            % ==== MATRIX ====
            case 'matrix'
                % Get file
                switch lower(targetNodeType)
                    case 'matrix'
                        % Check file filters
                        if ~isempty(NodelistOptions) && ~isFileSelected(nodeFileNames{iNode}, nodeComments{iNode}, NodelistOptions)
                            continue;
                        end
                        % Include the selected data node
                        iDepStudies = [iDepStudies nodeStudies(iNode)];
                        iDepItems   = [iDepItems   nodeSubItems(iNode)];
                        
                    case 'timefreq'
                        iStudy = nodeStudies(iNode);
                        % Find the results associated with this data node
                        [sStudy, tmp_, iFoundTf] = bst_get('TimefreqForFile', nodeFileNames{iNode}, iStudy);
                        if ~isempty(iFoundTf) && ~isempty(sStudy.Timefreq(iFoundTf))
                            TimefreqFiles = {sStudy.Timefreq(iFoundTf).FileName};
                            TimefreqComments = {sStudy.Timefreq(iFoundTf).Comment};
                            % === Check file filters ===
                            if ~isempty(NodelistOptions)
                                iFoundTf = iFoundTf(isFileSelected(TimefreqFiles, TimefreqComments, NodelistOptions));
                            end
                            iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundTf))];
                            iDepItems   = [iDepItems iFoundTf];
                        end
                end

            % ==== MATRIX LIST ====
            case 'matrixlist'
                % Get selected study
                iStudy = nodeStudies(iNode);
                sStudy = bst_get('Study', iStudy);
                if isempty(sStudy)
                    continue;
                end
                % Get all the matrix files held by this matrixlist
                iFoundMatrix = bst_get('MatrixForMatrixList', iStudy, nodeFileNames{iNode});
                % If some files were found
                if ~isempty(iFoundMatrix)
                    % Items to include depend on the node type to include
                    switch lower(targetNodeType)
                        case 'matrix'
                            % === Check file filters ===
                            FoundMatrixFiles = {sStudy.Matrix(iFoundMatrix).FileName};
                            FoundMatrixComments = {sStudy.Matrix(iFoundMatrix).Comment};
                            if ~isempty(NodelistOptions)
                                iFoundMatrix = iFoundMatrix(isFileSelected(FoundMatrixFiles, FoundMatrixComments, NodelistOptions));
                            end
                            iDepItems = [iDepItems, iFoundMatrix];
                            iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundMatrix))];

                        case 'timefreq'
                            for id = 1:length(iFoundMatrix)
                                iMatrix = iFoundMatrix(id);
                                % Find the files associated with this data node
                                [tmp_, tmp_, iFoundTf] = bst_get('TimefreqForFile', sStudy.Matrix(iMatrix).FileName, iStudy);
                                TimefreqFiles = {sStudy.Timefreq(iFoundTf).FileName};
                                TimefreqComments = {sStudy.Timefreq(iFoundTf).Comment};
                                % The files that were found
                                if ~isempty(iFoundTf)
                                    % === Check file filters ===
                                    if ~isempty(NodelistOptions)
                                        iFoundTf = iFoundTf(isFileSelected(TimefreqFiles, TimefreqComments, NodelistOptions));
                                    end
                                    iDepStudies = [iDepStudies, repmat(iStudy, size(iFoundTf))];
                                    iDepItems   = [iDepItems iFoundTf];
                                end
                            end
                    end
                end
        end
    end
catch
    iDepStudies = -10;
    iDepItems = -10;
    return;
end

% If studies were found => Select all the data files in these studies
if ~isempty(iTargetStudies)
    iStudies = iTargetStudies;
    sStudies = bst_get('Study', iStudies);
    for i = 1:length(iStudies)
        % Items to include depend on the node type to include
        switch lower(targetNodeType)
            case 'data'
                % Remove bad trials
                if ~GetBadTrials
                    iFoundData = find([sStudies(i).Data.BadTrial] == 0);
                else
                    iFoundData = 1:length(sStudies(i).Data);
                end
                % Add data files to list
                if ~isempty(iFoundData)
                    % Check file filters
                    if ~isempty(NodelistOptions)
                        iFoundData = iFoundData(isFileSelected({sStudies(i).Data(iFoundData).FileName}, {sStudies(i).Data(iFoundData).Comment}, NodelistOptions));
                    end
                    iDepStudies = [iDepStudies, repmat(iStudies(i), 1, length(iFoundData))];
                    iDepItems   = [iDepItems,   iFoundData];
                end

            case 'results'
                % Get all results of this study that ARE NOT SHARED KERNELS (imaging kernel not attched to a datafile)
                % === Check file filters ===
                ResultsFiles = {sStudies(i).Result.FileName};
                ResultsComments = {sStudies(i).Result.Comment};
                if ~isempty(ResultsFiles)
                    % Get non-pure kernels + Check file filters
                    if ~isempty(NodelistOptions)
                        iValidResult = find(~isPureKernel(sStudies(i).Result) & isFileSelected(ResultsFiles, ResultsComments, NodelistOptions, iStudies(i)));
                    else
                        iValidResult = find(~isPureKernel(sStudies(i).Result));
                    end
                    % Remove bad trials
                    if ~GetBadTrials
                        isBadData = logical([sStudies(i).Data.BadTrial]);
                        isBadRes = zeros(size(iValidResult));
                        % Check file by file
                        for iRes = 1:length(iValidResult)
                            if ~isempty(sStudies(i).Result(iValidResult(iRes)).DataFile)
                                % Get the associated data file in bad trials
                                isBadRes(iRes) = any(file_compare(sStudies(i).Result(iValidResult(iRes)).DataFile, {sStudies(i).Data(isBadData).FileName}));
                            end
                        end
                        % Remove all the detected bad trials
                        iValidResult = iValidResult(~isBadRes);
                    end
                    % Return selected files
                    if ~isempty(iValidResult)
                        % Add valid results files
                        iDepStudies = [iDepStudies, repmat(iStudies(i), 1, length(iValidResult))];
                        iDepItems   = [iDepItems,   iValidResult];
                    end
                end
                
            case 'timefreq'
                % Get all timefreq files of this study
                if ~isempty(sStudies(i).Timefreq)
                    % Check file filters
                    if ~isempty(NodelistOptions)
                        PossibleFiles = {sStudies(i).Timefreq.FileName};
                        PossibleComments = {sStudies(i).Timefreq.Comment};
                        iFoundTf = find(isFileSelected(PossibleFiles, PossibleComments, NodelistOptions));
                    else
                        iFoundTf = 1:length(sStudies(i).Timefreq);
                    end
                    % Remove bad trials
                    if ~GetBadTrials
                        iBadTrial = zeros(size(iFoundTf));
                        % Check file by file
                        for iTf = 1:length(iFoundTf)
                            % Get DataFile
                            DataFile = sStudies(i).Timefreq(iTf).DataFile;
                            if isempty(DataFile)
                                continue;
                            end
                            DataType = file_gettype(DataFile);
                            % Time-freq on results: get DataFile
                            if ismember(DataType, {'results','link'})
                                [tmp__,tmp__,iRes] = bst_get('ResultsFile', DataFile, iStudies(i));
                                if ~isempty(iRes)
                                    DataFile = sStudies(i).Result(iRes).DataFile;
                                else
                                    DataFile = [];
                                end
                            % Time-freq on results: get DataFile
                            elseif strcmpi(DataType, 'matrix')
                                DataFile = [];
                            end
                            % Check if bad trials
                            if ~isempty(DataFile)
                                % Get the associated data file
                                [tmp__,tmp__,iData] = bst_get('DataFile', DataFile, iStudies(i));
                                % In the case of projected sources: the source file might not be in the same folder
                                if isempty(iData)
                                    [sStudy_tmp,iStudy_tmp,iData] = bst_get('DataFile', DataFile);
                                    iBadTrial(iTf) = sStudy_tmp.Data(iData).BadTrial;
                                else
                                    % Check if data file is bad
                                    iBadTrial(iTf) = sStudies(i).Data(iData).BadTrial;
                                end
                            end
                        end
                        % Remove all the detected bad trials
                        iFoundTf = iFoundTf(~iBadTrial);
                    end
                    % Add data files to list
                    if ~isempty(iFoundTf)
                        iDepStudies = [iDepStudies, repmat(iStudies(i), 1, length(iFoundTf))];
                        iDepItems   = [iDepItems,   iFoundTf];
                    end
                end
            case 'matrix'
                % Get all "matrix" files of this study
                if ~isempty(sStudies(i).Matrix)
                    % === Check file filters ===
                    if ~isempty(NodelistOptions)
                        PossibleFiles = {sStudies(i).Matrix.FileName};
                        PossibleComments = {sStudies(i).Matrix.Comment};
                        iFoundMat = find(isFileSelected(PossibleFiles, PossibleComments, NodelistOptions));
                    else
                        iFoundMat = 1:length(sStudies(i).Matrix);
                    end
                    % Add data files to list
                    if ~isempty(iFoundMat)
                        iDepStudies = [iDepStudies, repmat(iStudies(i), 1, length(iFoundMat))];
                        iDepItems   = [iDepItems,   iFoundMat];
                    end
                end
            case 'headmodel'
                % Get all headmodels of this study
                nbHeadModel = length(sStudies(i).HeadModel);
                if (nbHeadModel > 0) && ~isempty(sStudies(i).iHeadModel)
                    iDepStudies = [iDepStudies, iStudies(i)];
                    iDepItems   = [iDepItems,   sStudies(i).iHeadModel];
                end
                
            case {'pdata', 'presults', 'ptimefreq', 'pspectrum', 'pmatrix'}
                % Get the stat files of the appropriate type
                iStat = find(strcmpi({sStudies(i).Stat.Type}, targetNodeType(2:end)));
                % If some valid files were found
                if ~isempty(iStat)
                    if ~isempty(NodelistOptions)
                        StatFiles = {sStudies(i).Stat(iStat).FileName};
                        StatComments = {sStudies(i).Stat(iStat).Comment};
                        iFoundMat = iStat(isFileSelected(StatFiles, StatComments, NodelistOptions));
                    else
                        iFoundMat = iStat;
                    end
                    % Add stat files to list
                    if ~isempty(iFoundMat)
                        iDepStudies = [iDepStudies, repmat(iStudies(i), 1, length(iFoundMat))];
                        iDepItems   = [iDepItems,   iFoundMat];
                    end
                end
        end
    end
end

end


%% ===== CHECK FILE NAME/COMMENT =====
function isSelected = isFileSelected(FileNames, Comments, NodelistOptions, iStudy)
    % Parse inputs
    if (nargin < 4) || isempty(iStudy)
        iStudy = [];
    end
    % Nothing selected
    if isempty(NodelistOptions)
        return
    end
    % No input
    if isempty(FileNames) || isempty(Comments)
        isSelected = [];
        return;
    end
    % Force files list in cells
    if ischar(FileNames)
        FileNames = {FileNames};
    end
    if ischar(Comments)
        Comments = {Comments};
    end
    % Default: all the files are selected
    isSelected = true(1, length(FileNames));
    % Results links: Add data comment
    if strcmpi(NodelistOptions.Target, 'Comment')
        for i = 1:length(FileNames)
            if (nnz(FileNames{i} == '|') == 2)
                splitFile = str_split(FileNames{i}, '|');
                if ~isempty(iStudy)
                    [sStudy,tmp,iData] = bst_get('DataFile', splitFile{3}, iStudy);
                else
                    [sStudy,tmp,iData] = bst_get('DataFile', splitFile{3});
                end
                if ~isempty(iData)
                    Comments{i} = [Comments{i} '|' sStudy.Data(iData).Comment];
                end
            end
        end
    % If searching for comment in parent nodes too
    elseif strcmpi(NodelistOptions.Target, 'Parent')
        for i = 1:length(FileNames)
            switch (file_gettype(FileNames{i}))
                case {'results', 'link'}
                    % Find the file in database
                    if ~isempty(iStudy)
                        [sStudyFile, iStudyFile, iResult] = bst_get('ResultsFile', FileNames{i}, iStudy);
                    else
                        [sStudyFile, iStudyFile, iResult] = bst_get('ResultsFile', FileNames{i});
                    end
                    % Find the parent in the database
                    if ~isempty(sStudyFile.Result(iResult).DataFile)
                        [sStudyParent, iStudyParent, iData] = bst_get('DataFile', sStudyFile.Result(iResult).DataFile, iStudyFile);
                        if ~isempty(sStudyParent)
                            Comments{i} = [Comments{i} '|' sStudyParent.Data(iData).Comment];
                        end
                    end
                case 'timefreq'
                    % Find the file in database
                    if ~isempty(iStudy)
                        [sStudyFile, iStudyFile, iTf] = bst_get('TimefreqFile', FileNames{i}, iStudy);
                    else
                        [sStudyFile, iStudyFile, iTf] = bst_get('TimefreqFile', FileNames{i});
                    end
                    ParentFile = sStudyFile.Timefreq(iTf).DataFile;
                    % Find the parent in the database
                    if ~isempty(ParentFile)
                        switch (file_gettype(ParentFile))
                            case 'data'
                                [sStudyParent, iStudyParent, iData] = bst_get('DataFile', ParentFile, iStudyFile);
                                if ~isempty(sStudyParent)
                                    Comments{i} = [Comments{i} '|' sStudyParent.Data(iData).Comment];
                                end
                            case {'results', 'link'}
                                [sStudyParent, iStudyParent, iResult] = bst_get('ResultsFile', ParentFile, iStudyFile);
                                if ~isempty(sStudyParent)
                                    Comments{i} = [Comments{i} '|' sStudyParent.Result(iResult).Comment];
                                end
                                % Add parent of parent
                                ParentFile = sStudyParent.Result(iResult).DataFile;
                                if ~isempty(ParentFile)
                                    [sStudyParent, iStudyParent, iData] = bst_get('DataFile', ParentFile, iStudyFile);
                                    if ~isempty(sStudyParent)
                                        Comments{i} = [Comments{i} '|' sStudyParent.Data(iData).Comment];
                                    end
                                end
                            case 'matrix'
                                [sStudyParent, iStudyParent, iMatrix] = bst_get('MatrixFile', ParentFile, iStudyFile);
                                if ~isempty(sStudyParent)
                                    Comments{i} = [Comments{i} '|' sStudyParent.Matrix(iMatrix).Comment];
                                end
                        end
                    end
            end
        end
    end
    % Switch comments and file names
    if ismember(NodelistOptions.Target, {'Comment', 'Parent'})
        FileNames = Comments;
    end
    % Force file names to lower case
    FileNames = lower(FileNames);
%     % Remove all the file paths
%     if ~NodelistOptions.isComment
%         for i = 1:length(FileNames)
%             if (nnz(FileNames{i} == '|') == 2)
%                 splitFile = str_split(FileNames{i}, '|');
%                 [tmp, fBase1] = bst_fileparts(splitFile{2});
%                 [tmp, fBase2] = bst_fileparts(splitFile{3});
%                 FileNames{i} = [fBase1 '|' fBase2];
%             else
%                 [tmp, FileNames{i}] = bst_fileparts(FileNames{i});
%             end
%         end
%     end

    % Eval filter expression to check if selected
    isSelected = isSelected & cellfun(@(c)eval(NodelistOptions.Eval), FileNames);
    % Invert selection
    if ~NodelistOptions.isSelect
        isSelected = ~isSelected;
    end
end


%% ===== CHECK RESULTS TYPE =====
% Get all results of this study that ARE SHARED KERNELS (imaging kernel not attched to a datafile)
function isPure = isPureKernel(sResults)
    isPure = cellfun(@isempty, {sResults.DataFile}) & ...
             ~cellfun(@(c)isempty(strfind(c, 'KERNEL')), {sResults.FileName});   
end


%% ===== Building Filter tree =====
function root = CreateFilterTree(s)
    s = [s ' '];
    root = struct();
    root.word = '';
    root.children = [];
    path = [];
    numChildren = 0;
    quoting = 0;
    ADD_BRANCH = 1;
    END_BRANCH = 2;
    word = '';
    
    for i = 1:length(s)
        wordEnd = 0;
        action = 0;
        
        % Check for special characters.
        if s(i) == '"'
            wordEnd = 1;
            quoting = ~quoting;
        elseif s(i) == '(' && ~quoting
            wordEnd = 1;
            action = ADD_BRANCH;
        elseif s(i) == ')' && ~quoting
            wordEnd = 1;
            action = END_BRANCH;
        elseif s(i) == ' ' && ~quoting
            wordEnd = 1;
        else
            word = [word s(i)];
        end
        
        % If this is the end of a word, store it.
        if wordEnd
            word = strtrim(word);
            if ~isempty(word)
                node = struct();
                node.word = word;
                node.children = [];
                evalString = 'root';
                for iPath = 1:length(path)
                    evalString = [evalString '.children(' num2str(path(iPath)) ')'];
                end
                evalString = [evalString '.children'];
                if ~isempty(eval(evalString))
                    evalString = [evalString '(' num2str(numChildren + 1) ')'];
                end
                eval([evalString ' = node;']);
                numChildren = numChildren + 1;
            end
            word = '';
        end
        
        % Create new branch
        if action == ADD_BRANCH
            node = struct();
            node.word = '';
            node.children = [];
            iChild = numChildren + 1;
            path = [path, iChild];
            evalString = 'root';
            lastSelector = '';
            for iPath = 1:length(path)
                evalString = [evalString lastSelector '.children'];
                lastSelector = ['(' num2str(path(iPath)) ')'];
            end
            if ~isempty(eval(evalString))
                evalString = [evalString lastSelector];
            end
            eval([evalString ' = node;']);
            numChildren = 0;
        % Go back one branch
        elseif action == END_BRANCH
            path(end) = [];
            evalString = 'root';
            for iPath = 1:length(path)
                evalString = [evalString '.children(' num2str(path(iPath)) ')'];
            end
            eval(['numChildren = length(' evalString '.children);']);
        end
    end
end

%% ===== Parsing filter tree recursively =====
function [res, isWord] = ParseFilterTree(root)
    % Change reserved words to symbol
    isWord = 0;
    if isempty(root.word)
        res = '';
    elseif any(strcmpi({'and', '&', '&&', '+'}, root.word))
        res = '&&';
    elseif any(strcmpi({'or', '|', '||'}, root.word))
        res = '||';
    elseif strcmpi(root.word, 'not')
        res = '~';
    % Add query for string to find if not reserved symbol
    else
        res = ['~isempty(strfind(c,''' root.word '''))'];
        isWord = 1;
    end
    
    % Recursive call to children
    if isfield(root, 'children')
        lastChildIsWord = 0;
        for iChild = 1:length(root.children)
            node = root.children(iChild);
            [word, isWord] = ParseFilterTree(node);
            % Add implicit AND if no operator between two tags specified
            if lastChildIsWord && isWord
                res = [res ' &&'];
            end
            lastChildIsWord = isWord;
            if isfield(node, 'children') && ~isempty(node.children)
                res = [res ' (' word ')'];
            else
                res = [res ' ' word];
            end
        end
    end
end

%% ===== Combining filter calls =====
function evalExpression = CreateFilterEvalExpression(s)
    root = CreateFilterTree(s);
    evalExpression = ParseFilterTree(root);
    
    % Validate expression
    c = 'test';
    try
        tmp = eval(evalExpression);
    catch
        % If there is an error, use an "exclude all" expression instead.
        evalExpression = '0';
    end
end

