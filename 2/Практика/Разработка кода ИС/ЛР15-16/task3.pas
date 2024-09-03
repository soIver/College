program task3;
type PNode = ^Node;
     Node = record 
       el: integer;
       pos: integer;
       next: PNode;
     end;
const
  N = 10;
var
  Head, pp1, pp2: PNode;
  i, newel: integer;

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
  for i := 1 to 10 do begin
    newel := random(9);
    AddFirst(Head, CreateNode(i, newel));
  end;
  pp1 := Head;
  pp2 := Head;
  writeln('Все элементы списка: ');
  for i := 1 to N do begin
    write(inttostr(pp1^.el) + ' ');
    pp1 := pp1^.next;
  end;
  writeln();
 
  writeln('Чётные элементы списка: ');
  for i := 1 to N do begin
    if pp2^.el mod 2 = 0 then
      write(inttostr(pp2^.el) + ' ');
    pp2 := pp2^.next;
  end;
end.
