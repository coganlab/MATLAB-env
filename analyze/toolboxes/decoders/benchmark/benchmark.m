%decoders = {'Kalman','KalmanWoodbury','KARMA'};
decoders = {'KARMA'};

arm_data = randn(32, 1000); % Fake arm kinematics training data
neural_training_data = rand(256, 1000); % Fake electrode training data
neural_test_data = rand(256, 32); % Fake testing data for decoding
for decoder = decoders
    name = char(decoder);
    fprintf('Benchmarking %s decoder...\n', name)
    addpath(genpath(fullfile(pwd, name)));
    for i = 2:128
        fprintf('\t %i neurons...\n',i);
        params = train(arm_data, neural_training_data(1:i, :));
        state = initialize(params);
        for t = 1:size(neural_test_data, 2);
            tic
            [state, prediction] = decode(state, params, neural_test_data(1:i, t));
            dt.(name)(t,i) = 1e3*toc;
        end
    end
    rmpath(genpath(fullfile(pwd, name)));
    clf
    plot(mean(dt.(name)))
    title(name)
    ylabel('Time per update step (ms)')
    xlabel('Number of electrodes')
    print(gcf, '-depsc', fullfile(pwd, name, 'benchmark.eps'));
    print(gcf, '-djpeg', fullfile(pwd, name, 'benchmark.jpg'));
end
