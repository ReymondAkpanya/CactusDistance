Read("FG.g");
drawfaces:=function(S)
	local NumOfFac,temppos2,FacPos,VertOfMaxUmb,t1,t2,t3,MaxUmbLen,p,i,Uv,d,D,temp,
tempvisited,tempFacPos,h,templist,nf,vf,u,ed,tempUmbrellas,g,lent,j,k,active1,
Umbrellas,tempm ,mt,Mt,t,temp1,m,Umbrellas1,M,tvis,currUmb,tumb,active,visited,
mhori,Mhori,mverti,Mverti,horim1,horim2,horiM1,horiM2,vertim1,vertim2,vertiM1,
vertiM2,mt1,mt2,Mt1,Mt2,x1,x2,x3,x4,n1,n2,tempf,NN,temp2,temp3,temp4;
	if IsIsomorphic(S,Tetrahedron()) then
	return [[0,0.866],[0,.433],[1,0],[-1,0]];
	fi;
	FacPos:=[];	
	MaxUmbLen:=Maximum(FaceDegreesOfVertices(S) );
	VertOfMaxUmb:=Position(FaceDegreesOfVertices(S),MaxUmbLen);
       	Uv:=UmbrellaPathOfVertex(S,VertOfMaxUmb);
	Uv:=ShallowCopy(FacesAsList(Uv)); 
	Umbrellas:=UmbrellaPathsOfVertices(S);
	Umbrellas:=List(Umbrellas,g->ShallowCopy(FacesAsList(g)));
	Umbrellas:=Difference(Umbrellas,[Uv]);
	temp:=FacePositionsInFacegraph(MaxUmbLen);
	i:=1;
	for g in Uv do 
		FacPos[g]:=temp[i];
		i:=i+1;
	od;
	tempFacPos:=ShallowCopy(FacPos);
	visited:=ShallowCopy(Uv);
	tempvisited:=ShallowCopy(Uv);
	temppos2:=[];
	while not Umbrellas=[] do
		Print("##################while#########################\n");
		Print(Difference(Faces(S),visited),"\n");
		active:=Filtered(tempvisited,g->not 		
				IsSubset(Union(tempvisited,visited),NeighbourFacesOfFace(S,g)));
		tempUmbrellas:=Filtered(Umbrellas,g->not Intersection(active,g)=[] );
		Print("active1 ",active,"\n");
		Print("tempU ",tempUmbrellas,"\n");
		Print("tempFacPos ",tempFacPos,"\n");
		Print("tempvisited ",tempvisited,"\n");
		Print("FacPos ",FacPos,"\n");
###########################################################
		Mhori:=Maximum(List(tempvisited,g->tempFacPos[g][2]));
		Mverti:=Maximum(List(tempvisited,g->tempFacPos[g][1]));
		mhori:=Minimum(List(tempvisited,g->tempFacPos[g][2]));
		mverti:=Minimum(List(tempvisited,g->tempFacPos[g][1]));
#############################################################
		temp:=Filtered(active,g->tempFacPos[g][1]=mverti);
		if not temp=[] then 		
		horiM1:=Maximum(List(temp ,g->tempFacPos[g][2]));
		horim1:=Minimum(List(temp,g->tempFacPos[g][2]));
		else 
			horim1:=-1.;
			horiM1:=-1.;		
		fi;		
##
		temp:=Filtered(active,g->tempFacPos[g][2]=Mhori);
		if not temp=[] then		
		vertiM1:=Maximum(List(temp ,g->tempFacPos[g][1]));
		vertim1:=Minimum(List(temp,g->tempFacPos[g][1]));
		else 
			vertim1:=-1.;
			vertiM1:=-1.;		

		fi;
##
		temp:=Filtered(active,g->tempFacPos[g][1]=Mverti);		
		if not temp=[] then
		horiM2:=Maximum(List(temp ,g->tempFacPos[g][2]));
		horim2:=Minimum(List(temp,g->tempFacPos[g][2]));
		else 
			horim2:=-1.;
			horiM2:=-1.;		

		fi;
