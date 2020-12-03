%{

Canadian Coronavirus Tracker v1.0.0 | Channing Cheung

Objectives:
-Entry to the ENCMP 100 Programming Contest (Fall 2020)
-Educate & inform Canadians using accurate real time data
-Develop and grow my coding knowledge with MATLAB


Data Sources:
COVID-19 Data Repository by the Center for Systems
Science and Engineering (CSSE) at Johns Hopkins University.

Hasell, J., Mathieu, E., Beltekian, D. et al. A cross-country database of COVID-19 testing. Sci Data 7, 345 (2020). https://doi.org/10.1038/s41597-020-00688-8

Please read the README file for the full instructions, acknowledgements and
contact information.

%}

function [] = cdn_covid_tracker_v1_0_0()
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
disp('Welcome to the Canadian Coronavirus Tracker v1.0.0') %Displays welcome information
disp(' ')
disp('Please view the README file for the full instructions, acknowledgements and additional information.')

%Program loops so user can interact with menu until they click End Program
while program < 13
    %displays menu options
    program = menu('Canadian Coronavirus Tracker v1.0.0', 'Total Cases: Regional Breakdown','New Cases: Regional Breakdown','Active Cases Timeline','Total Deaths: Regional Breakdown','New Deaths: Regional Breakdown','Recovered Cases Timeline','Daily Change in Recovered Cases Timeline','Total Tests Distributed Timeline','Daily Change in Tests Distributed Timeline','World Case Comparison','World Death Comparison','Open README.txt','End Program ');
    
    %Close all figures regardless of case
    %Each case # corresponds to a different set of data
    switch program
        case 1
            close all
            confirmedcases(casetable); %Calls confirmed cases
        case 2
            close all
            newcases(casetable); %Calls new cases
        case 3
            close all
            activecases(casetable,deathtable,recoveredtable); %Calls active cases
        case 4
            close all
            confirmeddeaths(deathtable); %Calls confirmed deaths
        case 5
            close all
            newdeaths(deathtable); %Calls new deaths
        case 6
            close all
            recoveredcases(recoveredtable); %Calls confirmed recovered
        case 7
            close all
            newrecovered(recoveredtable); %Calls new recovered
        case 8
            close all
            tests(datatable2); %Calls tests completed
        case 9
            close all
            newtests(datatable2) %Calls new tests
        case 10
            close all
            cdncomp(datatable2); %Calls case comparison
        case 11
            close all
            cdncompd(datatable2); %Calls death comparison
        case 12
            close all
            type('README.txt') %Outputs README.txt
        case 13
            close all %farewell message
            disp('Thank you for using this program and I hope that you found it useful. Remember to follow local public health guidelines and stay safe. Have a good day.')
    end
end
end

function confirmedcases(casetable)

