{
Seksi Commander
----------------------------
Implementing of About dialog
Licence  : GNU GPL v 2.0
Author   : radek.cervinka@centrum.cz

}
unit fAbout;

{$mode objfpc}{$H+}

interface

uses
  LResources,
  Graphics, Forms, Controls,  StdCtrls, ExtCtrls, ActnList,Buttons,
  SysUtils, Classes, lcltype;

type
  TfrmAbout = class(TForm)
    lblVersion: TLabel;
    OKButton: TButton;
    Panel1: TPanel;
    imgLogo: TImage;
    memInfo: TMemo;
    lblTitle: TStaticText;
    procedure OKButtonClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure frmAboutShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


procedure ShowAboutBox;

implementation
{uses
  uConstants;}
const
  cAboutMsg =
    'This program is free software under GNU GPL 2 license, see COPYING file'+#13+
    'Author: Radek Cervinka (radek.cervinka@centrum.cz)'+#13+
    'Contributors:'+#13+
    'Peter Cernoch (pcernoch@volny.cz) - author PFM'+#13+
    'Pavel Letko (letcuv@centrum.cz) - multirename, split, linker'+#13+
    'Jiri Karasek (jkarasek@centrum.cz)'+#13+
    'Vladimir Pilny (vladimir@pilny.com)'+#13+
    'Vaclav Juza (vaclavjuza@seznam.cz)'+#13+
    'Martin Matusu (xmat@volny.cz) - chown, chgrp'+#13+
    'Radek Polak - some viewer fixes'+#13+
    'translators (see detail in lng files)  '+#13+#13+
    'Big thanks to Lazarus and FreePascal Team';



procedure ShowAboutBox;
begin
  with TfrmAbout.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmAbout.OKButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_Escape) then
   Close;
end;

procedure TfrmAbout.frmAboutShow(Sender: TObject);
begin
  imgLogo.Picture.Bitmap.LoadFromLazarusResource('logo');
  memInfo.Lines.Text:=cAboutMsg;
end;

initialization
 {$I fAbout.lrs}
 {$I logo.lrs}
end.
