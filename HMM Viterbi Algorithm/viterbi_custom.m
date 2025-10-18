function [best_path, path_prob, viterbi, psi] = viterbi_custom(obs, A, B, pi)
% VITERBI_CUSTOM_OPTIMIZED Implements the Viterbi algorithm using log probabilities (Vectorized).
% 本函数使用对数概率和向量化操作实现隐马尔可夫模型的维特比算法。
%
%   Inputs:
%   输入参数:
%       obs: 1xT vector of observations (as integer indices).
%       A:   NxN state transition probability matrix.
%       B:   NxM observation emission probability matrix.
%       pi:  1xN initial state probability vector.
%
%   Outputs:
%   输出参数:
%       best_path: 1xT vector of the most likely hidden state sequence.
%       path_prob: The log probability of the best_path.
%       viterbi:   The NxT matrix of log probabilities (for visualization).
%       psi:       The NxT backpointer matrix (for visualization).

% --- 1. Setup and Initialization ---
N = size(A, 1);
T = length(obs);
viterbi = zeros(N, T);
psi = zeros(N, T);

logA = log(A); logA(A==0) = -inf;
logB = log(B); logB(B==0) = -inf;
logPi = log(pi); logPi(pi==0) = -inf;

% --- 2. Initialization Step (t=1) ---
viterbi(:, 1) = logPi' + logB(:, obs(1));
psi(:, 1) = 0;

% --- 3. Recursion Step (t=2 to T) ---
for t = 2:T
    % Vectorized calculation for all states 'j' at once
    [max_probs, max_indices] = max(viterbi(:, t-1) + logA, [], 1);
    viterbi(:, t) = max_probs' + logB(:, obs(t));
    psi(:, t) = max_indices';
end

% --- 4. Termination and Backtracking ---
[path_prob, last_state] = max(viterbi(:, T));
best_path = zeros(1, T);
best_path(T) = last_state;

for t = T-1:-1:1
    best_path(t) = psi(best_path(t+1), t+1);
end

end