##
		temp:=Filtered(active,g->tempFacPos[g][2]=mhori);	
		if not temp=[] then	
		vertiM2:=Maximum(List(temp ,g->tempFacPos[g][1]));
		vertim2:=Minimum(List(temp,g->tempFacPos[g][1]));
		else 
			vertim2:=-1.;
			vertiM2:=-1.;		

		fi;
Print("aaaaaa",[mhori,mverti,Mhori,Mverti],"\n");
######################################################
		if not Filtered(active,g->tempFacPos[g][1]=mverti)=[] then
			vf:=Position(tempFacPos,[mverti,horim1]);
			Print("a ",[mverti,horim1],"\n");
			temp:=makelist(List(active,g->tempFacPos[g]),[mverti,horim1]);
			active:=List(temp,g->Position(tempFacPos,g));
		elif not Filtered(active,g->tempFacPos[g][2]=Mhori)=[] then
			vf:=Position(tempFacPos,[vertim1,Mhori]);
			Print("b ",[vertim1,Mhori],"\n");
			temp:=makelist(List(active,g->tempFacPos[g]),[vertim1,Mhori]);
			active:=List(temp,g->Position(tempFacPos,g));
		elif not Filtered(active,g->tempFacPos[g][1]=Mverti)=[] then
			vf:=Position(tempFacPos,[Mverti,horiM2]);
			Print("c ",[Mverti,horiM2],"\n");
			temp:=makelist(List(active,g->tempFacPos[g]),[Mverti,horiM2]);
			active:=List(temp,g->Position(tempFacPos,g));
		elif not Filtered(active,g->tempFacPos[g][2]=mhori)=[] then
			vf:=Position(tempFacPos,[vertiM2,mhori]);
			Print("d ",[vertiM2,mhori],"\n");
			temp:=makelist(List(active,g->tempFacPos[g]),[vertiM2,mhori]);
			active:=List(temp,g->Position(tempFacPos,g));		
		fi;

		active1:=ShallowCopy(active);
		Add(active1,active[1]);	
		x1:=0.;
		x2:=0.;
		x3:=0.;
		x4:=0.;
		tempf:=Difference(Faces(S),Union(tempvisited,visited));
		NN:=List(active,g->Difference(NeighbourFacesOfFace(S,g),Union(tempvisited,visited))[1]);
		Print("NN",NN,"\n");
		temp:=List(active,g->tempFacPos[g]);
temp1:=[];
	temp2:=[];
	temp3:=[];
	temp4:=[];
for i in [1.. Length(active)] do 	
	done:=false;	
	n1:=Intersection(NN,NeighbourFacesOfFace(S,active1[i]))[1];
	n2:=Intersection(NN,NeighbourFacesOfFace(S,active1[i+1]))[1];
	Print("nn12",[n1,n2],"\n");	
	Print("active ",active1[i]," ",active1[i+1],"\n");
	currUmb:=Filtered(Umbrellas,g->IsSubset(g,[n1,n2,active1[i],active1[i+1]]));
	if Length(currUmb)>1 then 
		currUmb:=Filtered(currUmb,g->Length(Intersection(active,g))=2)[1];
	elif currUmb=[] then 
		done:=true;
	
	else
		currUmb:=currUmb[1];	
	fi;
