function dataTimeTable = ecosApi(topic, period, varargin)

po = inputParser;
addRequired(po,'topic',@(z) isstring(z) || ischar(z))
addRequired(po,'period',@(z) z=='Q' || z=='M')
addParameter(po,'startDate',datetime(1000,1,1),@(z) isdatetime(z)) 
addParameter(po,'endDate',datetime('today'),@(z) isdatetime(z))
addParameter(po,'item1',"?",@(z) isstring(z) || ischar(z))
addParameter(po,'item2',"?",@(z) isstring(z) || ischar(z))
addParameter(po,'item3',"?",@(z) isstring(z) || ischar(z))
addParameter(po,'item4',"?",@(z) isstring(z) || ischar(z))
addParameter(po,'FirstDate',true,@(z) islogical(z))

parse(po,topic,period,varargin{:});
startDate = po.Results.startDate;
endDate = po.Results.endDate;
item1 = po.Results.item1;
item2 = po.Results.item2;
item3 = po.Results.item3;
item4 = po.Results.item4;
FirstDate = po.Results.FirstDate;

if period == "Q"
    startDate = sprintf("%dQ%d", year(startDate), quarter(startDate));
    endDate = sprintf("%dQ%d", year(endDate), quarter(endDate));
elseif period == "M"
    startDate = sprintf("%d%02d", year(startDate), month(startDate));
    endDate = sprintf("%d%02d", year(endDate), month(endDate));
end

key = "Y42LXOA09KQHSJE196DU";
url = "https://ecos.bok.or.kr/api/StatisticSearch/" + ...
       key + "/json/kr/1/1000/" + ...
       topic + "/" + period + "/" + startDate + "/" + endDate + "/" +...
       item1 + "/" + item2 + "/" + item3 + "/" + item4;

dataTree = webread(url).StatisticSearch;
VarName = {dataTree.row.STAT_NAME}';
VarName = string(VarName(1));
t = {dataTree.row.TIME}';
t1 = t{1};

if period == "Q"    
    T1 = datetime(str2double(t1(1:4)),1,1) + calquarters(str2double(t1(end))-1);    
    dataTimeTable = array2timetable(str2double({dataTree.row.DATA_VALUE})',"VariableNames",{VarName{:}},"StartTime",T1,"TimeStep",calquarters);
elseif period == "M"
    T1 = datetime(str2double(t1(1:4)),1,1) + calmonths(str2double(t1(end))-1);    
    dataTimeTable = array2timetable(str2double({dataTree.row.DATA_VALUE})',"VariableNames",{VarName{:}},"StartTime",T1,"TimeStep",calmonths);
end

if ~FirstDate
    if period == "Q"
        dataTimeTable.Time = dateshift(dataTimeTable.Time,"end","quarter");
    elseif period == "M"
        dataTimeTable.Time = dateshift(dataTimeTable.Time,"end","month");
    end
end

end