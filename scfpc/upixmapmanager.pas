{
   File name: uPixMapManager.pas
   Date:      2004/04/xx
   Author:    Radek Cervinka  <radek.cervinka@centrum.cz>

   Fast pixmap memory manager a loader

   Copyright (C) 2004

   This program is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of the
   License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   in a file called COPYING along with this program; if not, write to
   the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
   02139, USA.
}


unit uPixMapManager;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, uTypes, contnrs, Graphics ;


type
  TPixMapManager=class
  
  private
    FExtList:TStringList;
    FPixmapName:TStringList;
    FimgList: TObjectList;
    FiDirIconID: Integer;
    FiLinkIconID: Integer;
    FiUpDirIconID: Integer;
    FiDefaultIconID: Integer;
  protected
    function CheckAddPixmap(const sName:String):Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(const sFileName:String);
    function GetBitmap(iIndex:Integer):TBitmap;
    Function GetIconByFile(fi:PFileRecItem):Integer;
  end;
  
var
  PixMapManager:TPixMapManager = nil;

procedure LoadPixMapManager;


implementation
uses
  uGlobsPaths, BaseUnix;
{ TPixMapManager }

function TPixMapManager.CheckAddPixmap(const sName: String): Integer;
begin
  Result:=-1;
  if not FileExists(gpPixmapPath+sName) then
  begin
    writeln(Format('Warning: pixmap [%s] not exists!',[gpPixmapPath+sName]));
    Exit;
  end;
  // determine: known this file?
  Result:=FPixmapName.IndexOf(sName);
  if Result<0 then // no
    Result:=FPixmapName.Add(sName); // add to list
end;

constructor TPixMapManager.Create;
begin
  FExtList:=TStringList.Create;
  FimgList:=TObjectList.Create;
  FPixmapName:=TStringList.Create;
end;

destructor TPixMapManager.Destroy;
begin
  if assigned(FPixmapName) then
    FreeAndNil(FPixmapName);
  if assigned(FimgList) then
    FreeAndNil(FimgList);
  if assigned(FExtList) then
    FreeAndNil(FExtList);
  inherited Destroy;
end;

procedure TPixMapManager.Load(const sFileName: String);
var
  f:TextFile;
  s:String;
  sExt, sPixMap:String;
  iekv:integer;
  iPixMap:Integer;
  x:Integer;
  bmp:TBitmap;

begin
  assignFile(f,sFileName);
  reset(f);
  try
    while not eof(f) do
    begin
      readln(f,s);
      s:=Trim(lowercase(s));
      iekv:=Pos('=',s);
      if iekv=0 then
        Continue;
      sExt:=Copy(s,1, iekv-1);
      sPixMap:=Copy(s, iekv+1, length(s)-iekv);
      iPixMap:=CheckAddPixmap(sPixMap);
      if iPixMap<0 then
        Continue;

      if FExtList.IndexOf(sExt)<0 then
        FExtList.AddObject(sExt, TObject(iPixMap));
    end;
  finally
    CloseFile(f);
  end;
  // add some standard icons
  FiDirIconID:=CheckAddPixmap('fdir.xpm');
  FiLinkIconID:=CheckAddPixmap('flink.xpm');
  FiUpDirIconID:=CheckAddPixmap('fupdir.xpm');
  FiDefaultIconID:=CheckAddPixmap('fblank.xpm');

  // now fill imagelist by FPixMap

  for x:=0 to FPixmapName.Count-1 do
  begin
//    writeln('Loading:',x,' ',FExtList[x],': ',gpPixmapPath+FPixmapName[x]);
    bmp:=TBitmap.Create;
    bmp.LoadFromXPMFile(gpPixmapPath+FPixmapName[x]);
    bmp.Transparent:=True;
//    bmp.TransparentMode:=tmFixed;
//    writeln(bmp.Width,' ',bmp.Height);
    FimgList.Add(bmp);
  end;

end;

function TPixMapManager.GetBitmap(iIndex: Integer): TBitmap;
begin
  if iIndex<FimgList.Count then
    Result:=TBitmap(FimgList.Items[iIndex])
  else
    Result:=nil;
end;

function TPixMapManager.GetIconByFile(fi: PFileRecItem): Integer;
begin
  Result:=-1;
  if not assigned(fi) then Exit;


  with fi^ do
  begin
//    writeln(sExt);
    if sName='..' then
    begin
      Result:=FiUpDirIconID;
      Exit;
    end;
    if FPS_ISDIR(iMode) then
    begin
      Result:=FiDirIconID;
      Exit;
    end;
    if FPS_ISLNK(iMode) then
    begin
      Result:=FiLinkIconID;
      Exit;
    end;
    if sExt='' then
    begin
      Result:=FiDefaultIconID;
      Exit;
    end;
    Result:= FExtList.IndexOf(copy(sExt,2,length(sExt))); // ignore .
    if Result<0 then
    begin
      Result:=FiDefaultIconID;
      Exit;
    end;
    Result:=Integer(FExtList.Objects[Result]);
//    writeln(Result);
  end;
end;

procedure LoadPixMapManager;
begin
  PixMapManager:=TPixMapManager.Create;
  PixMapManager.Load(gpExePath+'pixmaps.txt');
end;

initialization

finalization

  if assigned(PixMapManager) then
    FreeAndNil(PixMapManager);

end.

