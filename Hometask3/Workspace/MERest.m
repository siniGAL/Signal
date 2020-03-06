% Вычисление MER 
%> @file MERest.m
% =========================================================================
%> @brief Вычисление MER
%> @param signal идеальный сигнал
%> @param Nsignal зашумленные сигнал
%> @return MER ошибка модуляции в дБ
% =========================================================================
function MER = MERest (signal, Nsignal)
Psignal = 0;
Pnoise = 0;
    for x = 1:length(signal) 
        Psignal = Psignal + (real(signal(x))^2 + imag(signal(x))^2);        
        Pnoise = Pnoise + (real(Nsignal(x)) - real(signal(x)))^2 + (imag(Nsignal(x)) - imag(signal(x)))^2;        
    end
    MER = 10*log10(Psignal/Pnoise);
end