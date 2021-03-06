-module(read).
-export([start/1, start/2]).

scan_file(F, Readsize, Total) ->
    Rd = bfile:fread(F, Readsize),
    case Rd of
	{ok, Bin} -> scan_file(F, Readsize, size(Bin)+Total);
	eof -> Total
    end.
scan_file(F, Readsize) -> scan_file(F, Readsize, 0).

start(File, Readsize) ->
    bfile:load_driver(),
    {ok, F} = bfile:fopen(File, "r"),
    T = scan_file(F, Readsize),
    io:format("read ~p bytes~n", [T]),
    bfile:fclose(F).
start(File) ->
    start(File, 512*1024).
