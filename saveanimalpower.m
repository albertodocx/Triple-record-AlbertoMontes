function saveanimalpower (mainFolder,subfolders,finalfolder)
% Perfil de potencia - electrofisiología
[~, nombre_raton, ~] = fileparts(subfolders(1).name);
idx_medio_guion = regexp(nombre_raton, '(?<=_)[A-Za-z]\d+(?=_)', 'match', 'once');
nombre_raton = idx_medio_guion;
rat_numbers = {};

meanTheta_all = [];
meanDelta_all = [];
meanGamma_all = [];
meanHfo_all = [];
meanAlpha_all = [];

for i = 1:length(subfolders)
    disp(['Procesando subcarpeta número ', num2str(i)]);
    currentSubfolder = fullfile(mainFolder, subfolders(i).name);
    mypathTDT = strcat(currentSubfolder, '/fpdata.mat');
    mypathRs = strcat(currentSubfolder, '/Results.mat');
    load(mypathTDT, "TDTdata");
    load(mypathRs, "results");

    % Extraer datos de potencia
    pyr = results.lfp.datosfiltrados.';
    pyrfs = TDTdata.streams.Wav1.fs;
    pyrdata.dataLFP = double(pyr);
    pyrdata.fsLFP = pyrfs;
    pyrch_power = LFP_compute_psProfile(pyrdata);
    close all

    % Calcular las medias de potencia
    meanTheta = mean(pyrch_power.infoRhs.theta.pmean, 'all');
    meanDelta = mean(pyrch_power.infoRhs.delta.pmean, 'all');
    meanGamma = mean(pyrch_power.infoRhs.gamma.pmean, 'all');
    meanHfo = mean(pyrch_power.infoRhs.hfo.pmean, 'all');
    meanAlpha = mean(pyrch_power.infoRhs.alpha.pmean, 'all');

    % Almacenar las medias en matrices
    meanTheta_all = [meanTheta_all, meanTheta];
    meanDelta_all = [meanDelta_all, meanDelta];
    meanGamma_all = [meanGamma_all, meanGamma];
    meanHfo_all = [meanHfo_all, meanHfo];
    meanAlpha_all = [meanAlpha_all, meanAlpha];

    [~, numero_raton, ~] = fileparts(currentSubfolder);
    idx_ultimo_guion = regexp(numero_raton, '_[^_]*$');
    numero_raton = numero_raton(idx_ultimo_guion+1:end);
    rat_numbers{i} = numero_raton;
end

% Crear un gráfico de líneas para las medias de cada potencia
figure(1);
plot(1:length(subfolders), meanTheta_all, '.-', 'Color',[0.00,0.45,0.74],'MarkerSize',20,'DisplayName', 'Theta');
hold on;
plot(1:length(subfolders), meanHfo_all, '.-','Color',[0.49,0.18,0.56],'MarkerSize',20,'DisplayName', 'HFO');
hold off;

% Personalizar el gráfico
xticklabels(rat_numbers);
xlim([0.5,length(subfolders)+0.5]);
ylabel('Potencia media');
title('Potencias de ondas electrofisiológicas');
legend('Location', 'best');
grid on;
saveas(gcf, fullfile(finalfolder, ['PotenciasTH',nombre_raton,'.jpg']));
savefig(fullfile(finalfolder, ['PotenciasTH',nombre_raton,'.fig']));
pause (2)
close all

figure(2);
plot(1:length(subfolders), meanTheta_all, '.-', 'Color',[0.00,0.45,0.74],'MarkerSize',20,'DisplayName', 'Theta');
hold on;
plot(1:length(subfolders), meanDelta_all, '.-','Color',[0.85,0.33,0.10],'MarkerSize',20, 'DisplayName', 'Delta');
plot(1:length(subfolders), meanGamma_all, '.-','Color',[0.93,0.69,0.13],'MarkerSize',20, 'DisplayName', 'Gamma');
plot(1:length(subfolders), meanHfo_all, '.-','Color',[0.49,0.18,0.56],'MarkerSize',20,'DisplayName', 'HFO');
plot(1:length(subfolders), meanAlpha_all, '.-','Color',[0.47,0.67,0.19],'MarkerSize',20, 'DisplayName', 'Alpha');
hold off;


% Personalizar el gráfico
xticklabels(rat_numbers);
xlim([0.5,length(subfolders)+0.5]);
ylabel('Potencia media');
title('Potencias de ondas electrofisiológicas');
legend('Location', 'best');
grid on;
saveas(gcf, fullfile(finalfolder, ['Potencias',nombre_raton,'.jpg']));
savefig(fullfile(finalfolder, ['Potencias',nombre_raton,'.fig']));
close all

figure ('Position',[207,76,560,678]);
subplot(2,1,2);
plot(1:length(subfolders), meanTheta_all, '.-', 'Color',[0.00,0.45,0.74],'MarkerSize',20,'DisplayName', 'Theta');
hold on;
plot(1:length(subfolders), meanHfo_all, '.-','Color',[0.49,0.18,0.56],'MarkerSize',20,'DisplayName', 'HFO');
hold off;

% Personalizar el gráfico
xticklabels(rat_numbers);
xlim([0.5,length(subfolders)+0.5]);
ylabel('Potencia media');
title('Potencias de ondas electrofisiológicas');
legend('Location', 'best');
grid on;

subplot (2,1,1);
plot(1:length(subfolders), meanTheta_all, '.-', 'Color',[0.00,0.45,0.74],'MarkerSize',20,'DisplayName', 'Theta');
hold on;
plot(1:length(subfolders), meanDelta_all, '.-','Color',[0.85,0.33,0.10],'MarkerSize',20, 'DisplayName', 'Delta');
plot(1:length(subfolders), meanGamma_all, '.-','Color',[0.93,0.69,0.13],'MarkerSize',20, 'DisplayName', 'Gamma');
plot(1:length(subfolders), meanHfo_all, '.-','Color',[0.49,0.18,0.56],'MarkerSize',20,'DisplayName', 'HFO');
plot(1:length(subfolders), meanAlpha_all, '.-','Color',[0.47,0.67,0.19],'MarkerSize',20, 'DisplayName', 'Alpha');
hold off;


% Personalizar el gráfico
xticklabels(rat_numbers);
xlim([0.5,length(subfolders)+0.5]);
ylabel('Potencia media');
title('Potencias de ondas electrofisiológicas');
legend('Location', 'best');
grid on;
saveas(gcf,fullfile(finalfolder,['allPotencias',nombre_raton,'.jpg']))
close all
end
