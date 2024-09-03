program dkr2;
uses crt;
const
  N = 10;
  ROW_M = 3;
  ROW_P = 3;
  COL_P = 3;
  NORM = 15;
  SEL = 9;
  ERR = 12;
type Deq = record
  data: array[1..N] of string;
  tail := 0;
end;
type PNode = ^Node;
  Node = record 
    el: string;
    next: PNode;
  end;
var
  menu: array[1..ROW_M] of string[30];
  menuP: array[1..COL_P, 1..ROW_P] of string[30];
  point, pointPx, pointPy, x, y, xP, yP, elCnt: integer;
  ch, chP: char;
  newEl: string;
  D: Deq;
  Head, Tail, pp, newNode: Pnode;
  
procedure keybd_event(bVk, bScan: byte; dwFlags, dwExtraInfo: cardinal);
external 'User32.dll' name 'keybd_event';

procedure raiseError(errorType: string);
var
  msg: string;
begin
  case errorType of
    'DeqIsEmpty': msg := 'Ошибка: невозможно извлечь элемент, так как дек пуст';
    'DeqIsFull': msg := 'Ошибка: невозможно добавить элемент, так как дек переполнен';
  end;
  GoToXY(xP, 30);
  textcolor(ERR);
  print(msg);
  GoToXY(xP, 31);
  print('Нажмите Enter, чтобы продолжить');
  textcolor(NORM);
  repeat
    ch := ReadKey;
  until ch = #13;
end;

function CreateNode(newEl: string): PNode;
var
  newNode: PNode;
begin
  New(newNode);
  newNode^.el := newEl;
  newNode^.next := nil;
  Result := newNode;
end;

procedure PushHeadD (var Head: PNode; NewNode: PNode);
begin
  NewNode^.next := Head;
  Head := NewNode;
  elCnt := elCnt + 1;
end;

procedure AddAfter(var p: PNode; NewNode: PNode);
begin
  NewNode^.next := p^.next;
  p^.next := NewNode;
end;

procedure PushTailD (var Head: PNode; NewNode: PNode);
var 
  PNodeTemp: PNode;
begin
  if Head = nil then
    PushHeadD(Head, NewNode)
  else begin
    PNodeTemp := Head;
    while PNodeTemp^.next <> nil do
      PNodeTemp := PNodeTemp^.next;
    AddAfter(PNodeTemp, NewNode);
    elCnt := elCnt + 1;
  end;
end;

procedure PopHeadD (var Head: PNode);
var 
  PNodeTemp: PNode;
begin
  if Head = nil then
    raiseError('DeqIsEmpty')
  else begin
    PNodeTemp := Head;
    Head := Head^.next;
    Dispose(PNodeTemp);
    elCnt := elCnt - 1;
  end;
end;

procedure PopTailD (var Head: PNode);
var
  PNodeTemp, PNodeTemp2: PNode;
begin
  if Head = nil then
    raiseError('DeqIsEmpty')
  else begin 
    if elCnt = 1 then
      PopHeadD(Head)
    else begin
      PNodeTemp := Head;
      PNodeTemp2 := Head;
      while PNodeTemp^.next <> nil do begin
        PNodeTemp := PNodeTemp^.next;
      end;
      while PNodeTemp2^.next <> PNodeTemp do begin
        PNodeTemp2 := PNodeTemp2^.next;
      end;
      Dispose(PNodeTemp);
      PNodeTemp2^.next := nil;
    elCnt := elCnt - 1;
    end;
  end;
end;

procedure PushTailS(var D: Deq; el: string);
begin
  if D.tail = N then
    raiseError('DeqIsFull')
  else begin
    D.tail := D.tail + 1;
    D.data[D.tail] := el;
  end;
end;

procedure PopTailS(var D: Deq);
begin
  if D.tail = 0 then
    raiseError('DeqIsEmpty')
  else
    D.tail := D.tail - 1;
end;

procedure PushHeadS(var D: Deq; el: string);
var 
  i: integer;
begin
  if D.tail = N then
    raiseError('DeqIsFull')
  else begin
    D.tail := D.tail + 1;
    for i := D.tail downto 2 do begin
      D.data[i] := D.data[i - 1]
    end;
    D.data[1] := el;
  end;
end;

procedure PopHeadS(var D: Deq);
var 
  i: integer;
begin
  if D.tail = 0 then
    raiseError('DeqIsEmpty')
  else begin
    for i := 2 to D.tail do
      D.data[i - 1] := D.data[i];
    D.tail := D.tail - 1;
  end;
end;

procedure menuPtoscr;
var
  i, j: integer;
begin
  GoToXY(5, 5);
  clearline;
  GoToXY(xP, 30);
  clearline;
  GoToXY(xP, 31);
  clearline;
  GoToXY(xP, yP);
  clearline;
  GoToXY(xP, yP + 2);
  clearline;
  for i := 1 to ROW_P do
    for j := 1 to COL_P do begin
      if i = 1 then begin
      gotoxy(3, 2);
      write(menuP[j, i]);
      break
      end
    else begin
      gotoxy(xP + j * 40 - 40, yP + i * 2 - 4);
      write(menuP[j, i]);
    end;
  end;
  textcolor(SEL);
  if pointPy = 1 then begin
    gotoxy(3, 2);
    write(menuP[pointPx, pointPy]);
  end
  else begin
    gotoxy(xP + pointPx * 40 - 40, yP + pointPy * 2 - 4);
    write(menuP[pointPx, pointPy]);
  end;
  textcolor(NORM);
end;

procedure menutoscr;
var
  i: integer;
begin
  for i := 1 to ROW_M do begin
    gotoxy(x, y + i * 2 - 2);
    write(menu[i]);
  end;
  textcolor(SEL);
  gotoxy(x, y + point * 2 - 2);
  write(menu[point]);
  textcolor(NORM);
