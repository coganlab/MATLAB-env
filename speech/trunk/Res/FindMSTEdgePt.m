% FindMSTEdgePt: Given a set of edges from a minimum-spanning tree and a specified point, 
%                finds the one, two or three edge(s) associated with that point and returns
%                the corresponding points associated with those edges.
%
%     Usage: ptlist = FindMSTEdgePt(edges,pt,{excl})
%
%         edges =    [(N-1) x 2] list of points defining edges for N points, in arbitrary
%                      sequence.
%         pt =       index of specified point.
%         excl =     optional list of points to be excluded from returned list of points.
%         -------------------------------------------------------------------------------
%         ptlist =   [k x 1] list of point identifiers, for k = 1 if pt is terminal, k = 2
%                      if pt lies along a branch, and k = 3 if pt is a nodal point.
%         edgelist = [k x 1] list of corresponding edge indices.
%

% RE Strauss, 10/13/03

function [ptlist,edgelist] = FindMSTEdgePt(edges,pt,excl)
  if (nargin < 3) excl = []; end;

  i = find(edges(:,1)==pt);             % Find edges involving current point
  ptlist = edges(i,2);
  edgelist = i(:);
  i = find(edges(:,2)==pt);
  ptlist = [ptlist; edges(i,1)];
  edgelist = [edgelist; i(:)];
  
  i = ~isin(ptlist,excl);               % Exclude points if requested
  ptlist = ptlist(i);
  edgelist = edgelist(i);

  return;
  
