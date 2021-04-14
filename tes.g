dreh:=function(L1)
	local A,i,L,j,l,l1;
	l:=[];
	L:=L1;
	l1:=[];
	Add(l1,L);
	A:=[[0.5,-Sqrt(3.)/2], [Sqrt(3.)/2,0.5]];
	for i in [1..Length(L)] do
		L[1]:=L[i]-[0.5,0.866];
	od;	
#Print(L);
	for i in [1..6] do
			L[i]:=A*L[i];
	od;
	return L;
end;
