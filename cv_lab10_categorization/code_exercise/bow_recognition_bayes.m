function label = bow_recognition_bayes(histogram, vBoWPos, vBoWNeg)


[muPos sigmaPos] = computeMeanStd(vBoWPos);
[muNeg sigmaNeg] = computeMeanStd(vBoWNeg);

K = size(histogram, 2);

p_car = 0.5;
p_not_car = 1 - p_car;
% Calculating the probability of appearance each word in observed histogram
% according to normal distribution in each of the positive and negative bag of words

p_hist_car = 0;
p_hist_not_car = 0;
for i=1:K
    pos_log = log(pdf('norm', histogram(i), muPos(i), sigmaPos(i)));
    if(~isnan(pos_log))
        p_hist_car = p_hist_car + pos_log;
    end
    neg_log = log(pdf('norm', histogram(i), muNeg(i), sigmaNeg(i)));
    if(~isnan(neg_log))
       p_hist_not_car = p_hist_not_car + neg_log; 
    end
end

%leave out normalization
label = double((p_hist_car + log(p_car)) > (p_hist_not_car + log(p_not_car)));
end