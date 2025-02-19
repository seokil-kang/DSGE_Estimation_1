function cycle = hpfilter1_cycle(y_full,lambda)
% hpfilter function in case of licence issue...
% [trend, cycle] = hpfilter1(y,lambda)

if isrow(y_full)
    y_full = y_full';
end

% cut out the missing values...
y = y_full(~isnan(y_full));

T = length(y);
T_tilde = T + 2;
H = horzcat(eye(T),zeros(T,2));
Q = zeros(T,T_tilde);

for t = 1:T
    Q(t,t:t+2) = [1 -2 1];
end

Astar = inv(H'*H + lambda * Q' * Q) * H';
trend = Astar * y;
trend = trend(1:end-2);


% re-attach the nan value back
trend_full = y_full;
trend_full(~isnan(y_full)) = trend;

cycle = y_full - trend_full;

end