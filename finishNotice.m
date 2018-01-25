function finishNotice(method)
% Notice you when job is done
% method: 1:iPhone SMS notice 2:disp
for i = 1:length(method)
    switch method(i)
        case 1
            [y,Fs] = audioread('iPhoneSMSNotice.mp3');
            sound(y,Fs)
            pause(0.3)
            continue
        case 2
            disp('Finished')
            continue
    end
end
end

