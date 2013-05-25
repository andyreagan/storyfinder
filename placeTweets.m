clear all

cities_tiger = m_shaperead('tl_2010_us_uac10');

% where is this used?
geoids_tiger = str2num(char(cities_tiger.GEOID10));

% this is the input file: "tweetID","lat","lon"
tmp = getenv('FILENAME');
disp(tmp);

% load that input data as CSV
TweetLoc= csvread(tmp);
tweetLat=TweetLoc(:,1);
tweetLon=TweetLoc(:,2);
tweetID=TweetLoc(:,3);

% where to put: "tweetID","city"
tmp = getenv('FILENAME2');
disp(tmp);
fileID = fopen(tmp,'w');

% where to put "txt","city"
% tmp = getenv('FILENAME3');
% disp(tmp);
% file2 = importdata(tmp);

% for reference
% Cities={'New York--Newark, NY--NJ--CT','Los Angeles--Long Beach--Anaheim, CA','Chicago, IL--IN','Houston, TX','Philadelphia, PA--NJ--DE--MD','Phoenix--Mesa, AZ','San Antonio, TX','San Diego, CA','Dallas--Fort Worth--Arlington, TX','San Jose, CA','Jacksonville, FL','Indianapolis, IN','Austin, TX','San Francisco--Oakland, CA','Columbus, OH','Charlotte, NC--SC','Detroit, MI','El Paso, TX--NM','Memphis, TN--MS--AR','Boston, MA--NH--RI','Seattle, WA','Denver--Aurora, CO','Baltimore, MD','Washington, DC--VA--MD','Portland, OR--WA','Burlington, VT'};

% #ugly
% CityNum=[59 1020 2955 561 947 906 844 1173 379 1177 2826 3162 163 1174 3454 2328 1861 1748 1602 2160 1341 321 265 421 1335 3225];

allnames = cities_tiger.NAME10;
alllatlon = cities_tiger.ncst;

% loop over each city?
for CityNumber = 1:3592
  
  latlon = alllatlon{CityNumber};
  
  cityname = allnames(CityNumber);
  % are there more than one city name for each city number?
  thisCity = cityname{1};
  
  thisCityInds = find(inpolygon(tweetLon,tweetLat,latlon(:,1),latlon(:,2)));
    
    for n = 1:length(thisCityInds)
      thisTweep = tweetID(thisCityInds(n));
      fprintf(fileID,'\"%d\",\"%s\"\n',thisTweep,thisCity);
      % something to print the city text files, use find rather than loop
    end
    %if find(CityNumber == CityNum) % check the city
    %  % print into that city file, the corresponding text from text file
    %  filename = strcat(base,CityNum(i),'.txt')
    %  f = fopen(filename,'a')
    %  for n = 1:length(thisCityInds)
    %    thisTweep = tweetsTxts{n};
    %    fprintf(f,'%s\n',)
    %  end
    %end
end  
  
fclose(fileID);

exit
