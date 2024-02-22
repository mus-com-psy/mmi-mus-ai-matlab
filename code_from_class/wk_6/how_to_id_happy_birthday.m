% In class on Thu, I posed the question:
% Suppose I give you n notes represented as a point-set D
% consisting of (ontime, MNN)-pairs.

% What could you do with pairs of notes, in terms of a mathematical
% manipulation f(d_i, d_j) and then storing the result, such that if I
% came back to you with a transposed or time-shifted version of those
% notes, say E, then re-application of f to pairs of points from E should
% lead to the *same* result as applying f to D?

% Opening phrase and a bit of Happy Birthday, as a point set:
D = [0 55; 0.75 55; 1 59; 1.5 57; 2 55; 3 60; 4 59; 6 55; 6.75 55; 7 57; 8 55];
% Opening phrase and a bit of Happy Birthday, as a point set, with a slight
% variation (additional note) near the beginning:
E = [40 60; 40.75 60; 41 62; 42 60; 43 65; 44 64; 46 60; 46.75 60; 47 62; 48 60];

% Your ideas
% 1. Differences between consecutive pairs of points.
diffD = diff(D);
diffE = diff(E);

% 2. Normalize.
Dmc = D - D(1, :);
Emc = E - E(1, :);

% My suggestion
% Ideas (1) and (2) are both really good. In class I started talking about
% the fragility of these ideas with respect to missing or extra notes, but
% that was a bit unfair because it wasn't in my original question.

% So I suggested the following, producing multidimensional arrays A and B.
% Sometimes such arrays are referred to as difference arrays or "the
% difference matrix" or "self-similarity matrix" (even though technically
% it's not a matrix because of its dimensionality).
% 3. Store pairwise differences between points.
n = length(D);
A = zeros(n, n, 2);
% N = n*(n - 1)/2;
% v = zeros(N, 3);
% aColorVals = zeros(n, n);
% k = 1;
for i=1:n
  for j=1:n
    A(i, j, :) = D(j, :) - D(i, :);
    % if j > i
    %   v(k, 1:2) = A(i, j, :);
    %   % Lookup
    %   [tf, idx] = ismember(v(k, 1:2), v(1:k - 1, 1:2), 'rows');
    %   if tf
    %     v(k, 3) = v(idx, 3);
    %   else
    %     v(k, 3) = 255*rand();
    %   end
    %   aColorVals(i, j) = v(k, 3);
    %   k=k+1;
    % end
  end
end
% close all; imagesc(aColorVals);

n = length(E);
B = zeros(n, n, 2);
% N = n*(n - 1)/2;
% v = zeros(N, 3);
% bColorVals = zeros(n, n);
% k = 1;
for i=1:n
  for j=1:n
    B(i, j, :) = E(j, :) - E(i, :);
    % if j > i
    %   v(k, 1:2) = B(i, j, :);
    %   % Lookup
    %   [tf, idx] = ismember(v(k, 1:2), v(1:k - 1, 1:2), 'rows');
    %   if tf
    %     v(k, 3) = v(idx, 3);
    %   else
    %     v(k, 3) = 255*rand();
    %   end
    %   bColorVals(i, j) = v(k, 3);
    %   k=k+1;
    % end
  end
end
% imagesc(bColorVals);


% If you look at these arrays in MATLAB's Workspace browser, you will see
% they are not identical to one another. A is a bit bigger than B because
% D contained an extra note. So this isn't *the* solution either, but it's
% step in a useful direction.

% Pay attention to the structure of either A or B: zeros on the diagonal;
% skew-symmetric (meaning A(i, j) = -A(j, i)).

% So we can discard the diagonal and lower triangle (it's a waste of time
% calculating them), but still the number of elements in the upper triangle
% of a matrix grows like O(n^2) with the number of elements in the input
% point set, so we need *heuristics* or *constraints* (or some other clever
% idea) on which pairs of points to bother calculating d_j - d_i for.

% We will resume this exploration next week!
