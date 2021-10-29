clear
clc

a = [0, 62, 66, inf, inf, inf, inf;
    62, 0, inf, 25, 11, inf, inf;
    66, inf, 0, 9, inf, inf, 49;
    inf, 25, 9, 0, 11, 14, inf;
    inf, 11, inf, 11, 0, 13, inf;
    inf, inf, inf, 14, 13, 0, 35.8;
    inf, inf, 49, inf, inf, 35.8, 0];
findPath(a, 1, 7, 0);
