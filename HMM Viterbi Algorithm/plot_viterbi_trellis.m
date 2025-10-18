function plot_viterbi_trellis(obs, state_names, viterbi_log_probs, best_path, psi)
% PLOT_VITERBI_TRELLIS Visualizes the Viterbi algorithm's trellis and path.
% 本函数可视化维特比算法的网格图和最优路径。

% 从概率矩阵中获取状态数量(N)和时间步数(T)
[N, T] = size(viterbi_log_probs);

figure('Name', 'Viterbi Trellis Diagram', 'Position', [100 100 1200 600]);
hold on;

% 归一化对数概率以便于颜色/大小的可视化
min_prob = min(viterbi_log_probs(:));
max_prob = max(viterbi_log_probs(isfinite(viterbi_log_probs(:))));

if max_prob == min_prob
    normalized_probs = ones(size(viterbi_log_probs));
else
    normalized_probs = (viterbi_log_probs - min_prob) / (max_prob - min_prob);
end

marker_sizes = 20 + normalized_probs * 150;
marker_sizes(isinf(viterbi_log_probs)) = 10; % 为-inf概率设置一个较小的尺寸

% 绘制网格中的所有节点和回溯指针
for t = 2:T
    for j = 1:N
        prev_state = psi(j, t);
        if prev_state > 0
            % 绘制从前一状态到当前状态的回溯指针连线
            plot([t-1, t], [prev_state, j], 'k:', 'LineWidth', 0.5);
        end
    end
end

% 绘制所有节点 (在连线之上，使其更清晰)
for t = 1:T
    for i = 1:N
        h = scatter(t, i, marker_sizes(i, t), normalized_probs(i, t), 'filled');
        % 为交互性设置ButtonDownFcn回调函数
        h.ButtonDownFcn = {@show_node_info, t, i, viterbi_log_probs(i,t), psi(i,t), state_names};
    end
end

% 绘制最优路径
plot(1:T, best_path, 'r-', 'LineWidth', 2.5);
scatter(1:T, best_path, 100, 'r', 'LineWidth', 2); % 高亮路径上的节点

% 配置图形外观
set(gca, 'YTick', 1:N, 'YTickLabel', state_names, 'FontSize', 12);
set(gca, 'XTick', 1:T, 'XTickLabel', arrayfun(@(x) sprintf('t=%d\no=%d', x, obs(x)), 1:T, 'UniformOutput', false));
xlabel('Time Step / Observation (时间步/观测值)', 'FontSize', 14);
ylabel('Hidden State (隐藏状态)', 'FontSize', 14);
title({'Interactive Viterbi Trellis Diagram (交互式维特比网格图)', 'Click on any node for details'}, 'FontSize', 16);
grid on;
colormap('jet');
hcb = colorbar;
ylabel(hcb, 'Normalized Log Probability (归一化对数概率)', 'FontSize', 12);
axis([0.5 T+0.5 0.5 N+0.5]); % 调整坐标轴范围

hold off;
end

function show_node_info(~, ~, t, i, log_prob, backpointer, state_names)
% 用于显示节点信息的回调函数
    if t > 1 && backpointer > 0 && backpointer <= numel(state_names)
        prev_state_name = state_names{backpointer};
    else
        prev_state_name = 'Start';
    end
    
    info_str = sprintf('Time: %d, State: ''%s'' | LogProb: %.4f | Came from State: ''%s''',...
                       t, state_names{i}, log_prob, prev_state_name);
    
    % 用点击节点的信息更新标题
    title({'Interactive Viterbi Trellis Diagram (交互式维特比网格图)', info_str});
    disp(info_str); % 同时在命令行窗口显示
end