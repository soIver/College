program dkr1;
uses GraphABC, dkr1_module;
var
  x1, x2, x3, y1, y2, y3, len, ang1, ang2, ang3: Real; 
  stp, x1_mod, x2_mod, x3_mod, y1_mod, y2_mod, y3_mod, cursx, cursy: Integer;
  flag: boolean;
//процедура, нормализующая координаты отрисовки фрактала при его масштабировании 
procedure CoordNormalize();
begin
  x1 := len * 0.8 + x1_mod;
  y1 := len + y1_mod;
  x2 := len * 1.3 + x2_mod;
  y2 := len * 0.134 + y2_mod;
  x3 := len * 1.8 + x3_mod;
  y3 := len + y3_mod;
end;
//процедура, обрабатывающая события нажатия клавиш клавиатуры
procedure KeyDown(key: integer);
begin
  ClearWindow;
  case key of
    VK_Right: begin
      x1_mod := x1_mod - 10;
      x1 := x1 - 10;
      x2_mod := x2_mod - 10;
      x2 := x2 - 10;
      x3_mod := x3_mod - 10;
      x3 := x3 - 10;
    end;
    VK_Left: begin
      x1_mod := x1_mod + 10;
      x1 := x1 + 10;
      x2_mod := x2_mod + 10;
      x2 := x2 + 10;
      x3_mod := x3_mod + 10;
      x3 := x3 + 10;
    end;
    VK_Up: begin
      y1_mod := y1_mod + 10;
      y1 := y1 + 10;
      y2_mod := y2_mod + 10;
      y2 := y2 + 10;
      y3_mod := y3_mod + 10;
      y3 := y3 + 10;
    end;
    VK_Down: begin
      y1_mod := y1_mod - 10;
      y1 := y1 - 10;
      y2_mod := y2_mod - 10;
      y2 := y2 - 10;
      y3_mod := y3_mod - 10;
      y3 := y3 - 10;
    end;
    VK_W: begin
      if stp < 10 then
        stp := stp + 1;
      CoordNormalize();
    end;
    VK_S: begin
      if stp > 0 then
        stp := stp - 1;
      CoordNormalize();
    end;
    VK_A: begin
      if len > 100 then
        len := len - 10;
      CoordNormalize();
      x1_mod := x1_mod - cursx;
      x2_mod := x2_mod - cursx;
      x3_mod := x3_mod - cursx;
      y1_mod := y1_mod - cursy;
      y2_mod := y2_mod - cursy;
      y3_mod := y3_mod - cursy;
    end;
    VK_D: begin
      len := len + 10;
      CoordNormalize();
      x1_mod := x1_mod + cursx;
      x2_mod := x2_mod + cursx;
      x3_mod := x3_mod + cursx;
      y1_mod := y1_mod + cursy;
      y2_mod := y2_mod + cursy;
      y3_mod := y3_mod + cursy;
    end;
    VK_I: begin
      if flag then begin
        ang1 := ang1 - 5*pi/3;
        ang2 := ang2 - 5*pi/3;
        ang3 := ang3 - 5*pi/3
      end
      else begin
        ang1 := ang1 + 5*pi/3;
        ang2 := ang2 + 5*pi/3;
        ang3 := ang3 + 5*pi/3
      end;
      flag := not flag;
    end;
    VK_Q: Window.Close;
  end;
  coh_rec(x1, y1, len, ang1, stp);
  coh_rec(x2, y2, len, ang2, stp);
  coh_rec(x3, y3, len, ang3, stp);
  TextOut(5, 0, 'W - увеличение глубины A - увеличение масштаба S - уменьшение глубины D - увеличение масштаба I - инвертация фрактала Q - выход из программы');
  TextOut(5, 20, '← - перемещение влево ↑ - перемещение вверх → - перемещение вправо ↓ - перемещение вниз');
  Redraw;
end;
//процедура, предназначенная для отслеживания координат курсора и записи их в переменные
procedure MouseMove(x, y, mousebutton: integer);
begin
  y := y - 300;
  x := x - 240;
  cursx := -x div 20;
  cursy := -y div 50;
  if x < 0 then
    cursx := cursx + x div 25;
  if y > 0 then
    cursy := cursy - y div 25;
end;
//тело программы, в котором задаются начальные значения для переменных, конфигурация окна и его первоначальный вид 
begin
  x1_mod := 240;
  x2_mod := 240;
  x3_mod := 240;
  y1_mod := 150;
  y2_mod := 150;
  y3_mod := 150;
  ang1 := pi/3;
  ang2 := -pi/3;
  ang3 := pi;
  stp := 5;
  len := 300;
  SetWindowSize(1920, 1200);
  CoordNormalize;
  OnKeyDown := KeyDown;
  OnMouseMove := MouseMove;
  MaximizeWindow;
  SetWindowCaption('Снежинка Коха');
  LockDrawing;
  TextOut(5, 0, 'W - увеличение глубины A - увеличение масштаба S - уменьшение глубины D - увеличение масштаба I - инвертация фрактала Q - выход из программы');
  TextOut(5, 20, '← - перемещение влево ↑ - перемещение вверх → - перемещение вправо ↓ - перемещение вниз');
  coh_rec(x1, y1, len, pi/3, stp);
  coh_rec(x2, y2, len, -pi/3, stp);
  coh_rec(x3, y3, len, pi, stp);
  Redraw;
end.
