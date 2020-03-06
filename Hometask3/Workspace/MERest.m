% ���������� MER 
%> @file MERest.m
% =========================================================================
%> @brief ���������� MER
%> @param signal ��������� ������
%> @param Nsignal ����������� ������
%> @return MER ������ ��������� � ��
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