if not done then
	if i=1 or n1=n2 then
		if tempFacPos[active[i]][1]=mverti then
			Print("a1\n");
			temp1[n1]:=[-1.,x1];
			Print("neighbour is",n1," ",temp1,"\n");
			x1:=x1+1.;
			Print(x1,"\n");
		fi;
		if tempFacPos[active[i]][2]=Mhori then
			Print("b1\n");
			temp2[n1]:=[x2,-2.];
			x2:=x2+1.;
			Print("neighbour is",n1," ",temp2,"\n");
		fi;
		if tempFacPos[active[i]][1]=Mverti then
			Print("c1\n");
			temp3[n1]:=[-3.,x3];
			x3:=x3+1.;
			Print("neighbour is",n1," ",temp3,"\n");
		fi;
		#if tempFacPos[active[1]][2]=mhori then
		#	temp4[n1]:=[x4,-4.];
		#	Print("neighbour is",n1," ",temp4,"\n");
		#	x4:=x4+1.;
		#fi;
		Add(tempvisited,n1);
	fi;
	###1	
if [mverti]=Set([tempFacPos[active1[i]][1],tempFacPos[active1[i+1]][1]]) then 
				
			while n1<>n2 and n1<> false do
				Print("a\n");
				Print(tempf,"\n");
				n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
				Print(n1);

				if n1<> false then
					temp1[n1]:=[-1.,x1];
					Print("neighbour is",n1," ",temp1,"\n");
					x1:=x1+1.;	
					Add(tempvisited,n1);
					tempf:=Difference(tempf,[n1]);
				fi;
			od;
t:=Filtered(active,g->tempFacPos[g][2]=Mhori);
			if n1<> false then
				if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
					temp2[n1]:=[x2,-2.];
				
					x2:=x2+1;
					Print(temp2," in\n");
				fi;
			fi;
	###2
