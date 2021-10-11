unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ImgList, Menus;

type
  TForm1 = class(TForm)
    Bevel1: TBevel;
    Panel1: TPanel;
    Resources: TImageList;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N12: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    GamePanel: TPanel;
    AboutScreenPanel: TPanel;
    Panel2: TPanel;
    Image2: TImage;
    Image1: TImage;
    AboutScreen: TImage;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N4Click(Sender: TObject);
    procedure AboutScreenClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  CellSize = 16;
var
  Form1: TForm1;
  PoleX: integer;
  PoleY: integer;
  MinCn: integer;
  Pole : array [1..64,1..64] of integer;
  zPole: array [1..64,1..64] of boolean;
  qPole: array [1..64,1..64] of boolean; 
  inGame : boolean = false;
implementation

uses Unit2;
{$R *.dfm}
Procedure ClearZPoleEx;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
      if Pole[i,j] = -1 then
      zPole[i,j] := false;
    end;
end;

Procedure ClearQPole;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
      qPole[i,j] := false;
    end;
end;

Procedure FillQPoleEx;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
        qPole[i,j] := true;
    end;
end;

Procedure FillQPole;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
        qPole[i,j] := true;
    end;
end;

Procedure ClearPole;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
      Pole [i,j] := 0;
      zPole[i,j] := false;
      qPole[i,j] := false;
    end;
end;

function MinesCount(x,y: integer) : integer;
begin
  Result := 0;

  if (x-1>=1) and (y-1>=1)  then
  if Pole[x-1,y-1] = -1 then inc(Result);
  if (x-1>=1)  then
  if Pole[x-1,y]   = -1 then inc(Result);
  if (x-1>=1) and (y+1<=PoleY) then
  if Pole[x-1,y+1] = -1 then inc(Result);
  if (y+1<=PoleY) then
  if Pole[x,y+1]   = -1 then inc(Result);

  if (x+1<=PoleX) and (y-1>=1) then
  if Pole[x+1,y-1] = -1 then inc(Result);
  if (x+1<=PoleX) then
  if Pole[x+1,y]   = -1 then inc(Result);
  if (x+1<=PoleX) and (y+1<=PoleY) then
  if Pole[x+1,y+1] = -1 then inc(Result);
  if (y-1>=1) then
  if Pole[x,y-1]   = -1 then inc(Result);
end;

Procedure FillPole(Count: integer);
var
  i,j,x,y : integer;
begin
  i := Count;
  while i >= 1 do begin
    x := Random(PoleX)+1;
    y := Random(PoleY)+1;
    if Pole[x,y] = 0 then begin
       Pole[x,y] := -1;
       Dec(i);
    end;
  end;
  for i := 1 to PoleX do
    for j := 1 to PoleY do
      if Pole[i,j] <> -1 then
         Pole[i,j] := MinesCount(i,j);
end;

function PlayerIsWin : boolean;
var
  i,j : integer;
  op  : integer;
begin
  Result := false;
  op := PoleX*PoleY;
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
      if zPole[i,j] then dec(op);
    end;
    if op = MinCn then Result := true;
end;

Procedure OpenPole;
var
  i,j : integer;
begin
  for i := 1 to PoleX do
    for j := 1 to PoleY do begin
      zPole[i,j] := True;
    end;
end;

procedure DrawPole(Canvas: TCanvas; Res: TImageList);
var
  i,j : integer;
begin
  Canvas.FillRect(Canvas.ClipRect); //clear
  for i := 1 to PoleX do
    for j := 1 to PoleY do
      if not zPole[i,j] then begin
        if qPole[i,j] then
        Res.Draw(Canvas,(i-1)*CellSize,(j-1)*CellSize,10)
        else
        Res.Draw(Canvas,(i-1)*CellSize,(j-1)*CellSize,8)
      end else
      if Pole[i,j] = -1 then begin
        Res.Draw(Canvas,(i-1)*CellSize,(j-1)*CellSize,11);
      end else 
        if MinesCount(i,j) <> 0 then begin
          Pole[i,j] := MinesCount(i,j);
          Res.Draw(Canvas,(i-1)*CellSize,(j-1)*CellSize,MinesCount(i,j)-1);
        end else Res.Draw(Canvas,(i-1)*CellSize,(j-1)*CellSize,9);
