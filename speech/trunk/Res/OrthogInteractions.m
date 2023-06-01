% OrthogInteractions: Produces "pure interaction" terms for an ANOVA by
%         orthogonalizing them with respect to the main effects and all lower-order
%         interactions, thus making them statistically independent of the main 
%         effects and of one another.
%
%     Usage: terms = OrthogInteractions(X,{intterms})
%
%         X =    [N x P] data matrix of N observations and P variables, where the 
%                  P variables are the main-effect variables to be used in an ANOVA.
%         intterms = optional charactger matrix of desired interaction terms, with each 
%                     row specifying one interaction term, using the following notation:
%                     for main effects A,B,C,... (case insensitive), each row specifies
%                     a combination of effects.  The default is to specify the full model
%                     with all main effects and interactions.  'MAIN' (case insensitive)
%                     can be used to indicate inclusion of all main effects.
%                       For example,
%                         char('A','B','AB') OR char('A','B') OR 'main'
%                           for 2 main effects and their interaction;
%                         char('A','AB') for 1 of 2 main effects and their interaction;
%                         char('main','ab','ac','bc) for 3 main effects and all
%                           pairwise interactions, omitting the 3-way interaction;
%                         char('main','ab','abc') for 3 main effects, 1 of 3 pairwise
%                           interactions and the 3-way interaction.
%         --------------------------------------------------------------------------------
%         terms = [N x Q] data matrix for Q main-effect and interaction terms.
%               

% Burrill, D.  On modelling and interpreting interactions in multiple regression.
%   White paper, available at <http://www.minitab.com/resources/whitepapers/burril2.aspx>.

% RE Strauss, 10/28/03

function Xint = OrthogInteractions(X,intterms)
  if (nargin < 2) intterms = []; end;
  
  [N,P] = size(X);
  if (isempty(intterms))
    % Generate all terms, using combs()
  end;

  return;
  

