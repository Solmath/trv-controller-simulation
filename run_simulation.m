clc
clear
close all

valve_max = 1; % 100%

% Plant parameters
T = 1200;
K = 40; % Maximum possible temperature rise compared to outdoor temperature

s = tf('s');

G_plant = K / (T*s + 1);

% Plot the step response of G_plant
figure;
step(G_plant);
title('Step Response of the Plant');
xlabel('Time (s)');
ylabel('Temperature Response (°C)');
grid on;

% Plot phase and gain reserve of the plant
figure;
margin(G_plant);
title('Bode Plot of the Plant');
grid on;

Theta_0 = 5;
Theta_set = 24;

%% P-Controller
Kp = 0.5;
Ki = 0;

sim_heating_and_plot_results('P-Controller');

%% PI-Controller aggressive
Kp = 10;
Ki = 10;

sim_heating_and_plot_results('PI-Controller (aggressive)');

%% PI-Controller fast but robust
% Ultra fast
Kp = 0.44;
Ki = 0.001;

G_controller = Kp + Ki/s;

G_openloop = G_controller * G_plant;
figure;
margin(G_openloop)

sim_heating_and_plot_results('PI-Controller');

%% PI-Controller with integrator saturation

% Set the 'LimitOutput' parameter of the PID Controller block to 'on'
set_param('heating/PID Controller','LimitIntegrator','on')
sim_heating_and_plot_results('PI-Controller and Saturation');
set_param('heating/PID Controller', 'LimitIntegrator', 'off');

%% PI-Controller with clamping anti-windup

% Set the 'LimitOutput' parameter of the PID Controller block to 'on'
set_param('heating/PID Controller','AntiWindupMode','clamping')
sim_heating_and_plot_results('PI-Controller with clamping');
set_param('heating/PID Controller', 'AntiWindupMode', 'none');

%% PI slow
% PID-Tuner
% Kp = 0.049;
% Ki = 5.9e-5;

function sim_heating_and_plot_results(controller)
    % Simulate the Simulink model
    out = sim('heating.slx');

    ds = out.logsout;
    sig = ds.get('Theta_current'); % Retrieve the temperature output from the simulation
    
    time = sig.Values.Time;
    temperature = sig.Values.Data;
    
    setpoint = ds.get('Theta_set').Values.Data;
    
    % Plot results
    figure;
    plot(time, temperature, 'LineWidth', 2);
    hold on;
    plot(time, setpoint, 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title(['Temperature Response with ' controller]);
    legend('Temperature', 'Setpoint');
    grid on;
    ylim([0 35])
end