end;

Procedure AnimFinal(Recurse: integer);
var
  i : integer;
begin
  ClearZPoleEx;
  for i := 0 to Recurse do begin
    FillQPole;
    DrawPole(Form1.Image1.Canvas,Form1.Resources);
    Form1.Image1.Update;
    Application.ProcessMessages;
    Sleep(100);
    ClearQPole;
    DrawPole(Form1.Image1.Canvas,Form1.Resources);
    Form1.Image1.Update;
    Application.ProcessMessages;
    Sleep(100);
  end;
  OpenPole;
  DrawPole(Form1.Image1.Canvas,Form1.Resources);
end;

Procedure AnimFinal2(Recurse: integer);
var
  i : integer;
begin
  ClearZPoleEx;
  for i := 0 to Recurse do begin
    FillQPoleEx;
    DrawPole(Form1.Image1.Canvas,Form1.Resources);
    Form1.Image1.Update;
    Application.ProcessMessages;
    Sleep(100);
    ClearQPole;
    DrawPole(Form1.Image1.Canvas,Form1.Resources);
    Form1.Image1.Update;
    Application.ProcessMessages;
    Sleep(100);
  end;
  OpenPole;
  DrawPole(Form1.Image1.Canvas,Form1.Resources);
end;

function FillRegion(x,y: integer) : integer;
var
  i,j : integer;
begin
  Result := 0;

  if zPole[x,y] then exit;

  if (pole[x,y] <> -1) then
    zPole[x,y]  := True;

  if pole[x,y] = -1 then begin
    zPole[x,y]  := True;
    for i := 1 to PoleX do
    for j := 1 to PoleY do
      if pole[i,j] = -1 then
        zPole[i,j] := True;
        inGame := false;
        DrawPole(Form1.Image1.Canvas,Form1.Resources);
        Application.ProcessMessages;
        AnimFinal2(4);
        Exit;
  end;
  if PlayerIsWin then begin
    OpenPole;
    inGame := false;
    DrawPole(Form1.Image1.Canvas,Form1.Resources);
    Application.ProcessMessages;
    AnimFinal(17);
  end;

  if Pole[x,y] <> 0 then exit;
  zPole[x,y]  := True;
  
  if (x-1>=1)  then
  if Pole[x-1,y]   <> -1 then FillRegion(x-1,y);
  if (x-1>=1) and (y-1>=1)  then
  if Pole[x-1,y-1] <> -1 then FillRegion(x-1,y-1);
  if (x-1>=1) and (y+1<=PoleY) then
  if Pole[x-1,y+1] <> -1 then FillRegion(x-1,y+1);
  if (y+1<=PoleY-1) then
  if Pole[x,y+1]   <> -1 then FillRegion(x,y+1);

  if (x+1<=PoleX) and (y-1>=1) then
  if Pole[x+1,y-1] <> -1 then FillRegion(x+1,y-1);
  if (x+1<=PoleX) then
  if Pole[x+1,y]   <> -1 then FillRegion(x+1,y);
  if (x+1<=PoleX) and (y+1<=PoleY) then
  if Pole[x+1,y+1] <> -1 then FillRegion(x+1,y+1);
  if (y-1>=1) then
  if Pole[x,y-1]   <> -1 then FillRegion(x,y-1);

end;

Procedure AutoOpen(x,y: integer);
var
  MinCount  : integer;
  FlagCount : integer;
