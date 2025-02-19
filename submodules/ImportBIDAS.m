function [y,DataInfoPost] = ImportBIDAS(DataInfo)


% BIDAS 시계열 데이터를 MATLAB의 TimeTable 형태로 불러오기 ver 1.0
%
% o Syntex: 
%                  y = ImportBIDAS(DataInfo)
%   [y,DataInfoPost] = ImportBIDAS(DataInfo)
%
%
% o 입력 인수
%
%   DataInfo: 데이터 정보 행렬(Nx2 String matrix, N: 데이터 갯수)
%             1열에는 데이터에 붙이고 싶은 이름을 입력(string)
%             2열에는 데이터의 BIDAS ID를 입력(string)
% 
%
% o 출력 인수
%
%              y: 시계열 데이터(TxN timetable, T: 시계열 길이)
%   DataInfoPost: Nx3의 데이터 정보행렬(string)
%                 Input의 DataInfo 행렬에 BIDAS에 등록된 
%                 데이터의 명칭을 2열에 삽입
%
%
% o 예시
%
% DataInfo = [
%     "콜금리",             "NECOS-721U001-Q-1010000"
%     "물가상승률",         "NECOS-901U010-Q-00"	
%     "국내총생산(실질)",   "NECOS-200U108-Q-10601"
%     "미국내총생산(실질)", "FRED-106-A191RO1Q156NBEA"
%     ];
% 
% [y,DataInfoPost] = ImportBIDAS(DataInfo)
%
% o Reference: 박민재 조사역님(2210193)의 코드(bidas)
%
% o Copyright: 강석일, 2025.01

DataInfoPost = strings(size(DataInfo,1),size(DataInfo,2)+1);
DataInfoPost(:,1) = DataInfo(:,1);
DataInfoPost(:,end) = DataInfo(:,end);

for j = 1:size(DataInfo,1)
    DataInfoPost(j,2) = string(webread(strcat("http://datahub.boknet.intra/api/v1/meta/lists?ids=",DataInfo(j,end))).data.series_name);
    DataObs = webread(strcat("http://datahub.boknet.intra/api/v1/obs/lists?ids=",DataInfo(j,end))).data.observations;
    if j == 1
        y = array2timetable(str2double(string({DataObs.value}')),"RowTimes",datetime({DataObs.period}'),"VariableNames",DataInfo(j,1));
    else
        y = synchronize(y,array2timetable(str2double(string({DataObs.value}')),"RowTimes",datetime({DataObs.period}'),"VariableNames",DataInfo(j,1)));
    end
end
end