region = findgroups(casetable.('Country/Region')); %Assigns each country a group number
cdntable = casetable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
regiontable = rows2vars(regiontable); %flip to make converting dates easier
regiontable = renamevars(regiontable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"]); %rename variables
regiontable(1,:) = []; %remove 1st row
regiontable.date = datetime(regiontable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
regiontable.date = regiontable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
regiontable = movevars(regiontable,'date','Before',1); %move date to front
regiontable = removevars(regiontable,'OriginalVariableNames'); %remove unnecessary column
labels = regiontable.Properties.VariableNames; %Grabs labels from table variables
labels(:,1) = [];
regioncell = table2cell(regiontable); %Convert to cell to get date array
datearray = datetime(table2array(regiontable(:,1))); %date array for X-axis
plot(datearray,cell2mat(regioncell(:,2:end))); %plots graph
legend(labels,'Location','northeastoutside') %formatting for graph
title('Total COVID 19 Cases in Canada');
xlabel('Date');
ylabel('Confirmed Cases');

end

function confirmeddeaths(deathtable)

region = findgroups(deathtable.('Country/Region')); %Assigns each country a group number
cdntable = deathtable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
regiontable = rows2vars(regiontable); %flip to make converting dates easier
regiontable = renamevars(regiontable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"]); %rename variables
regiontable(1,:) = []; %remove 1st row
regiontable.date = datetime(regiontable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
regiontable.date = regiontable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
regiontable = movevars(regiontable,'date','Before',1); %move date to front
regiontable = removevars(regiontable,'OriginalVariableNames'); %remove unnecessary column
labels = regiontable.Properties.VariableNames; %Grabs labels from table variables
labels(:,1) = [];
regioncell = table2cell(regiontable); %Convert to cell to get date array
datearray = datetime(table2array(regiontable(:,1)));
plot(datearray,cell2mat(regioncell(:,2:end))); %plots graph
legend(labels,'Location','northeastoutside') %formatting for graph
title('Total COVID 19 Deaths in Canada');
xlabel('Date');
ylabel('Confirmed Deaths');

end

function recoveredcases(recoveredtable)

region = findgroups(recoveredtable.('Country/Region')); %Assigns each country a group number
cdntable = recoveredtable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = removevars(cdntable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regiontable = rows2vars(regiontable); %flip to make converting dates easier
regiontable.date = datetime(regiontable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
regiontable.date = regiontable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
regiontable = movevars(regiontable,'date','Before',1); %move date to front
regiontable = removevars(regiontable,'OriginalVariableNames'); %remove unnecessary column
regiontable = renamevars(regiontable,('Var1'),('Canada'));
regioncell = table2cell(regiontable); %Convert to cell to get date array
datearray = datetime(table2array(regiontable(:,1)));
plot(datearray,cell2mat(regioncell(:,2:end))); %plots graph
title('Total COVID 19 Recovered in Canada'); %formatting for graph
xlabel('Date');
ylabel('Confirmed Recovered');

end

function activecases(casetable,deathtable,recoveredtable)

region = findgroups(casetable.('Country/Region')); %Assigns each country a group number
cdntable = casetable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regiontable = rows2vars(regiontable); %As recovered cases is not sorted by country, must merge provincial data into one column to conform with it
regiontable.totalconfirmed = regiontable.Var1 + regiontable.Var2 + regiontable.Var3 + regiontable.Var4 + regiontable.Var5 + regiontable.Var6 + regiontable.Var7 + regiontable.Var8 + regiontable.Var9 + regiontable.Var10 + regiontable.Var11 + regiontable.Var12; %forms national data
regiontable = removevars(regiontable,{'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12'}); %remove unneeded columns
regiond = findgroups(deathtable.('Country/Region')); %Assigns each country a group number
cdndtable = deathtable(regiond==33,:); %Canada is #33 on the list, filters out other countries
regiondtable = cdndtable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiondtable = removevars(regiondtable,{'Country/Region','Province/State'}); %Filters out unnecessary columns
regiondtable = rows2vars(regiondtable); %As recovered cases is not sorted by country, must merge provincial data into one column to conform with it
regiondtable.totaldeaths = regiondtable.Var1 + regiondtable.Var2 + regiondtable.Var3 + regiondtable.Var4 + regiondtable.Var5 + regiondtable.Var6 + regiondtable.Var7 + regiondtable.Var8 + regiondtable.Var9 + regiondtable.Var10 + regiondtable.Var11 + regiondtable.Var12; %forms national data
regiondtable = removevars(regiondtable,{'Var1','Var2','Var3','Var4','Var5','Var6','Var7','Var8','Var9','Var10','Var11','Var12'}); %remove unneeded columns
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
title('Active COVID 19 Cases in Canada'); %formatting for graph
xlabel('Date');
ylabel('Active Cases');

end

function newcases(casetable)

region = findgroups(casetable.('Country/Region')); %Assigns each country a group number
cdntable = casetable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
newtable = diff(regiontable{:,2:end},[],2); %finds the difference in columns
newtable = table(regiontable.('Province/State'),newtable); %creates a new table that saves variable names (dates, etc) from old table
newtable = splitvars(newtable);
newtable.Properties.VariableNames = regiontable.Properties.VariableNames([1,3:end]);
newtable = rows2vars(newtable); %flips to make converting dates easier
newtable = renamevars(newtable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"]);
newtable(1,:) = []; %remove 1st row
newtable.date = datetime(newtable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
newtable.date = newtable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
newtable = movevars(newtable,'date','Before',1); %move date to front
newtable = removevars(newtable,'OriginalVariableNames'); %remove unnecessary column
labels = newtable.Properties.VariableNames; %Grabs labels from table variables
labels(:,1) = []; %remove 1st row
newcell = table2cell(newtable); %Convert to cell to get date array
datearray = datetime(table2array(newtable(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
legend(labels,'Location','northeastoutside') %formatting for graph
title('New COVID 19 Cases in Canada');
xlabel('Date');
ylabel('Confirmed Cases');

end

function newdeaths(deathtable)

region = findgroups(deathtable.('Country/Region')); %Assigns each country a group number
cdntable = deathtable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = cdntable([1 2 5:14],:); %Filters out Diamond Princess and Grand Princess from data
regiontable = removevars(regiontable,'Country/Region'); %Filters out unnecessary columns
newtable = diff(regiontable{:,2:end},[],2); %finds the difference in columns
newtable = table(regiontable.('Province/State'),newtable); %creates a new table that saves variable names (dates, etc) from old table
newtable = splitvars(newtable);
newtable.Properties.VariableNames = regiontable.Properties.VariableNames([1,3:end]);
newtable = rows2vars(newtable);
newtable = renamevars(newtable,["Var1","Var2","Var3","Var4","Var5","Var6","Var7","Var8","Var9","Var10","Var11","Var12"],["Alberta","British Columbia","Manitoba","New Brunswick","Newfoundland and Labrador","Northwest Territories","Nova Scotia","Ontario","Prince Edward Island","Quebec","Saskatchewan","Yukon"]);
newtable(1,:) = []; %remove 1st row
newtable.date = datetime(newtable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
newtable.date = newtable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
newtable = movevars(newtable,'date','Before',1); %move date to front
newtable = removevars(newtable,'OriginalVariableNames'); %remove unnecessary column
labels = newtable.Properties.VariableNames; %Grabs labels from table variables
labels(:,1) = []; %remove 1st row
newcell = table2cell(newtable); %Convert to cell to get date array
datearray = datetime(table2array(newtable(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
legend(labels,'Location','northeastoutside') %formatting for graph
title('New COVID 19 Deaths in Canada');
xlabel('Date');
ylabel('Confirmed Deaths');

end

function newrecovered(recoveredtable)

region = findgroups(recoveredtable.('Country/Region')); %Assigns each country a group number
cdntable = recoveredtable(region==33,:); %Canada is #33 on the list, filters out other countries
regiontable = removevars(cdntable,'Province/State'); %Filters out unnecessary columns
newtable = diff(regiontable{:,2:end},[],2); %finds the difference in columns
newtable = table(regiontable.('Country/Region'),newtable); %creates a new table that saves variable names (dates, etc) from old table
newtable = splitvars(newtable);
newtable.Properties.VariableNames = regiontable.Properties.VariableNames([1,3:end]);
newtable = rows2vars(newtable); %flips to make converting dates easier
newtable(1,:) = []; %remove 1st row
newtable = renamevars(newtable,('Var1'),('Canada'));
newtable.date = datetime(newtable{:,1}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
newtable.date = newtable.date + years(2000); %Add 2000 years so it displays as 2020 and not 0020
newtable = movevars(newtable,'date','Before',1); %move date to front
newtable = removevars(newtable,'OriginalVariableNames'); %remove unnecessary column
labels = newtable.Properties.VariableNames;
labels(:,1) = []; %remove 1st row
newcell = table2cell(newtable); %Convert to cell to get date array
datearray = datetime(table2array(newtable(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
legend(labels,'Location','northeastoutside') %formatting for graph
title('New COVID 19 Recovered in Canada');
xlabel('Date');
ylabel('Confirmed Recovered');

end

function tests(datatable2)

datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
datatable2 = movevars(datatable2,'date','Before',1); %moves date to front
datatable2(~ismember(datatable2.location,'Canada'),:) = []; %Gets only Canadian data
datatable2 = datatable2(:,[1 26]); %only gets dates and total tests
datatable2 = rmmissing(datatable2); %remove any NaN
newcell = table2cell(datatable2); %Convert to cell to get date array
datearray = datetime(table2array(datatable2(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
title('Tests Done in Canada'); %formatting for graph
xlabel('Date');
ylabel('Number of Tests');

end

function newtests(datatable2)

datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd'); %Converts to matlab's date format
datatable2 = movevars(datatable2,'date','Before',1); %moves date to front
datatable2(~ismember(datatable2.location,'Canada'),:) = []; %Gets only Canadian data
datatable2 = datatable2(:,[1 27]); %only gets dates and new tests
datatable2 = rmmissing(datatable2); %remove any NaN
newcell = table2cell(datatable2); %Convert to cell to get date array
datearray = datetime(table2array(datatable2(:,1)));
plot(datearray,cell2mat(newcell(:,2:end))); %plots graph
title('Tests Done in Canada'); %formatting for graph
xlabel('Date');
ylabel('New Tests');

end

function cdncomp(datatable2)

%Grab results from today
datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd');
datatable2 = movevars(datatable2,'date','Before',1);
datatable2(~ismember(datatable2.date,datetime('today')),:) = [];
datatable2 = datatable2(:,[4 5]); %Grab total case data
datatable2 = rmmissing(datatable2); %remove any NaN
location = find(strcmp('Canada',datatable2{:,1})); %locates Canada's data
cdn = datatable2(location,:);
datatable2 = sortrows(datatable2,'total_cases'); %sorts by total cases
top5 = datatable2([end-5 end-4 end-3 end-2 end-1],:); %Gets the top 5 countries
world = datatable2([end],:); %Gets world cases
rest = {'Rest of World',table2array(world(:,2)) - table2array(cdn(:,2)) - sum(table2array(top5(:,2)))}; %Calculates cases that are not in Canada/Top5 Countries
top5 = [table2cell(top5); table2cell(cdn); rest]; %merges data
top5num = cell2mat(top5(:,2)); %prepares data for plotting
labels = top5(:,1); %Grabs labels
pie(top5num); %plots chart
legend(labels) %formatting for chart'
total = table2array(world(:,2));
title(['Case Distribution | Total World Cases: ' num2str(total) ' on ' datestr(datetime('today'))''])

end

function cdncompd(datatable2)

%Grab results from today
datatable2.date = datetime(datatable2{:,4}, 'format', 'yyyy-MM-dd');
datatable2 = movevars(datatable2,'date','Before',1);
datatable2(~ismember(datatable2.date,datetime('today')),:) = [];
datatable2 = datatable2(:,[4 8]);
datatable2 = rmmissing(datatable2);
location = find(strcmp('Canada',datatable2{:,1}));
cdn = datatable2(location,:);
datatable2 = sortrows(datatable2,'total_deaths');
top5 = datatable2([end-5 end-4 end-3 end-2 end-1],:);
world = datatable2(end,:);
rest = {'Rest of World',table2array(world(:,2)) - table2array(cdn(:,2)) - sum(table2array(top5(:,2)))};
top5 = [table2cell(top5); table2cell(cdn); rest];
top5num = cell2mat(top5(:,2));
labels = top5(:,1); %Grabs labels
pie(top5num) %plots chart
legend(labels) %formatting for chart
total = table2array(world(:,2));
title(['Death Distribution | Total World Deaths: ' num2str(total) ' on ' datestr(datetime('today'))''])

end