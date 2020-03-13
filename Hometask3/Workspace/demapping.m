% �������� ����������� ����� ���������
%> @file demapping.m
% =========================================================================
%> @brief ����������� ��� �� ���������
%> @param symbols ����� � IQ ������������
%> @param constellation �������� ����������� ��� ���� ���������:
%> [1] - BPSK, [2] - QPSK, [3] - 8PSK, [4] - 16APSK, [5] - 16QAM
%> @param softFlag [0] - ������� �������, [1] - ������ �������
%> @param SNR ��������� ������/��� (���������� ��� ������� �������)
%> @return out ���� ��� ������� �������, LLR ��� ������ ������� 
% =========================================================================
function out = demapping (symbols, constellation, softFlag, SNR)
     switch (constellation)
        case 1 % BPSK
            out = [];
            for x=1:length(symbols)
                c=symbols(x);
                if c < 0
                    out = [out 1];
                else out = [out 0]; 
                end
            end
         case 2 % QPSK
            out = [];
            z_complex = [-1-1i, 1-1i, -1+1i, 1+1i];
            z_code = [1,1; 1,0; 0,1; 0,0];
            minimal = [];
            numb = [];            
            r = abs(z_complex - symbols(:));
            [minimal, numb] = min(r,[],2);
            out = [z_code(numb(:, 1), :)];
            out=out.';
            out=out(:);
            out=out.';
         case 3 % 8PSK
             radius = 1;
             z_complex = [];
             z_code = [0,0,0; 0,0,1; 0,1,1; 0,1,0; 1,1,0; 1,1,1; 1,0,1; 1,0,0];
             for x = pi/8:pi/4:pi*2
                I = radius * cos(x);
                Q = radius * sin(x);
                z_complex = [z_complex, complex(I,Q)];
             end
             r = abs(z_complex - symbols(:));
             [minimal, numb] = min(r,[],2);
             out = [z_code(numb(:, 1), :)];
             out=out.';
             out=out(:);
             out=out.';
         case 4 % 16APSK
             radius = 1;
             z_complex = [];
             z_code = [1,1,0,0; 1,1,1,0; 1,1,1,1; 1,1,0,1; 0,0,0,0; 1,0,0,0; 1,0,1,0; 0,0,1,0;...
                       0,1,1,0; 0,1,1,1; 0,0,1,1; 1,0,1,1; 1,0,0,1; 0,0,0,1; 0,1,0,1; 0,1,0,0];
             for x = pi/4:pi/2:pi*2
                I = radius * cos(x);
                Q = radius * sin(x);
                z_complex = [z_complex, complex(I,Q)];
             end
             for x = pi/4:pi/6:pi*2+pi/5
                I = radius * 2 * cos(x);
                Q = radius * 2 * sin(x);
                z_complex = [z_complex, complex(I,Q)];
             end
             z = 0;
             for x=1:16                    
                    y = z_complex(x)*conj(z_complex(x));
                    z = z + y;
             end
             norm = sqrt(z/16);
             z_complex = z_complex/norm;
             r = abs(z_complex - symbols(:));
             [minimal, numb] = min(r,[],2);
             out = [z_code(numb(:, 1), :)];
             out=out.';
             out=out(:);
             out=out.';
         case 5 % 16QAM
                z_complex = [1+1i, 3+1i, 1+3i, 3+3i, 1-1i, 3-1i, 1-3i, 3-3i,...
                             -1+1i, -3+1i, -1+3i, -3+3i, -1-1i, -3-1i, -1-3i, -3-3i];
                z_code = [1,1,0,1; 1,0,0,1; 1,1,0,0; 1,0,0,0; 1,1,1,1; 1,0,1,1; 1,1,1,0; 1,0,1,0;...
                          0,1,0,1; 0,0,0,1; 0,1,0,0; 0,0,0,0; 0,1,1,1; 0,0,1,1; 0,1,1,0; 0,0,1,0];
                z_complex = z_complex/(sqrt((sum(z_complex(:).*conj(z_complex(:))))/numel(z_complex))); % ���������� ���������
                if softFlag == 0 % ������� �������
                    r = abs(z_complex - symbols(:));
                    [~, numb] = min(r,[],2);
                    out = [z_code(numb(:, 1), :)];
                    out=out.';
                    out=out(:);
                    out=out.';
                else % ������ �������
                    out = [];
                    for iter = 1:numel(z_code(1,:))
                        f = find(z_code(:,iter)); % ��� ������� ��� �������� �� ����
                        x = sum(exp(-1*(((abs(symbols(:) - z_complex(f))).^2)./(SNR))),2); % ���������� ���������. �������� �� ��������� �������� �������:(
                        f = find(~z_code(:,iter)); % ������� ������� ���
                        y = sum(exp(-1*(((abs(symbols(:) - z_complex(f))).^2)./(SNR))),2); % ���������� �����������. �������� �� ��������� �������� �������:(
                        out = [out, log(x./y)];
                    end
                    out=out.';
                    out=out(:);
                end
             
     end
end
