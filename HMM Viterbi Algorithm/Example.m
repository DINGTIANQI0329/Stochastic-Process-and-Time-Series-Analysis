% --- Weather Prediction Example Script ---
% --- 天气预测问题脚本 ---

% 1. Define Model Components and Mappings
% 1. 定义模型组件和映射关系
state_names = {'Rainy', 'Sunny'};
observation_names = {'Walk', 'Shop', 'Clean'};

% 2. Define HMM Parameters (based on reasonable assumptions)
% 2. 定义HMM参数 (基于合理假设)
pi = [0.4, 0.6]; % Initial state probabilities: P(Rainy), P(Sunny)
A = [0.7, 0.3;   % Transition matrix: [P(R|R), P(S|R); P(R|S), P(S|S)]
     0.4, 0.6];
B = [0.1, 0.4, 0.5;   % Emission matrix: [P(W|R), P(S|R), P(C|R); P(W|S), P(S|S), P(C|S)]
     0.6, 0.3, 0.1];

% 3. Define the observation sequence based on the image
% 3. 根据图片定义观测序列
% Sequence: (Walk, Shop, Clean) -> Mapped to indices: [1, 2, 3]
obs = [1, 2, 3];

% 4. Call the optimized Viterbi function
% 4. 调用优化后的维特bi函数
[best_path_indices, path_prob] = viterbi_custom(obs, A, B, pi);

% 5. Decode and Display the results for better readability
% 5. 解码并显示结果以提高可读性
observed_activities = observation_names(obs);
predicted_weather = state_names(best_path_indices);

disp('--- Weather Prediction using Viterbi Algorithm ---');
fprintf('Observed Activities: %s -> %s -> %s\n', observed_activities{:});
fprintf('Predicted Weather:   %s -> %s -> %s\n', predicted_weather{:});
fprintf('Log Probability of this path: %.4f\n', path_prob);

% --- Expected Output ---
% Observed Activities: Walk -> Shop -> Clean
% Predicted Weather:   Sunny -> Rainy -> Rainy
% Log Probability of this path: -4.5328