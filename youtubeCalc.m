function value = youtubeCalc(v0,s0,V0,v1,s1,V1) % views subs vids
    dViews = v1 - v0;
    dSubs = s1 - s0;
    dVids = V1 - V0;
    
    dh = 30 * 24 * 6;
    opt = 10000;
    
    value = (1 + exp((35000 - opt)/25000) - exp(1)) * 10*v1/s1 * exp(dViews/v1) * exp(dSubs/s1) * exp(dVids/V1) * (1 + sqrt((exp(dViews/v1) + exp(dSubs/s1) + exp(dVids/V1)))) * log(1 + (exp(dViews/v1) + exp(dSubs/s1) + exp(dVids/V1))/3);
    
    if(dViews == 0 && dSubs == 0 && dVids == 0)
        value = value * dh/(dh+1); % value = old_value * dh/(dh+1);
    end
end

% 'views' => '19417201','subscribers' => '230000','video_count' => '82'
%
% 'views' => '19567106','subscribers' => '231000','video_count' => '82'
% 'views' => '19567303','subscribers' => '231000','video_count' => '82'
%
% youtubeCalc(19417201,230000,82,19567303,231000,82)
% youtubeCalc(19567106,231000,82,19567303,231000,82)

% 'views' => '295681702','subscribers' => '2010696','video_count' => '306'
%
% 'views' => '317214001','subscribers' => '2120000','video_count' => '319'
% 'views' => '317294658','subscribers' => '2120000','video_count' => '319'
%
% youtubeCalc(295681702,2010696,306,317294658,2120000,319)
% youtubeCalc(317214001,2120000,319,317294658,2120000,319)

% 'views' => '2233','subscribers' => '168','video_count' => '21'
%
% 'views' => '2669','subscribers' => '176','video_count' => '21'
% 'views' => '2672','subscribers' => '176','video_count' => '21'
%
% youtubeCalc(2233,168,21,2672,176,21)
% youtubeCalc(2669,176,21,2672,176,21)