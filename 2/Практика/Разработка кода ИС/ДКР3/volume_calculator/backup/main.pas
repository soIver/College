unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    bEdit: TEdit;
    cEdit: TEdit;
    SphereBtn: TButton;
    WideCubeBtn: TButton;
    PyramidBtn: TButton;
    ConeBtn: TButton;
    CalculateBtn: TButton;
    aEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Answer: TLabel;
    procedure aEditKeyPress(Sender: TObject; var Key: char);
    procedure bEditKeyPress(Sender: TObject; var Key: char);
    procedure CalculateBtnClick(Sender: TObject);
    procedure cEditKeyPress(Sender: TObject; var Key: char);
    procedure WideCubeBtnClick(Sender: TObject);
    procedure PyramidBtnClick(Sender: TObject);
    procedure SphereBtnClick(Sender: TObject);
    procedure ConeBtnClick(Sender: TObject);
  private
    function floatcheck(key: char; sender: TEdit): char;

  public

  end;

var
  Form1: TForm1;
  figure, str: string;
  a: float;
  b: float;
  c: float;
  answerVal: float;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.SphereBtnClick(Sender: TObject);
begin
  figure := 'sphere';
  aEdit.Caption := '';
  bEdit.Caption := '';
  cEdit.Caption := '';
  Answer.Caption := 'Здесь мог бы быть ваш результат';
  aEdit.Visible := True;
  aEdit.TextHint := 'Радиус';
  bEdit.Visible := False;
  cEdit.Visible := False;
end;

procedure TForm1.PyramidBtnClick(Sender: TObject);
begin
  figure := 'pyramid';
  aEdit.Caption := '';
  bEdit.Caption := '';
  cEdit.Caption := '';
  Answer.Caption := 'Здесь мог бы быть ваш результат';
  aEdit.Visible := True;
  bEdit.Visible := True;
  cEdit.Visible := True;
  aEdit.TextHint := 'Длина основания';
  bEdit.TextHint := 'Ширина основания';
  cEdit.TextHint := 'Высота';
end;

procedure TForm1.WideCubeBtnClick(Sender: TObject);
begin
  figure := 'widecube';
  aEdit.Caption := '';
  bEdit.Caption := '';
  cEdit.Caption := '';
  Answer.Caption := 'Здесь мог бы быть ваш результат';
  aEdit.Visible := True;
  bEdit.Visible := True;
  cEdit.Visible := True;
  aEdit.TextHint := 'Длина';
  bEdit.TextHint := 'Ширина';
  cEdit.TextHint := 'Высота';
end;

procedure TForm1.ConeBtnClick(Sender: TObject);
begin
  figure := 'cone';
  aEdit.Caption := '';
  bEdit.Caption := '';
  cEdit.Caption := '';
  Answer.Caption := 'Здесь мог бы быть ваш результат';
  aEdit.Visible := True;
  bEdit.Visible := True;
  aEdit.TextHint := 'Радиус основания';
  bEdit.TextHint := 'Высота';
  cEdit.Visible := False;

end;

function TForm1.floatcheck(key: char; sender: TEdit): char;
begin
 case key of
  '0'..'9': key := key;
  '.', ',':
    if (pos(',', sender.Caption) = 0) and not (sender.Caption = '') then
       key := ','
    else
        key := #0;
  #8: key := key;
  else
    key := #0;
 end;
  Result := key;
end;

procedure TForm1.CalculateBtnClick(Sender: TObject);
begin
  if ((aEdit.Caption = '') and aEdit.Visible) or ((bEdit.Caption = '') and bEdit.Visible) or ((cEdit.Caption = '') and cEdit.Visible) then
     Answer.Caption := 'Необходимо заполнить все поля'
  else begin
    if aEdit.Visible then
       a := strtofloat(aEdit.Caption);
    if bEdit.Visible then
       b := strtofloat(bEdit.Caption);
    if cEdit.Visible then
       c := strtofloat(cEdit.Caption);
    case figure of
    'sphere': begin answerVal := 3.14 * 4/3 * power(a, 3); str := 'Вашего шара '; end;
    'cone': begin answerVal := 3.14 * 1/3 * power(a, 2) * b; str := 'Вашего конуса '; end;
    'pyramid': begin answerVal := 1/3 * a * b * c; str := 'Вашей пирамиды '; end;
    'widecube': begin answerVal := a * b * c; str := 'Вашего параллелепипеда '; end;
    end;
    if figure = '' then
       Answer.Caption := 'Для начала выберите фигуру'
    else
        Answer.Caption := 'Объём ' + str + 'составил ' + floattostr(answerVal) + ' ед²';
  end;
end;

procedure TForm1.cEditKeyPress(Sender: TObject; var Key: char);
begin
 key := floatcheck(key, cEdit);
end;

procedure TForm1.aEditKeyPress(Sender: TObject; var key: char);
begin
 key := floatcheck(key, aEdit);
end;

procedure TForm1.bEditKeyPress(Sender: TObject; var Key: char);
begin
 key := floatcheck(key, bEdit);
end;

end.

