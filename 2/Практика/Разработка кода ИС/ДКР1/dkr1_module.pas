unit dkr1_module;
uses GraphABC;
procedure coh_rec(x, y, len, ang : Real; stp : Integer);
procedure coh_rec2(Var x, y: Real; len, ang : Real; stp : Integer);
begin
  coh_rec(x, y, len, ang, stp);
  x := x + len * cos(ang);
  y := y - len * sin(ang);
end;
begin
  if stp > 0 then
  begin
    len := len/3;
    coh_rec2(x, y, len, ang, stp - 1);
    coh_rec2(x, y, len, ang + pi/3, stp - 1);
    coh_rec2(x, y, len, ang - pi/3, stp - 1);
    coh_rec2(x, y, len, ang, stp - 1);
  end
  else
    Line(Round(x), Round(y), Round(x + cos(ang)*len), Round(y - sin(ang)*len))
end;
begin
end.