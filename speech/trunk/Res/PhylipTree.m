% PhylipTree :  Accepts output on branches and branch lengths as generated by 
%               Phylip into 'outfile', and produces a plot of the tree.  Assumes 
%               that taxa have been named 101, 102,...  Automatically resolves 
%               any trichotomies.  Accepts an optional character matrix of 
%               taxon labels for plot.
%                 Phylip output is of the following form, which must be edited 
%               into a 3-column or 5-column matrix.  If 5 columns are provided, 
%               the last two (confidence limits) are ignored.
%
%             Between     And             Length      Approx. Confidence Limits
%             -------     ---             ------      ------- ---------- ------
%              10       112               0.87357   (     0.05282,     2.71510)
%              10          1              0.07280   (     0.00440,     0.22627)
%               1          2              0.00000   (    -0.06636,     0.14889)
%               2       103               0.00000   (    -0.04283,     0.09610)
%               2          3              0.12857   (     0.00777,     0.39961)
%               3       105               0.00000   (    -0.08791,     0.19725)
%               .         .                  .               .            .
%               .         .                  .               .            .
%               .         .                  .               .            .
%
%     Usage: [anc,brlen] = phyliptree(branches,{labels})
%
%         branches = 3-col or 5-col matrix of Phylip output.
%         labels =   optional character matrix of taxon labels corresponding to 
%                      taxa 101 (outgroup), 102, 103, ...  If none is provided, 
%                      the taxa are labeled 1, 2, ...
%         ---------------------------------------------------------------------
%         anc =      ancestor function for tree.
%         brlen =    corresponding branch lengths.
%

% RE Strauss, 10/4/01

function [anc,brlen] = phyliptree(branches,labels)
  if (nargin < 2) labels = []; end;

  ncols = size(branches,2);
  if (ncols==5)
    branches = branches(:,1:3);
    ncols = 3;
  end;
  if (ncols~=3)
    error('  PHYLIPTREE: invalid input matrix.');
  end;

  maxotu = max(branches(:,2))-100;          % Renumber nodes
  branches(:,1) = branches(:,1) + maxotu;
  i = find(branches(:,2)<100);
  branches(i,2) = branches(i,2) + maxotu;
  i = find(branches(:,2)>100);
  branches(i,2) = branches(i,2) - 100;
  maxnode = max(branches(:,1));

  [u,f] = uniquef(branches(:,1));           % Locate trichotomies
  iu = find(f>2);
  if (~isempty(iu))
    newbranches = [];
    for iui = 1:length(iu)
      maxnode = maxnode+1;
      newbranches = [newbranches; maxnode u(iu(iui)) 0];
      i = find(branches(:,1)==u(iu(iui)));
      branches(i(3),1) = maxnode;
    end;
    branches = [newbranches; branches];
  end;

  if (isempty(labels))                      % Default labels
    labels = tostr(1:maxotu);
  end;

  anc = [];
  brlen = [];
  root = branches(1,1);
  [anc,brlen,branches,curr_node] = lnktoanc(anc,brlen,branches,root);
  treeplot(anc,brlen,labels);

  return;
