% –û–±—Ä–∞—Ç–Ω–æ–µ –æ—Ç–æ–±—Ä–∞–∂–µ–Ω–∏–µ —Ç–æ—á–µ–∫ —Å–æ–∑–≤–µ–∑–¥–∏—è UTF
%> @file demapping.m
% =========================================================================
%> @brief –û—Ç–æ–±—Ä–∞–∂–µ–Ω–∏–µ –±–∏—Ç –Ω–∞ —Å–æ–∑–≤–µ–∑–¥–∏–µ
%> @param symbols —Ç–æ—á–∫–∏ –≤ IQ –ø—Ä–æ—Å—Ç—Ä–∞–Ω—Å—Ç–≤–µ
%> @param constellation —É—Å–ª–æ–≤–Ω–æ–µ –æ–±–æ–∑–Ω–∞—á–µ–Ω–∏–µ –¥–ª—è —Ç–∏–ø–∞ –º–æ–¥—É–ª—è—Ü–∏–∏:
%> [1] - BPSK, [2] - QPSK, [3] - 8PSK, [4] - 16APSK, [5] - 16QAM
%> @param softFlag [0] - –∂–µ—Å—Ç–∫–æ–µ —Ä–µ—à–µ–Ω–∏–µ, [1] - –º—è–≥–∫–æ–µ —Ä–µ—à–µ–Ω–∏–µ
%> @param SNR –æ—Ç–Ω–æ—à–µ–Ω–∏–µ —Å–∏–≥–Ω–∞–ª/—à—É–º (–Ω–µ–æ–±—Ö–æ–¥–∏–º–æ –¥–ª—è –º—è–≥–∫–æ–≥–æ —Ä–µ—à–µ–Ω–∏—è)
%> @return out –±–∏—Ç—ã –ø—Ä–∏ –∂–µ—Å—Ç–∫–æ–º —Ä–µ—à–µ–Ω–∏–∏, LLR –ø—Ä–∏ –º—è–≥–∫–æ–º —Ä–µ—à–µ–Ω–∏–∏ 
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
                z_complex = z_complex/(sqrt((sum(z_complex(:).*conj(z_complex(:))))/numel(z_complex))); % ÕÓÏËÓ‚Í‡ ÒÓÁ‚ÂÁ‰Ëˇ
                if softFlag == 0 % ∆ÂÒÚÍÓÂ Â¯ÂÌËÂ
                    r = abs(z_complex - symbols(:));
                    [~, numb] = min(r,[],2);
                    out = [z_code(numb(:, 1), :)];
                    out=out.';
                    out=out(:);
                    out=out.';
                else % Ãˇ„ÍÓÂ Â¯ÂÌËÂ
                    out = [];
                    for iter = 1:numel(z_code(1,:))
                        for x = 1:numel(symbols)
                            % ◊ËÒÎËÚÂÎ¸
                            f1 = find(z_code(:,iter));
                            y = (real(symbols(x)) - real(z_complex(f1))) + (imag(symbols(x)) - imag(z_complex(f1)));
%                             y = abs(y);
                            y = y.^2;
                            y = y./SNR;
                            y = exp(-1*y);
                            y = sum(y);
                            % «Ì‡ÏÂÌ‡ÚÂÎ¸
                            f0 = find(~z_code(:,iter));
                            z = (real(symbols(x)) - real(z_complex(f0))) + (imag(symbols(x)) - imag(z_complex(f0)));
%                             z = abs(z);
                            z = z.^2;
                            z = z./SNR;
                            z = exp(-1*z);
                            z = sum(z);
                            out = [out; log(y/z)];
                        end
                        
                        
%                         f = find(z_code(:,iter)); % ÕÓÏÂ‡ ÔÓÁËˆËÈ ÌÂ ÌÛÎÂ‚˚ı ·ËÚ
%                         x = sum(exp(-1*(((abs(symbols(:) - z_complex(f))).^2)./(SNR))),2); % ¬˚˜ËÒÎÂÌËÂ ˜ËÒÎËÚÂÎˇ. ¬ÓÁÏÓÊÌÓ Á‰ÂÒ¸ Ó¯Ë·Í‡ :(
%                         f = find(~z_code(:,iter)); % ÕÓÏÂ‡ ÔÓÁËˆËÈ ÌÛÎÂ‚˚ı ·ËÚ
%                         y = sum(exp(-1*(((abs(symbols(:) - z_complex(f))).^2)./(SNR))),2); % ¬˚˜ËÒÎÂÌËÂ ÁÌ‡ÏÂÌ‡ÚÂÎˇ. ¬ÓÁÏÓÊÌÓ Á‰ÂÒ¸ Ó¯Ë·Í‡ :(
%                         out = [out, log(x./y)];
                     end
%                     out=out.';
%                     out=out(:);
                end
             
     end
end
