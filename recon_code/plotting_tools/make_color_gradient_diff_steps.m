function rez = make_color_gradient_diff_steps(colors, n_steps)

assert(size(colors,1)==length(n_steps)+1,'dimension mismatch');
if nargin < 2
    n_steps = 15*size(colors,1);
end

o_n_steps = n_steps * 3; % supersample, then subsample later on

% steps = floor(o_n_steps/(size(colors,1)-1));

rez = [];
for n = 2:size(colors)
    rez_n = linear_spacing_step(colors(n-1,:), colors(n,:),o_n_steps(n-1));
    idx = floor(linspace(1,size(rez_n,1), n_steps(n-1)));
    rez_n = rez_n(idx,:);
    rez = cat(1, rez, rez_n);
end

% idx = floor(linspace(1,size(rez,1), n_steps));
% rez = rez(idx,:);
assert(size(rez,1) == sum(n_steps));

    function c3 = linear_spacing_step(c1, c2,steps)
        c3_r = linspace(c1(1), c2(1), steps)';
        c3_g = linspace(c1(2), c2(2), steps)';
        c3_b = linspace(c1(3), c2(3), steps)';
        c3 = [c3_r c3_g c3_b];
    end

end