end;

procedure deqtoscrS;
var
  i: integer;
begin
  GoToXY(1, yP - 5);
  clearline;
  GoToXY(xP + 27 - D.tail * 2 + 2, yP - 5);
  print('[');
  for i := 1 to N do begin
    if i = D.tail + 1 then
      break;
    print(D.data[i]);
    if i <> D.tail then
    print('|');
  end;
  print(']')
end;

procedure deqtoscrD;
var
  PNodeTemp: PNode;
begin
  GoToXY(1, yP - 5);
  clearline;
  GoToXY(xP + 27 - elCnt * 2 + 2, yP - 5);
  print('[');
  PNodeTemp := Head;
  while PNodeTemp <> nil do begin
    print(PNodeTemp^.el);
    if PNodeTemp^.next <> nil then
      print('|');
    PNodeTemp := PNodeTemp^.next;
  end;
  print(']')
end;

procedure point1;
var
  el: string;
begin
  pointPy := 2;
  clrscr;
  menuPtoscr;
  deqtoscrS;
  repeat
    ch := ReadKey;
    if ch = #0 then
      begin
      ch := ReadKey;
      case ch of
        #40:
          if pointPy < ROW_P then
            pointPy := pointPy + 1;
        #38:
          if pointPy > 1 then begin
            if (pointPx = 2) and (pointPy = 2) then
              pointPx := 1;
            pointPy := pointPy - 1
          end;
        #39:
          if (pointPx < COL_P) and (pointPy > 1) then
            pointPx := pointPx + 1;
        #37:
          if pointPx > 1 then
            pointPx := pointPx - 1;
      end;
      menuPtoscr;
    end
    else if ch = #13 then begin
      case pointPy of
        1: ch := #27;
        2: case pointPx of
          1: begin
            gotoxy(xP + pointPx * 40 - 23, yP + pointPy * 2 - 4);
            textcolor(SEL);
            write(': ');
            readln(el);
            PushHeadS(D, el);
            textcolor(NORM);
          end;
          2: begin
            gotoxy(xP + pointPx * 40 - 24, yP + pointPy * 2 - 4);
            textcolor(SEL);
            write(': ');
            readln(el);
            PushTailS(D, el);
            textcolor(NORM);
          end;
        end;
        3: case pointPx of
          1: PopHeadS(D);
          2: PopTailS(D);
        end;
      end;
    menuPtoscr;
    deqtoscrS;
    end;
  until ch = #27;
end;

procedure point2;
var
  el: string;
begin
  pointPy := 2;
  clrscr;
  menuPtoscr;
  deqtoscrD;
  repeat
    ch := ReadKey;
    if ch = #0 then
      begin
      ch := ReadKey;
      case ch of
        #40:
          if pointPy < ROW_P then
            pointPy := pointPy + 1;
        #38:
          if pointPy > 1 then begin
            if (pointPx = 2) and (pointPy = 2) then
              pointPx := 1;
            pointPy := pointPy - 1
          end;
        #39:
          if (pointPx < COL_P) and (pointPy > 1) then
            pointPx := pointPx + 1;
        #37:
          if pointPx > 1 then
            pointPx := pointPx - 1;
      end;
      menuPtoscr;
    end
    else if ch = #13 then begin
      case pointPy of
        1: ch := #27;
        2: case pointPx of
          1: begin
            gotoxy(xP + pointPx * 40 - 23, yP + pointPy * 2 - 4);
            textcolor(SEL);
            write(': ');
            readln(el);
            PushHeadD(Head, CreateNode(el));
            textcolor(NORM);
          end;
          2: begin
            gotoxy(xP + pointPx * 40 - 24, yP + pointPy * 2 - 4);
            textcolor(SEL);
            write(': ');
            readln(el);
            PushTailD(Head, CreateNode(el));
            textcolor(NORM);
          end;
        end;
        3: case pointPx of
          1: PopHeadD(Head);
          2: PopTailD(Head);
        end;
      end;
    menuPtoscr;
    deqtoscrD;
    end;
  until ch = #27;
end;

begin
  keybd_event($12, 0, 0, 0);
  keybd_event($0D, 0, 0, 0);
  keybd_event($0D, 0, 2, 0);
  keybd_event($12, 0, 2, 0);
  keybd_event($20, 0, 0, 0);
  keybd_event($20, 0, 2, 0);
  setwindowtitle('Деки');
  hidecursor;
  Head := nil;
  menu[1] := 'Статическая память';
  menu[2] := 'Динамическая память';
  menu[3] := '      Выход';
  menuP[1, 1] := 'Вернуться в главное меню';
  menuP[1, 2] := 'Добавить в начало';
  menuP[1, 3] := 'Извлечь из начала';
  menuP[2, 2] := 'Добавить в конец';
  menuP[2, 3] := 'Извлечь из конца';
  point := 1;
  pointPx := 1;
  pointPy := 2;
  x := 60;
  y := 17;
  xP := 40;
  yP := 25;
  textcolor(NORM);
  menutoscr;
  repeat
    ch := ReadKey;
    if ch = #0 then
      begin
      ch := ReadKey;
      case ch of
          #40:
            if point < ROW_M then
            point := point + 1;
          #38:
            if point > 1 then
              point := point - 1;
      end;
      menutoscr;
    end
    else if ch = #13 then begin
      case point of
        1: point1;
        2: point2;
        3: begin
             keybd_event($12, 0, 0, 0);
             keybd_event($73, 0, 0, 0);
             keybd_event($73, 0, 2, 0);
             keybd_event($12, 0, 2, 0);
        end;
      end;
    end;
    clrscr;
    menutoscr;
  until False;
end.