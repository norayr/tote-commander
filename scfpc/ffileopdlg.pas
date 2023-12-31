{
Seksi Commander
----------------------------
Implementing of progress dialog for file operation

Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

contributors:

}
unit fFileOpDlg;
{$mode objfpc}{$H+}
interface

uses
  LResources,
  SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fLngForm, ComCtrls, Buttons;

type
  TfrmFileOp = class(TfrmLng)
    pbSecond: TProgressBar;
    pbFirst: TProgressBar;
    lblFileName: TLabel;
    lblEstimated: TLabel;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }

  public
    iProgress1Max:Integer;
    iProgress1Pos:Integer;
    iProgress2Max:Integer;
    iProgress2Pos:Integer;
    sEstimated:ShortString;  // bugbug, must be short string
//    sEstimated:String;

    sFileName:String;

    procedure UpdateDlg;
    procedure LoadLng; override;
  end;

implementation

//uses uFileOpThread;


procedure TfrmFileOp.LoadLng;
begin
  sEstimated:='';
  sFileName:='';
  pbFirst.Position:=0;
  pbSecond.Position:=0;
  pbFirst.Max:=1;
  pbSecond.Max:=1;
  iProgress1Max:=0;
  iProgress2Max:=0;
  iProgress1Pos:=0;
  iProgress2Pos:=0;
end;

procedure TfrmFileOp.btnCancelClick(Sender: TObject);
begin

end;

procedure TfrmFileOp.UpdateDlg;
var
  bP1, bP2:Boolean; // repaint if needed
  s:String;
begin
// in processor intensive task we force repaint immedially
  bP1:=False;
  bP2:=False;

  if pbFirst.Max<> iProgress1Max then
  begin
    if iProgress1Max>0 then
      pbFirst.Max:= iProgress1Max;
{    pbFirst.Max:=20000;}
    bP1:=True;
  end;
  if pbFirst.Position<> iProgress1Pos then
  begin
    if iProgress1Pos>0 then
      pbFirst.Position:= iProgress1Pos;
    bP1:=True;
  end;

  if pbSecond.Max<> iProgress2Max then
  begin
    if iProgress2Max>0 then
      pbSecond.Max:= iProgress2Max;
    bP2:=True;
  end;
  if pbSecond.Position<> iProgress2Pos then
  begin
    if iProgress2Pos>0 then
      pbSecond.Position:= iProgress2Pos;
    bP2:=True;
  end;
  
  if bp1 then
    pbFirst.Invalidate;
  if bp2 then
    pbSecond.Invalidate;
    
  if sEstimated<>lblEstimated.Caption then
  begin
    lblEstimated.Caption:=sEstimated;
    lblEstimated.Invalidate;
  end;
  if sFileName<>lblFileName.Caption then
  begin
    lblFileName.Caption:=sFileName;
    lblFileName.Invalidate;
  end;
end;

initialization
 {$I fFileOpDlg.lrs}

end.
