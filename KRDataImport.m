% Collect KR observables for Small Scale NK Model

% house keeping
clear; close all; clc;
addpath("submodules\")
bokcolormapsetting
KoreanBusinessCyclePeriods
ECOS = synchronize(...
ecosApi("200Y104","Q","startDate",datetime(1060,1,1),"endDate",datetime('now'),"item1","1400","FirstDate",true),...
ecosApi("901Y027","Q","startDate",datetime(1060,1,1),"endDate",datetime('now'),"item1","I61A","item2","I28B","FirstDate",true),...
ecosApi("901Y010","Q","startDate",datetime(1060,1,1),"endDate",datetime('now'),"item1","00","FirstDate",true),...
ecosApi("721Y001","Q","startDate",datetime(1060,1,1),"endDate",datetime('now'),"item1","1010000","FirstDate",true)...
);
rmpath("submodules\")

ECOS.Properties.VariableNames = ["GDP","POP","CPI","CALL"];
ECOS = rmmissing(ECOS);


% data transforming
Obs = array2timetable(diff(log(ECOS.GDP)-log(ECOS.POP))*1e2,"VariableNames","YGR","RowTimes",ECOS.Time(2:end));
Obs.INFL = diff(log(ECOS.CPI))*4e2;
Obs.INT= ECOS.CALL(2:end);

% print figure of obs?
if true
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
xlim([datetime(2000,1,1) datetime(2024,10,1)])
set(gca,fontsize=FTSZ)
% recessionplot
legend([p1,p2,p3],Orientation="horizontal",Location="northoutside",NumColumns=3,Box="off")
end

% save obs as a csv file
delete obs.csv
writetable(timetable2table(Obs,ConvertRowTimes=false),"obs.csv")