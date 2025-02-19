function bokcolormapsetting
%{
BOK Medium Blue 20 95 170
BOK Golden Tan 210 145 90
BOK Green 0 155 130
BOK Red  255 85 65
BOK Sky Blue 35 180 225
BOK Yellow 255 185 55
BOK Light Blue 130 170 170
BOK Tan 190 160 120
BOK Light Gray Cool Gray 200 200 200
BOK Dark Gray 160 160 160
%}

bokcolormap = ...
[
20	95	170     % BOK medium blue
210	145	90      % BOK golden tan
0	155	130     % BOK green
255	85	65      % BOK red
35	180	225     % bok sky blue
255	185	55      % bok yellow
130	170	170     % bok light blue
145 92  130     % Antique fuchsia
255 153 102     % Atomic tangerine
128 255 212     % Aquamarine
84  105 120     % cadet
190	160	120     % bok tan
200	200	200     % bok light gray
160	160	160     % bok dark gray
]/255;

assignin("base","bokcolormap",bokcolormap)
end