elif Set([Mhori])=Set([tempFacPos[active1[i]][2],tempFacPos[active1[i+1]][2]]) then 
		while n1<>n2 and n1<> false do
			Print("b\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then			
				temp2[n1]:=[x2,-2.];
				Print("neighbour is",n1," ",temp2,"\n");
				x2:=x2+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
		t:=Filtered(active,g->tempFacPos[g][1]=Mverti);
		if n1<> false then			
			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
				temp3[n1]:=[-3.,x3];
				x3:=x3+1;
			fi;
		fi;
	###3
elif [Mverti]=Set([tempFacPos[active1[i]][1],tempFacPos[active1[i+1]][1]]) then 
		while n1<>n2 and n1<> false do
			Print("c\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then 
				temp3[n1]:=[-3.,x3];
				Print("neighbour is",n1," ",temp3,"\n");
				x3:=x3+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
		t:=Filtered(active,g->tempFacPos[g][2]=mhori);
		if n1<> false then
			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
				temp4[n1]:=[x4,-4.];
				x4:=x4+1;
			fi;
		fi;
##4
elif [mhori]=Set([tempFacPos[active1[i]][2],tempFacPos[active1[i+1]][2]]) then 
		while n1<>n2 and n1<> false do
			Print("d\n");
#			if n1<> false then
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp4[n1]:=[x4,-4.];
				Print("neighbour is",n1," ",temp4,"\n");
				x4:=x4+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
### no need to because already done in first step
##5	
elif [mverti,Mhori]=[tempFacPos[active1[i]][1],tempFacPos[active1[i+1]][2]]
and not [mverti,Mhori] in temp then 
		while n1<>n2 and n1<> false do
			Print("eeee\n");
#if n1<> false then
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp1[n1]:=[-1.,x1];
				Print("neighbour is",n1," ",temp1,"\n");
				x1:=x1+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
		t:=Filtered(active,g->tempFacPos[g][2]=Mhori);
		if n1<> false then
			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
				temp2[n1]:=[x2,-2.];
				x2:=x2+1;
			fi;
		fi;
##6
elif [Mhori,Mverti]=[tempFacPos[active1[i]][2],tempFacPos[active1[i+1]][1]]
and not [Mverti,Mhori] in temp then 
		while n1<>n2 and n1<> false do
			Print("f\n");
#if n1<> false then
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp2[n1]:=[x2,-2.];
				Print("neighbour is",n1," ",temp2,"\n");
				x2:=x2+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
		t:=Filtered(active,g->tempFacPos[g][1]=Mverti);
		if n1<> false then
			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
				temp3[n1]:=[-3.,x3];
				x3:=x3+1;
			fi;
		fi;
##7
	elif [Mverti,mhori]=[tempFacPos[active1[i]][1],tempFacPos[active1[i+1]][2]] and not [Mverti,mhori] in temp then 
		while n1<>n2 and n1<> false do
			Print("g\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp3[n1]:=[-3.,x3];
				Print("neighbour is",n1," ",temp3,"\n");
				x3:=x3+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
		t:=Filtered(active,g->tempFacPos[g][2]=mhori);
		if n1<> false then
			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
				temp4[n1]:=[x4,-4.];
				x4:=x4+1;
			fi;
		fi;

##8
elif [mverti,mhori]=[tempFacPos[active1[i]][2],tempFacPos[active1[i+1]][1]] and not [mverti,mhori] in temp then 
		while n1<>n2 and n1<> false do
			Print("h\n");
			Print(tempf,"\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp4[n1]:=[x4,-4.];
				Print("neighbour is",n1," ",temp4,"\n");
				x4:=x4+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
##9
elif [Mhori,mhori]=[tempFacPos[active1[i]][2],tempFacPos[active1[i+1]][2]]
and not [Mverti,Mhori] in temp then 
		while n1<>n2 and n1<> false do
			Print("eee1\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp2[n1]:=[x2,-2.];
				Print("neighbour is",n1," ",temp2,"\n");
				x2:=x2+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
##10
elif [mverti,Mverti]=[tempFacPos[active1[i]][1],tempFacPos[active1[i+1]][1]]
and not [mverti,Mverti] in temp then 
		while n1<>n2 and n1<> false do
			Print("eee2\n");
			n1:=nn(n1,currUmb,Union(tempvisited,visited),tempf);
			if n1<> false then
				temp1[n1]:=[-1.,x1];
				Print("neighbour is",n1," ",temp1,"\n");
				x1:=x1+1.;	
				Add(tempvisited,n1);
				tempf:=Difference(tempf,[n1]);
			fi;
		od;
##end
	
	fi;
fi;
od;
#		t:=Filtered(active,g->tempFacPos[g][2]=Mhori);
#		if n1<> false then
#			if Intersection(NeighbourFacesOfFace(S,n1),t)<>[] then 
#				temp2[n1]:=[x2,-2.];
#				x2:=x2+1;
#			fi;
#		fi;


temppos2:=[];
#return temppos2;	
Print("temppos",temppos2,"\n");
temp11:=Set(List(temp1,g->Position(temp1,g)));
temp22:=Set(List(temp2,g->Position(temp2,g)));
temp33:=Set(List(temp3,g->Position(temp3,g)));
temp44:=Set(List(temp4,g->Position(temp4,g)));
for g in temp1 do
	if x1<>1. then 
		temppos2[Position(temp1,g)]:=[0.,g[2]/(x1-1.)];
	elif not temp11[1] in Union(temp22,temp33,temp44) then
		temppos2[temp11[1]]:=[1.,0.5];
	fi;
od;
Print("1this istemppos",temppos2,"\n");
for g in temp2 do
	Print(g,"\n");
	if x2<>1. then 
		temppos2[Position(temp2,g)]:=[g[1]/(x2-1.),1.];
		Print(g[1]/(x2-1.),"\n");
	elif not temp22[1] in Union(temp11,temp33,temp44) then
		temppos2[temp22[1]]:=[0.5,1.];
	fi;
od;
Print("2this istemppos",temppos2,"\n");
for g in temp3 do
	if x3<>1. then 
		temppos2[Position(temp3,g)]:=[1.,1.-g[2]/(x3-1.)];
	elif not temp33[1] in Union(temp11,temp22,temp44) then
		temppos2[temp33[1]]:=[1.,0.5];
	fi;
od;
Print("3this istemppos",temppos2,"\n");
for g in temp4 do
	if x4<>1. then 
		temppos2[Position(temp4,g)]:=[1.-g[1]/(x4-1.),0.];
	elif not temp44[1] in Union(temp11,temp33,temp22) then
		temppos2[temp44[1]]:=[0.5,0.];
	fi;
od;

###################################
	if IsSubset([0.,1.],Set([x1,x2,x3,x4])) then 
		Print("entered\n");
		temp1:=Set(List(temp1,g->Position(temp1,g)));
		temp2:=Set(List(temp2,g->Position(temp2,g)));
		temp3:=Set(List(temp3,g->Position(temp3,g)));
		temp4:=Set(List(temp4,g->Position(temp4,g)));
		if x1=1. and x2+x3+x4=0. then
			temppos2[temp1[1]]:=[0.5,0.5];
		elif x2=1. and x1+x3+x4=0. then
			temppos2[temp2[1]]:=[0.5,0.5];
		elif x3=1. and x2+x1+x4=0. then
			temppos2[temp3[1]]:=[0.5,0.5];
		elif x4=1. and x2+x3+x1=0. then
			temppos2[temp4[1]]:=[0.5,0.5];
		elif x1=1. and x2=1. and x3+x4=0. then 
			temppos2[temp1[1]]:=[0.,0.];
			temppos2[temp2[1]]:=[0.,1.];
		elif x1=1. and x3=1. and x2+x4=0. then
			temppos2[temp1[1]]:=[0.,0.5];
			temppos2[temp3[1]]:=[1.,0.5];
		elif x1=1. and x4=1. and x3+x2=0. then
			temppos2[temp1[1]]:=[0.,0.];
			temppos2[temp4[1]]:=[1.,0.];
		elif x2=1. and x3=1. and x1+x4=0. then
			temppos2[temp2[1]]:=[1.,1.];
			temppos2[temp3[1]]:=[0.,1.];
		elif x2=1. and x4=1. and x3+x1=0. then
			temppos2[temp2[1]]:=[0.5,1.];
			temppos2[temp4[1]]:=[0.5,0.];
			Print("im here\n");
		elif x3=1. and x4=1. and x1+x2=0. then
			temppos2[temp3[1]]:=[1.,1.];
			temppos2[temp4[1]]:=[1.,0.];	
		elif x1=1. and x2=1. and x3=1. and x4=0. then
			temppos2[temp1[1]]:=[0.,0.];
			temppos2[temp2[1]]:=[0.,1.];
			temppos2[temp3[1]]:=[1.,1.];			
		elif x1=1. and x2=1. and x3=0. and x4=1. then
			temppos2[temp1[1]]:=[0.,0.];
			temppos2[temp2[1]]:=[0.,1.];
			temppos2[temp4[1]]:=[1.,0.];
		elif x1=1. and x2=0. and x3=1. and x4=1. then
			temppos2[temp1[1]]:=[0.,0.];
			temppos2[temp3[1]]:=[1.,1.];
			temppos2[temp4[1]]:=[1.,0.];
		elif x1=0. and x2=1. and x3=1. and x4=1. then
			temppos2[temp2[1]]:=[0.,1.];
			temppos2[temp3[1]]:=[1.,1.];
			temppos2[temp4[1]]:=[1.,0.];		
		elif x1=1. and x2=1 and x3=1. and x4=1. then
			temppos2[temp1[1]]:=[0.,0.5];
			temppos2[temp2[1]]:=[0.5,1.];
			temppos2[temp3[1]]:=[1.,0.5];
			temppos2[temp4[1]]:=[0.5,0.];
		fi;	
fi;
#######################################
Print("this istempposbefore",temppos2,"\n");
#a:=b;
	#temppos2:=TC(temp,temppos2);
	temppos2:=pos(temp,temppos2);

Print("after temppos",temppos2,"\n");
#######################################################
##new
Umbrellas:=Filtered(Umbrellas,g-> not IsSubset(Union(visited,tempvisited),g) );
Print("end-----------------\n",
			active,"\n",
			tempvisited,"\n",
			visited,"\n");
		for g in temppos2 do
			FacPos[Position(temppos2,g)]:=g;
		od; 
		temp:=visited;
		tempvisited:=Difference(tempvisited,visited);
		visited:=temp;
		tempFacPos:=cop(tempvisited,FacPos);
		Print("endtempvisited ",tempvisited,"\n");
		Print("active ",active,"\n");
	
		temp:=Difference(Faces(S),visited);
	od;

	return FacPos;


end;

pos:=function(L1,L2)
	local tempL1,tempL2,g,m11,m12,m21,m22,M11,M12,M21,M22,vec,ab1,ab2,C1,C2,temp;
	tempL1:=[];
	tempL2:=[];
	for g in L1 do 
		#Add(tempL1,[g[1]/1.,g[2]/1.]);
		tempL1[Position(L1,g)]:=[g[1]/1.,g[2]/1.];
	od;
	for g in L2 do 
#		Add(tempL2,[g[1]/1.,g[2]/1.]);	
		tempL2[Position(L2,g)]:=[g[1]/1.,g[2]/1.];
	od;
	m11:=Minimum(List(tempL1,g->g[1]));
	M11:=Maximum(List(tempL1,g->g[1]));
	M12:=Maximum(List(tempL1,g->g[2]));
	m12:=Minimum(List(tempL1,g->g[2]));
##
	m21:=Minimum(List(tempL2,g->g[1]));
	M21:=Maximum(List(tempL2,g->g[1]));
	M22:=Maximum(List(tempL2,g->g[2]));
	m22:=Minimum(List(tempL2,g->g[2]));
	if Length(Set(L2))=1 then 
		Print("----------------------------\n");
		return List(tempL2,g->[m11+0.5*(M11-m11),m12+0.5*(M12-m12)]);
	fi;	
	vec:=[M11,M12]-[m11,m12];
	if m22=M22 and m21<> M21 then
		Print("aaaaaa\n");
		vec:=[m11,m12]+(1/2.)*([0,M12]-[0,m12]);
		c:=M12-m12;
		C1:=vec+(1/4.)*[M11-m11,0];
		C2:=vec+(3/4.)*[M11-m11,0];
		ab2:=SolutionMat([[m21,M21],[1.,1.]],[C1[1],C2[1]]);
		temp2:=List(tempL2,g->[ab2[1]*g[1]+ab2[2],vec[2]]);
	elif m21=M21 and m22 <> M22 then
		Print("bbbbb\n");
		vec:=[m11,m12]+(1/2.)*([M11,0]-[m11,0]);
		c:=M11-m11;
		C1:=vec+(1/4.)*[0,M12-m12];
		C2:=vec+(3/4.)*[0,M12-m12];
		ab2:=SolutionMat([[m22,M22],[1.,1.]],[C1[2],C2[2]]);
		temp2:=List(tempL2,g->[vec[1],ab2[1]*g[2]+ab2[2]]);
	else
		Print("ccdcdcdcd\n");  
		c:=Sqrt((M11-m11)^2+(M12-m12)^2);
		vec:=([M11,M12]-[m11,m12]); 
		C1:=[m11,m12]+1/4*vec;
		C2:=[m11,m12]+3/4*vec;
		ab1:=SolutionMat([[m21,M21],[1.,1.]],[C1[1],C2[1]]);
		ab2:=SolutionMat([[m22,M22],[1.,1.]],[C1[2],C2[2]]);
		temp2:=List(tempL2,g->[ab1[1]*g[1]+ab1[2],ab2[1]*g[2]+ab2[2]]);
	fi;
	return temp2;


end;



