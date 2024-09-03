program task4;
type PNode = ^Node;
     Node = record 
       el: integer;
       pos: integer;
       next: PNode;
     end;
     
const
  N = 30;
var
  Head, pp1, pp2: PNode;
  i, maxel, minel, maxind, minind, newel: integer;
  
function CreateNode(curpos, newel: integer): PNode;
var NewNode: PNode;
begin
  New(NewNode);
  NewNode^.el := NewEl;
  NewNode^.pos := curpos;
  NewNode^.next := nil;
  Result := NewNode;
end;

procedure AddFirst (var Head: PNode; NewNode: PNode);
begin
  NewNode^.next := Head;
  Head := NewNode;
end;

begin
  for i := 1 to N do begin
    newel := random(200) - 100;
    AddFirst(Head, CreateNode(i, newel));
  end;
  
  pp1 := Head;
  pp2 := Head;
  minel := Head^.el;
  maxel := Head^.el;
  minind := 1;
  maxind := 1;
  
  writeln('Все элементы списка: ');
  for i := 1 to N do begin
    write(inttostr(pp1^.el) + ' ');
    pp1 := pp1^.next;
  end;
  writeln();
  
  while pp2^.next <> nil do begin
    if pp2^.el > maxel then
      maxel := pp2^.el;
    if pp2^.el < minel then
      minel := pp2^.el;
    pp2 := pp2^.next;
  end;
  
  writeln('Максимальный элемент списка: ' + maxel);
  writeln('Минимальный элемент списка: ' + minel);
end.