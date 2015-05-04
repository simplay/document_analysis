% Copyright (C) 2013 Quan Wang <wangq10@rpi.edu>,
% Signal Analysis and Machine Perception Laboratory,
% Department of Electrical, Computer, and Systems Engineering,
% Rensselaer Polytechnic Institute, Troy, NY 12180, USA

% dynamic time warping of two signals

function [d, p, q]=dtw(s,t,w)
% s: signal 1, size is ns*k, row for time, colume for channel 
% t: signal 2, size is nt*k, row for time, colume for channel 
% w: window parameter
%      if s(i) is matched with t(j) then |i-j|<=w
% d: resulting distance

if nargin<3
    w=Inf;
end

ns=size(s,1);
nt=size(t,1);
if size(s,2)~=size(t,2)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end
w=max(w, abs(ns-nt)); % adapt window size

%% initialization
D=zeros(ns+1,nt+1)+Inf; % cache matrix
decisions = repmat(-1, size(D));
D(1,1)=0;

%% begin dynamic programming
for i=1:ns
    for j=max(i-w,1):min(i+w,nt)
        oost=norm(s(i,:)-t(j,:));
        [min_cost, pos] = min( [D(i,j+1), D(i+1,j), D(i,j)] );
        decisions(i+1,j+1) = pos;
        D(i+1,j+1) = oost + min_cost;
    end
end
d=D(ns+1,nt+1);

%% Backtrack
i = ns + 1;
j = nt + 1;
p = zeros(min(ns, nt), 1);
q = zeros(min(ns, nt), 1);
nr_matches = 0;
while i > 1 && j > 1
    current_decision = decisions(i, j);
    if current_decision == 1
        j = j - 1;
    elseif current_decision == 2
        i = i - 1;
    else
        p(end - nr_matches) = i;
        q(end - nr_matches) = j;
        nr_matches = nr_matches + 1;
        i = i - 1;
        j = j - 1;
    end
end
