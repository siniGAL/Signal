% Отображение бит на совездие
%> @file mapping.m
% =========================================================================
%> @brief Отображение бит на созвездие
%> @param bits биты, отображаемые на созвездие (должно быть кратно числу бит
%> на точку созвездия)
%> @param constellation условное обозначение для типа модуляции:
%> [1] - BPSK, [2] - QPSK, [3] - 8PSK, [4] - 16APSK, [5] - 16QAM
%> @return symbols точки в IQ пространстве
%> @warning Созвездие должно быть нормированно по мощности на 1.
%> Расположение точек созвездия должно совпадать с заданным в задании.
%> Полезными при выполнении будут такие функции, как bi2de и reshape 
% =========================================================================
function symbols = mapping (bits, constellation, BitInSym)
    switch (constellation)
        case 1 % BPSK
            symbols = [];
            for i=1:length(bits)
                c=bits(i);
            if c == 1
            symbols = [symbols -1];
            else symbols = [symbols 1]; 
            end
            end
        case 2 % QPSK
            symbols = [];
            N = length(bits)/4;
            z1 = [-1-1i];
            z2 = [-1+1i];
            z3 = [1+1i];
            z4 = [1-1i];
            y = 0;            
            for i=1:2:length(bits)
                c=bits(i:i+1);
                if c == [0 0];
                    x = z1*conj(z1);
                    y = y + x;
                elseif c == [0 1];
                    x = z2*conj(z2);
                    y = y + x;
                elseif c == [1 1];
                    x = z3*conj(z3);
                    y = y + x;
                elseif c == [1 0];
                    x = z4*conj(z4);
                    y = y + x;
                end
            end
            norm = sqrt(y/N);
            for i=1:2:length(bits)
                c=bits(i:i+1);
                if c == [0 0];
                    symbols = [symbols z3/norm];
                elseif c == [0 1];
                   symbols = [symbols z2/norm];
                elseif c == [1 1];
                    symbols = [symbols z1/norm];
                elseif c == [1 0];
                    symbols = [symbols z4/norm];
                end
            end
            
        case 3 % 8PSK
            r = 1;
            angle_start = pi/8;
            symbol = [];
            symbols = [];
            for angle_fi = angle_start:pi/4:pi*2
                I = r*cos(angle_fi);
                Q = r*sin(angle_fi);                
                symbol = [symbol complex(I,Q)];
            end
            for bit = 1:3:length(bits)
                    i = bits(bit:bit+2);
                    if i == [0 0 0];
                        symbols = [symbols symbol(1)];
                        elseif i == [0 0 1];
                        symbols = [symbols symbol(2)];
                        elseif i == [0 1 1];
                        symbols = [symbols symbol(3)];
                        elseif i == [1 0 1];
                        symbols = [symbols symbol(7)];
                        elseif i == [0 1 0];
                        symbols = [symbols symbol(4)];
                        elseif i == [1 0 0];
                        symbols = [symbols symbol(8)];
                        elseif i == [1 1 0];
                        symbols = [symbols symbol(5)];
                        elseif i == [1 1 1];
                        symbols = [symbols symbol(6)];
                    end
            end
        case 4 % 16APSK
            r = 1;
            angle_start = 45;
            symbol = [];
            symbols = [];
            for angle_fi = angle_start:90:360
                I = r*cosd(angle_fi);
                Q = r*sind(angle_fi);                
                symbol = [symbol complex(I,Q)];
            end
                   
            for angle_fi = angle_start:30:400
                I = r*2*cosd(angle_fi);
                Q = r*2*sind(angle_fi);                
                symbol = [symbol complex(I,Q)];
            end
                    y = 0;
                for i=1:16                    
                    x = symbol(i)*conj(symbol(i));
                    y = y + x;
                end
            norm = sqrt(y/16);
                 
                 for bit = 1:4:length(bits)
                    i = bits(bit:bit+3);
                    if i == [0 0 0 0];
                            symbols = [symbols symbol(5)/norm];
                        elseif i == [1 1 1 0];
                            symbols = [symbols symbol(2)/norm];
                        elseif i == [1 1 1 1];
                            symbols = [symbols symbol(3)/norm];
                        elseif i == [1 1 0 1];
                            symbols = [symbols symbol(4)/norm];
                        elseif i == [ 1 1 0 0];
                            symbols = [symbols symbol(1)/norm];
                        elseif i == [1 0 0 0];
                            symbols = [symbols symbol(6)/norm];
                        elseif i == [1 0 1 0];
                            symbols = [symbols symbol(7)/norm];
                        elseif i == [0 0 1 0];
                            symbols = [symbols symbol(8)/norm];
                        elseif i == [0 1 1 0];
                            symbols = [symbols symbol(9)/norm];
                        elseif i == [0 1 1 1];
                            symbols = [symbols symbol(10)/norm];
                        elseif i == [0 0 1 1];
                            symbols = [symbols symbol(11)/norm];
                        elseif i == [1 0 1 1];
                            symbols = [symbols symbol(12)/norm];
                        elseif i == [1 0 0 1];
                            symbols = [symbols symbol(13)/norm];
                        elseif i == [0 0 0 1];
                            symbols = [symbols symbol(14)/norm];
                        elseif i == [0 1 0 1];
                            symbols = [symbols symbol(15)/norm];
                        elseif i == [0 1 0 0];
                            symbols = [symbols symbol(16)/norm];
                    end
                 end
            case 5 % 16QAM
                dots = [1+1i, 3+1i, 1+3i, 3+3i, -1+1i, -3+1i, -1+3i, -3+3i, -1-1i, -3-1i, -1-3i, -3-3i, 1-1i, 3-1i, 1-3i, 3-3i];
                y = 0;
                symbols = [];
                for i=1:16
                    x = dots(i)*conj(dots(i));
                    y = y + x;
                end
                norm = sqrt(y/length(dots));
                for bit = 1:4:length(bits)
                    i = bits(bit:bit+3);
                    if i == [ 1 1 0 1];
                    symbols = [symbols dots(1)/norm];
                    elseif i == [1 0 0 1]
                    symbols = [symbols dots(2)/norm];
                    elseif i == [1 1 0 0];
                    symbols = [symbols dots(3)/norm];
                    elseif i == [1 0 0 0];
                    symbols = [symbols dots(4)/norm];
                    elseif i == [0 1 0 1];
                    symbols = [symbols dots(5)/norm];
                    elseif i == [0 0 0 1];
                    symbols = [symbols dots(6)/norm];
                    elseif i == [0 1 0 0];
                    symbols = [symbols dots(7)/norm];
                    elseif i == [0 0 0 0];
                    symbols = [symbols dots(8)/norm];
                    elseif i == [0 1 1 1];
                    symbols = [symbols dots(9)/norm];
                    elseif i == [0 0 1 1];
                    symbols = [symbols dots(10)/norm];
                    elseif i == [0 1 1 0];
                    symbols = [symbols dots(11)/norm];
                    elseif i == [0 0 1 0];
                    symbols = [symbols dots(12)/norm];
                    elseif i == [1 1 1 1];
                    symbols = [symbols dots(13)/norm];
                    elseif i == [1 0 1 1];
                    symbols = [symbols dots(14)/norm];
                    elseif i == [1 1 1 0];
                    symbols = [symbols dots(15)/norm];
                    elseif i == [1 0 1 0];
                    symbols = [symbols dots(16)/norm];
                    end
                end
    end                    
    %> @todo место для вашей функции
end