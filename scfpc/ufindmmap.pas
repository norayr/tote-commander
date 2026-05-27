unit uFindMmap;

{$mode objfpc}{$H+}

interface

uses
  BaseUnix, Unix; // Use BaseUnix and Unix units

function PosMem(pAdr: PChar; iLength: Integer; const sData: String; bCase: Boolean): Pointer;
function FindMmap(const sFileName: String; const sFindData: String; bCase: Boolean): Boolean;

implementation

function PosMem(pAdr: PChar; iLength: Integer; const sData: String; bCase: Boolean): Pointer;
var
  xIndex: Integer;

  function sPos2(pAdr: PChar; const sData: String): Boolean;
  var
    i: Integer;
  begin
    Result := False;
    for i := 1 to Length(sData) do
    begin
      case bCase of
        False: if UpCase(pAdr^) <> UpCase(sData[i]) then Exit;
        True: if pAdr^ <> sData[i] then Exit;
      end;
      Inc(pAdr);
    end;
    Result := True;
  end;

begin
  Result := Pointer(-1);
  for xIndex := 0 to iLength - Length(sData) do
  begin
    if sPos2(pAdr, sData) then
    begin
      Result := pAdr;
      Exit;
    end;
    Inc(pAdr);
  end;
end;

function FindMmap(const sFileName, sFindData: String; bCase: Boolean): Boolean;
var
  fd: cint;
  pmmap: Pointer;
  fs: cint;
  stat: BaseUnix.Stat;
begin
  Result := False;
  pmmap := nil;
  fs := 0;
  fd := fpOpen(PChar(sFileName), O_RDONLY);
  if fd = -1 then Exit;
  try
    if fpfstat(fd, stat) <> 0 then Exit;
    fs := stat.st_size;
    pmmap := fpmmap(nil, fs, PROT_READ, MAP_PRIVATE, fd, 0);
    if pmmap = MAP_FAILED then Exit;

    Result := PosMem(pmmap, fs, sFindData, bCase) <> Pointer(-1);
  finally
    fpClose(fd);
    if Assigned(pmmap) then
      fpmunmap(pmmap, fs);
  end;
end;

end.