begin
  FlagCount := 0;
  MinCount  := pole[x,y];
  if MinCount < 1 then Exit;
  //
  if (x-1>=1)  then
  if qPole[x-1,y]   then inc(FlagCount);
  if (x-1>=1) and (y-1>=1)  then
  if qPole[x-1,y-1] then inc(FlagCount);
  if (x-1>=1) and (y+1<=PoleX) then
  if qPole[x-1,y+1] then inc(FlagCount);
  if (y+1<=PoleY) then
  if qPole[x,y+1]   then inc(FlagCount);

  if (x+1<=PoleX) and (y-1>=1) then
  if qPole[x+1,y-1] then inc(FlagCount);
  if (x+1<=PoleX) then
  if qPole[x+1,y]   then inc(FlagCount);
  if (x+1<=PoleX) and (y+1<=PoleY) then
  if qPole[x+1,y+1] then inc(FlagCount);
  if (y-1>=1) then
  if qPole[x,y-1]   then inc(FlagCount);
  //
  if FlagCount <> MinCount then Exit;
  //
  if (x-1>=1)  then
  if not qPole[x-1,y]   then FillRegion(x-1,y);
  if (x-1>=1) and (y-1>=1)  then
  if not qPole[x-1,y-1] then FillRegion(x-1,y-1);
  if (x-1>=1) and (y+1<=PoleX) then
  if not qPole[x-1,y+1] then FillRegion(x-1,y+1);
  if (y+1<=PoleY) then
  if not qPole[x,y+1]   then FillRegion(x,y+1);

  if (x+1<=PoleX) and (y-1>=1) then
  if not qPole[x+1,y-1] then FillRegion(x+1,y-1);
  if (x+1<=PoleX) then
  if not qPole[x+1,y]   then FillRegion(x+1,y);
  if (x+1<=PoleX) and (y+1<=PoleY) then
  if not qPole[x+1,y+1] then FillRegion(x+1,y+1);
  if (y-1>=1) then
  if not qPole[x,y-1]   then FillRegion(x,y-1);
  //
  DrawPole(Form1.Image1.Canvas,Form1.Resources);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if not inGame then exit;
  
  if (ssMiddle in Shift) or ((ssLeft in Shift)and(ssRight in Shift)) then
  begin
    AutoOpen((x div CellSize)+1,(y div CellSize)+1);
    exit;
  end else begin
  if ssLeft in Shift then
  if not qPole[(x div CellSize)+1,(y div CellSize)+1] then begin
    FillRegion((x div CellSize)+1,(y div CellSize)+1);
    DrawPole(image1.Canvas,Resources);
  end;
  if ssRight in Shift then begin
    if not zPole[(x div CellSize)+1,(y div CellSize)+1] then
    if not qPole[(x div CellSize)+1,(y div CellSize)+1] then
      qPole[(x div CellSize)+1,(y div CellSize)+1] := true
      else
      qPole[(x div CellSize)+1,(y div CellSize)+1] := false;
      
    DrawPole(image1.Canvas,Resources);
  end;
  end;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
  inGame := True;
  AboutScreen.Visible := False;
  Image1.Visible := True;
  //
  if N6.Checked then begin
    PoleX := 9;
    PoleY := 9;
    MinCn := 10;
  end else
  if N7.Checked then begin
    PoleX := 16;
    PoleY := 16;
    MinCn := 40;
  end else
  if N8.Checked then begin
    PoleX := 30;
    PoleY := 16;
    MinCn := 99;
  end else
  if N10.Checked then begin
    PoleX := Form2.SpinEdit2.Value;
    PoleY := Form2.SpinEdit1.Value;
    MinCn := Form2.SpinEdit3.Value;
  end;
  Image1.Width  := PoleX * CellSize;
  Image1.Height := PoleY * CellSize;
  Form1.Width   := PoleX * CellSize + 21;
  Form1.Height  := PoleY * CellSize + 104;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  Randomize;
  ClearPole;
  FillPole(MinCn);
  DrawPole(image1.Canvas,Resources);
end;

procedure TForm1.AboutScreenClick(Sender: TObject);
begin
  if not inGame then Exit;
  AboutScreen.Visible := False;
  Image1.Visible := True;
end;

procedure TForm1.N3Click(Sender: TObject);
begin
  AboutScreen.Visible := True;
  Image1.Visible := False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Width  := 1024;
  Image1.Height := 1024;
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  AboutScreenPanel.ControlStyle := ControlStyle + [csOpaque];
  AboutScreenPanel.DoubleBuffered := true;
  Image1.ControlStyle := ControlStyle + [csOpaque]; 
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
  N4.Click;
end;

procedure TForm1.N12Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Form1.UpdateWindowState;
end;

procedure TForm1.N10Click(Sender: TObject);
begin
  Form2.showmodal;
end;

end.
