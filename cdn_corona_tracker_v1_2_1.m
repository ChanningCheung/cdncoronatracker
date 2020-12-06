%{
Canadian Coronavirus Tracker v1.2.0 | Channing Cheung

Objectives:
-Entry to the ENCMP 100 Programming Contest (Fall 2020)
-Educate & inform Canadians using accurate real time data
-Develop and grow my coding knowledge with MATLAB

Data Sources:
COVID-19 Data Repository by the Center for Systems
Science and Engineering (CSSE) at Johns Hopkins University.

Hasell, J., Mathieu, E., Beltekian, D. et al. A cross-country database of COVID-19 testing. Sci Data 7, 345 (2020). https://doi.org/10.1038/s41597-020-00688-8

Please read the README file for the full instructions, acknowledgements and contact information.
%}

function [] = cdn_corona_tracker_v1_2_1()
clc;clear %Clear command window & workspace
options = weboptions('Timeout',inf); %This fixes a potential error caused by timeout

%Imports case data from COVID-19 Data Repository by the Center for Systems
%Science and Engineering (CSSE) at Johns Hopkins University
%(https://github.com/CSSEGISandData/COVID-19)
urlcases = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv';
cases = 'cases.csv';
websave(cases,urlcases,options);
casetable = readtable('cases.csv','ReadVariableNames',true,'PreserveVariableNames',true);
casetable = removevars(casetable,{'Lat','Long'});

%Imports death data from COVID-19 Data Repository by the Center for Systems
%Science and Engineering (CSSE) at Johns Hopkins University
%(https://github.com/CSSEGISandData/COVID-19)
urldeaths = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv';
deaths = 'deaths.csv';
websave(deaths,urldeaths,options);
deathtable = readtable('deaths.csv','ReadVariableNames',true,'PreserveVariableNames',true);
deathtable = removevars(deathtable,{'Lat','Long'});

%Imports recovered data from COVID-19 Data Repository by the Center for Systems
%Science and Engineering (CSSE) at Johns Hopkins University
%(https://github.com/CSSEGISandData/COVID-19)
urlrecovered = 'https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv';
recovered = 'recovered.csv';
websave(recovered,urlrecovered,options);
recoveredtable = readtable('recovered.csv','ReadVariableNames',true,'PreserveVariableNames',true);
recoveredtable = removevars(recoveredtable,{'Lat','Long'});

%Imports COVID-19 data from Hasell, J., Mathieu, E., Beltekian, D. et al. A cross-country database of COVID-19 testing. Sci Data 7, 345 (2020). https://doi.org/10.1038/s41597-020-00688-8
urldata2 = 'https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/owid-covid-data.csv';
data2 = 'data.csv';
websave(data2,urldata2,options);
datatable2 = readtable('data.csv','ReadVariableNames',true,'PreserveVariableNames',true);

program = 0; %Initializes variable
disp('Welcome to the Canadian Coronavirus Tracker v1.2.1') %Displays welcome information
disp(' ')
disp('Please click on the Information button to view the README.txt file for the full instructions, acknowledgements and additional details.')
disp(' ')

%Program loops so user can interact with menu until they click End Program
while program < 13
    %displays menu options
    program = menu('Canadian Coronavirus Tracker v1.2.1', 'Total Cases','Daily Change in Cases','Active Cases','Total Deaths','Daily Change in Deaths','Recovered Cases','Daily Change in Recovered Cases','Total People Tested','Daily Change in People Tested','World Case Comparison','World Death Comparison','Information','End Program ');
    %Close all figures regardless of case
    %Each case # corresponds to a different set of data
    switch program
        case 1
            close all
            ylb = 'Count of Total Cases'; %Sets specific y-label, title and selection to be used later
            ttl = 'Total COVID-19 Cases in Canada';
            sel = 1;
            confirmed(casetable,ylb,ttl,sel); %Calls confirmed cases
        case 2
            close all
            ylb = 'Count of Confirmed Cases';
            ttl = 'Daily Change in the Number of Cases'; %Sets specific y-label, title and selection to be used later
            sel = 1;
            new(casetable,ylb,ttl,sel); %Calls new cases
        case 3
            close all
            activecases(casetable,deathtable,recoveredtable); %Calls active cases
        case 4
            close all
            ylb = 'Count of Total Deaths'; %Sets specific y-label, title and selection to be used later
            ttl = 'Total COVID-19 Deaths in Canada';
            sel = 1;
            confirmed(deathtable,ylb,ttl,sel); %Calls confirmed deaths
        case 5
            close all
            ylb = 'Count of Confirmed Deaths';
            ttl = 'Daily Change in the Number of Deaths'; %Sets specific y-label, title and selection to be used later
            sel = 1;
            new(deathtable,ylb,ttl,sel); %Calls new deaths
        case 6
            close all
            ylb = 'Count of Total Recovered'; %Sets specific y-label, title and selection to be used later
            ttl = 'Total COVID-19 Recovered in Canada';
            sel = 2;
            confirmed(recoveredtable,ylb,ttl,sel); %Calls confirmed recovered
        case 7
            close all
            ylb = 'Count of Confirmed Recovered'; %Sets specific y-label, title and selection to be used later
            ttl = 'Daily Change in the Number of People Recovered';
            sel = 2;
            new(recoveredtable,ylb,ttl,sel); %Calls new recovered
        case 8
            close all
            ylb = 'Count of Total People Tested'; %Sets specific y-label,title and number to grab from
            ttl = 'Total Tests in Canada';
            num = 26;
            tests(datatable2,ylb,ttl,num); %Calls tests completed
        case 9
            close all
            ylb = 'Count of People Tested'; %Sets specific y-label,title and number to grab from
            ttl = 'Daily Change in the Number of People Tested';
            num = 27;
            tests(datatable2,ylb,ttl,num) %Calls new tests
        case 10
            close all
            num = 5; %Sets specific number to grab from, title name and column variable name
            ttl = 'Cases';
            sort = 'total_cases';
            cdncomp(datatable2,num,ttl,sort); %Calls case comparison
        case 11
            close all
            num = 8; %Sets specific number to grab from, title name and column variable name
            ttl = 'Deaths';
            sort = 'total_deaths';
            cdncomp(datatable2,num,ttl,sort); %Calls death comparison
        case 12
            close all
            type('README.txt') %Outputs README.txt
        case 13
            close all %farewell message
            disp('Thank you for using this program and I hope that you found it useful. Remember to follow local public health guidelines and stay safe. Have a good day.')
    end
end
end

function confirmed(tb,ylb,ttl,sel)
region = findgroups(tb.('Country/Region')); %Assigns each country a group number
cdntable = tb(region==33,:); %Canada is #33 on the list, filters out other countries
if sel == 1 %Action based on selection number set above
    regiontable = cdntable([1 2 5:16],:); %Filters out Diamond Princess and Grand Princess from data
    regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
    regiontable = rows2vars(regiontable); %flip to make converting dates easier
    regiontable = renamevars(regiontable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12","Var13","Var14"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Nunavut","Ontario","Prince Edward Island","Quebec","Repatraited Travellers","Saskatchewan","Yukon"]); %rename variables
    regiontable(1,:) = []; %remove 1st row
else
    regiontable = removevars(cdntable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
    regiontable = rows2vars(regiontable); %flip to make converting dates easier
    regiontable = renamevars(regiontable,('Var1'),('Canada'));
end
regiontable.date = datetime(regiontable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
regiontable.date = regiontable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
regiontable = movevars(regiontable,'date','Before',1); %move date to front
regiontable = removevars(regiontable,'OriginalVariableNames'); %remove unnecessary column
regioncell = table2cell(regiontable); %Convert to cell to get date array
datearray = datetime(table2array(regiontable(:,1))); %date array for X-axis
plot(datearray,cell2mat(regioncell(:,2:end))); %plots graph
if sel == 1
    labels = regiontable.Properties.VariableNames; %Grabs labels from table variables
    labels(:,1) = [];
    legend(labels,'Location','northeastoutside') %formatting for graph
end
ylim([0 inf]) %Initial display only shows positive data for better visibility, negative data (corrections) can be viewed by panning
xlabel('Reporting Date'); %Graph formatting
ylabel(ylb);
title(ttl);
end

function tests(datatable2,ylb,ttl,num)
datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
datatable2 = movevars(datatable2,'date','Before',1); %moves date to front
datatable2(~ismember(datatable2.location,'Canada'),:) = []; %Gets only Canadian data
datatable2 = datatable2(:,[1 num]); %only gets dates and total tests
datatable2 = rmmissing(datatable2); %remove any NaN
newcell = table2cell(datatable2); %Convert to cell to get date array
datearray = datetime(table2array(datatable2(:,1))); %date array for x-axis
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
title(ttl); %formatting for graph
xlabel('Reporting Date');
ylabel(ylb);
ylim([0 inf]) %Initial display only shows positive data for better visibility, negative data (corrections) can be viewed by panning
end

function cdncomp(datatable2,num,ttl,sort)
datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd'); %Grab results from yesterday
datatable2 = movevars(datatable2,'date','Before',1);
datatable2(~ismember(datatable2.date,datetime('yesterday')),:) = [];
datatable2 = datatable2(:,[4 num]); %Grab total case data
datatable2 = rmmissing(datatable2); %remove any NaN
location = find(strcmp('Canada',datatable2{:,1})); %locates Canada's data
cdn = datatable2(location,:);
datatable2 = sortrows(datatable2,sort); %sorts by total cases
top10 = datatable2([end-10 end-9 end-8 end-7 end-6 end-5 end-4 end-3 end-2 end-1],:); %Gets the top 10 countries
world = datatable2(end,:); %Gets world cases
rest = {'Rest of World',table2array(world(:,2)) - table2array(cdn(:,2)) - sum(table2array(top10(:,2)))}; %Calculates cases that are not in Canada/Top 10 Countries
top10 = [table2cell(top10); table2cell(cdn); rest]; %merges data
top10num = cell2mat(top10(:,2)); %prepares data for plotting
labels = top10(:,1); %Grabs labels
pie(top10num); %plots chart
legend(labels,'Location','northeastoutside') %formatting for chart
total = table2array(world(:,2)); %Calculates all cases
title([ttl ' Distribution | Total World ' ttl ': ' num2str(total)]) %title format
end

function new(tb,ylb,ttl,sel)
region = findgroups(tb.('Country/Region')); %Assigns each country a group number
cdntable = tb(region==33,:); %Canada is #33 on the list, filters out other countries
if sel == 1 %Action based on selection number set above
    regiontable = cdntable([1 2 5:16],:); %Filters out Diamond Princess and Grand Princess from data
    regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
    newtable = diff(regiontable{:,2:end},[],2); %finds the difference in columns
    newtable = table(regiontable.('Province/State'),newtable); %creates a new table that saves variable names (dates, etc) from old table
else
    regiontable = removevars(cdntable,'Province/State'); %Filters out unnecessary columns
    newtable = diff(regiontable{:,2:end},[],2); %finds the difference in columns
    newtable = table(regiontable.('Country/Region'),newtable); %creates a new table that saves variable names (dates, etc) from old table
end
newtable = splitvars(newtable); %Prep for date conversion
newtable.Properties.VariableNames = regiontable.Properties.VariableNames([1,3:end]);
newtable = rows2vars(newtable);
newtable(1,:) = []; %remove 1st row
if sel == 1 %Action based on selection number set above
    newtable = renamevars(newtable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12","Var13","Var14"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Nunavut","Ontario","Prince Edward Island","Quebec","Repatraited Travellers","Saskatchewan","Yukon"]); %rename variables
else
    newtable = renamevars(newtable,('Var1'),('Canada')); %rename variable
end
newtable.date = datetime(newtable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
newtable.date = newtable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
newtable = movevars(newtable,'date','Before',1); %move date to front
newtable = removevars(newtable,'OriginalVariableNames'); %remove unnecessary column
labels = newtable.Properties.VariableNames; %Grabs labels from table variables
labels(:,1) = []; %remove 1st row
newcell = table2cell(newtable); %Convert to cell to get date array
datearray = datetime(table2array(newtable(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
if sel == 1
    legend(labels,'Location','northeastoutside') %formatting for graph
end
title(ttl); %Graph formatting
xlabel('Reporting Date');
ylabel(ylb);
ylim([0 inf]) %Initial display only shows positive data for better visibility, negative data (corrections) can be viewed by panning
end

function activecases(casetable,deathtable,recoveredtable)
region = findgroups(casetable.('Country/Region')); %Assigns each country a group number
cdntable = casetable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:16],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regiontable = rows2vars(regiontable); %As recovered cases is not sorted by country, must merge provincial data into one column to conform with it
regiontable.totalconfirmed = regiontable.Var1 + regiontable.Var2 + regiontable.Var3 + regiontable.Var4 + regiontable.Var5 + regiontable.Var6 + regiontable.Var7 + regiontable.Var8 + regiontable.Var9 + regiontable.Var10 + regiontable.Var11 + regiontable.Var12 + regiontable.Var13 + regiontable.Var14; %forms national data
regiontable = removevars(regiontable,{'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13','Var14'}); %remove unneeded columns
regiond = findgroups(deathtable.('Country/Region')); %Assigns each country a group number
cdndtable = deathtable(regiond==33,:); %Canada is #33 on the list, filters out other countries
regiondtable = cdndtable([1 2 5:16],:); %Filters out Diamond Princess and Grand Princess from data
regiondtable = removevars(regiondtable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regiondtable = rows2vars(regiondtable); %As recovered cases is not sorted by country, must merge provincial data into one column to conform with it
regiondtable.totaldeaths = regiondtable.Var1 + regiondtable.Var2 + regiondtable.Var3 + regiondtable.Var4 + regiondtable.Var5 + regiondtable.Var6 + regiondtable.Var7 + regiondtable.Var8 + regiondtable.Var9 + regiondtable.Var10 + regiondtable.Var11 + regiondtable.Var12 + regiondtable.Var13 + regiondtable.Var14; %forms national data
regiondtable = removevars(regiondtable,{'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12','Var13','Var14'}); %remove unneeded columns
regionr = findgroups(recoveredtable.('Country/Region')); %Assigns each country a group number
cdnrtable = recoveredtable(regionr==33,:); %Canada is #33 on the list, filters out other countries
regionrtable = removevars(cdnrtable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regionrtable = rows2vars(regionrtable); %Flips to conform with other data
regionrtable = renamevars(regionrtable,('Var1'),('totalrecovered'));
activetable = join(regiontable,regiondtable); %merge 3 tables into 1 table
activetable = join(activetable, regionrtable);
activetable.ActiveCases = activetable.totalconfirmed - activetable.totaldeaths - activetable.totalrecovered; %Active = Confirmed - Deaths - Recovered
activetable.date = datetime(activetable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
activetable.date = activetable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
activetable = removevars(activetable,{'totalconfirmed','totaldeaths','totalrecovered','OriginalVariableNames'}); %remove excess columns
activetable = activetable(:,[2 1]); %switch order of columns
plot(activetable.date, activetable.ActiveCases); %plots graph
title('Active Cases of COVID-19 in Canada'); %formatting for graph
xlabel('Reporting Date');
ylabel('Count of Active Cases');
ylim([0 inf]) %Initial display only shows positive data for better visibility, negative data (corrections) can be viewed by panning
end
