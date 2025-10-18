% --- Weather Prediction Example with Visualization ---
% --- 带可视化的天气预测问题脚本 ---

clear; clc; close all;

% 1. Define Model Components and Mappings
state_names = {'Rainy', 'Sunny'};
observation_names = {'Walk', 'Shop', 'Clean'};

% 2. Define HMM Parameters
pi = [0.4, 0.6];
A = [0.7, 0.3; 
     0.4, 0.6];
B = [0.1, 0.4, 0.5; 
     0.6, 0.3, 0.1];

% 3. Define the observation sequence
obs = [1, 2, 3]; % (Walk, Shop, Clean)

% 4. Call the optimized Viterbi function
%    注意：我们需要函数返回所有四个输出
[best_path_indices, path_prob, viterbi_log_probs, psi] = ...
    viterbi_custom(obs, A, B, pi);

% 5. Decode and Display the text results
observed_activities = observation_names(obs);
predicted_weather = state_names(best_path_indices);

disp('--- Weather Prediction using Viterbi Algorithm ---');
fprintf('Observed Activities: %s -> %s -> %s\n', observed_activities{:});
fprintf('Predicted Weather:   %s -> %s -> %s\n', predicted_weather{:});
fprintf('Log Probability of this path: %.4f\n\n', path_prob);

% 6. Call the visualization function
% 6. 调用可视化函数
disp('Generating Viterbi trellis diagram...');
plot_viterbi_trellis(obs, state_names, viterbi_log_probs, best_path_indices, psi);