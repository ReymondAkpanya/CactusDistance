Help:=function(SShelp)
	local Orb,Aut,g;
	Aut:=AutomorphismGroupOnFaces(SShelp);
	Orb:=Orbits(Aut,Faces(SShelp));
	return List(Orb,g->g[1]);
end;
Help2:=function(SShelp)
	local Orb,Aut,g;
	Aut:=DressGroup(SShelp);
	Orb:=Orbits(Aut,[1..Length(Flags(SShelp))]);
	return List(Orb,g->Flags(SShelp)[g[1]]);
end;
#ThreeWaist:=function(SS1,SS2)

ThW:=function(SS1,SS2,F1,F2)
	return ConnectedFaceSum(SS1,F1,SS2,F2);
end;
ThreeWaistHelp:=function(WL1,WL2)
	local SS1,SS2,temp,E1,E2,F1,F2;
	temp:=[];
	if WL1=[] or WL2=[] then
		return [];
	fi;
	for SS1 in WL1 do
		for SS2 in WL2 do	
			for F1 in Help2(SS1) do
				for F2 in Help2(SS2) do
					Add(temp,ThW(SS1,SS2,F1,F2));
				od;
			od;
		od;
	od;
	return IsomorphismRepresentatives(temp);
end;

AllThreeWaists:=function(i)
	local t,temp,SS1,SS2,F1,g,F2,E1,E2,list1,list2;
	temp:=[];
	t:=Set(List(Filtered([4..i/2+1],g->g mod 2 =0),h->[h,i+2-h]));
	#return IsomorphismRepresentatives(tempW);
	for g in t do
		list1:=AllSimplicialSpheres(g[1]);
		list2:=AllSimplicialSpheres(g[2]);	
		Append(temp,ThreeWaistHelp(list1,list2));
	od;	
	return IsomorphismRepresentatives(temp);
end;

Print3W:=function(i,file)
	local temp;
	temp:=ThreeWaistHelp(AllSimplicialSpheres(i[1]),AllSimplicialSpheres(i[2]));
	AppendTo(file, temp);
end;
