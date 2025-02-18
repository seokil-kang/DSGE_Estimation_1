% Collect U.S. observables for Small Scale NK Model

% house keeping
clear; close all; clc;

% set data infos from FRED
FredDataInfos = [
    "GDPC1","mean","GDP"
    "CNP16OV","mean","POP"
    "CPIAUCSL","mean","CPI"
    "FEDFUNDS","mean","FFR"
    ];

% add a column for recordings
FredDataInfos = horzcat(FredDataInfos,strings(size(FredDataInfos,1),1));

% collect obs on a timetable
FredDataTable = timetable();
for j = 1:size(FredDataInfos,1)
    NewTableVars = array2timetable(fetch(fred('https://fred.stlouisfed.org/'),FredDataInfos(j,1)).Data(:,end),"RowTimes",datetime(fetch(fred('https://fred.stlouisfed.org/'),FredDataInfos(j,1)).Data(:,1),"ConvertFrom","datenum"),"VariableNames",FredDataInfos(j,3));
    FredDataInfos(j,end) = strrep(string(fetch(fred('https://fred.stlouisfed.org/'),FredDataInfos(j,1)).Frequency)," ","");
    if FredDataInfos(j,end) ~= "Quarterly"
        NewTableVars = convert2quarterly(NewTableVars,"Aggregation",FredDataInfos(j,2));
        NewTableVars.Time = dateshift(NewTableVars.Time,"start","quarter");
    end
    FredDataTable = synchronize(FredDataTable,NewTableVars);
end

% trimming the missing values
FredDataTable = rmmissing(FredDataTable);

% data transforming
Obs = array2timetable(diff(log(FredDataTable.GDP)-log(FredDataTable.POP))*1e2,"VariableNames","YGR","RowTimes",FredDataTable.Time(2:end));
Obs.INFL = diff(log(FredDataTable.CPI))*4e2;
Obs.INT= FredDataTable.FFR(2:end);

% print figure of obs?
if false
LW = 3;
FTSZ = 18;
figure(Name="Macro Variables",Color="w",Position=[200,200,[1600,900]*.6])
tiledlayout(1,1,"TileSpacing","compact","Padding","compact")
nexttile;
hold on
p1=plot(Obs.Time,Obs.YGR,LineWidth=LW,DisplayName="Y");
p2=plot(Obs.Time,Obs.INFL,LineWidth=LW,DisplayName="\pi");
p3=plot(Obs.Time,Obs.INT,LineWidth=LW,DisplayName="R");
hold off
set(gca,fontsize=FTSZ)
recessionplot
legend([p1,p2,p3],Orientation="horizontal",Location="northoutside",NumColumns=3,Box="off")
end

% save obs as a csv file
delete obs.csv
writetable(timetable2table(Obs,ConvertRowTimes=false),"obs.csv")