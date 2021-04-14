Draw:=function(S)

end;


makelist:=function(L,x)
	local temp,tempL,templ,tempm,m1,m2,M1,M2,i;
	templ:=[];
	tempL:=ShallowCopy(L);
	m1:=Minimum(List(tempL,g->g[1]));
	m2:=Minimum(List(tempL,g->g[2]));
	M1:=Maximum(List(tempL,g->g[1]));
	M2:=Maximum(List(tempL,g->g[2]));
	#Print(m1," ",m2," ",M1," ",M2);
	while not tempL=[] do
		if not Filtered(tempL,g->g[1]=m1)=[] then 
			#Print("a\n");
			temp:=Filtered(tempL,g->g[1]=m1);
			tempm:=Minimum(List(temp,g->g[2]));
			Add(templ,[m1,tempm]);
			tempL:=Difference(tempL,[[m1,tempm]]);
		elif not Filtered(tempL,g->g[2]=M2)=[] then
			#Print("b\n");
			temp:=Filtered(tempL,g->g[2]=M2);
			tempm:=Minimum(List(temp,g->g[1]));
			Add(templ,[tempm,M2]);
			tempL:=Difference(tempL,[[tempm,M2]]);
		elif not Filtered(tempL,g->g[1]=M1)=[] then
			#Print("c\n");
			temp:=Filtered(tempL,g->g[1]=M1);
			tempm:=Maximum(List(temp,g->g[2]));
			Add(templ,[M1,tempm]);
			tempL:=Difference(tempL,[[M1,tempm]]);		
		elif not Filtered(tempL,g->g[2]=m2)=[] then
			#Print("d\n");
			temp:=Filtered(tempL,g->g[2]=m2);
			tempm:=Maximum(List(temp,g->g[1]));
			Add(templ,[tempm,m2]);
			tempL:=Difference(tempL,[[tempm,m2]]);
		fi;
	od;
	temp:=[];
	Append(templ,templ);
	#Print(templ,"\n");
	for i in [0..Length(L)-1] do
		temp[1+i]:=templ[Position(templ,x)+i];
	od;
	return temp;
end;
#######################################
#########################################
##############################################
#######################################
newlength:=function(L)
	local temp;

	#if Filtered(L,g->g>0)=L then 
	#	return [L[1]+L[2],L[3]+L[4],L[5]+L[6],L[7]+L[8]];
	#elif L[2]+L[4]+L[6]+L[8]=0 then 
	#	return [L[1],L[3],L[5],L[7]];
	#elif L[1]+L[3]+L[5]+L[7]=0 then 
	#	return [L[2],L[4],L[6],L[8]];	
	#else
		return [L[1]+L[2],L[3]+L[4],L[5]+L[6],L[7]+L[8]];
	#fi; 
end;
trynewvert:=function(L)
	local temp;
	temp:=[];
	if L[1] >1 then 
			Append(temp,List([0..L[1]-1],g->
					     [0.,g/(L[1]-1)/1.]));
	else
			Add(temp,[0.,0.]);	
	fi;
	if L[2] >1 then 
			Append(temp,List([0..L[2]-1],g->
					     [g/(L[2]-1)/1.,1.]));	
	else
			Add(temp,[0.,1.]);	
	fi;
	if L[3] >1 then 
			Append(temp,List([0..L[3]-1],g->
					     [1.,g/(L[3]-1)/1.]));	
	else
			Add(temp,[1.,1.]);	
	fi;
	if Length(L)=4 then 
		if L[4] >1 then 
			Append(temp,List([0..L[4]-1],g->
					     [g/(L[4]-1)/1.,0.]));	
		else
			Add(temp,[1.,0.]);		
		fi;
	fi;
	return temp;
end;
cop:=function(M , L)
	local g,temp;
	temp:=[];
	for g in M do
		temp[g]:=L[g];
	od;
	return temp;
end;
MinC:=function(L)
	local m,g,temp;
	temp:=List(L,g->g[1]);
	m:=Minimum(temp);
	temp:=Filtered(L,g->g[1]=m);
	temp:=List(temp,g->g[2]);
	return [m,Minimum(temp)];
end;
TC:=function(L1,L2)
	local m1,m2,M1,M2,m11,m12,M11,M12,m21,m22,M21,M22,t1,t2,
		c,temp,tempL1,tempL2,temp1,temp2,g,ab1,ab2,vec,C1,C2;
##
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
Print("l1",tempL1,"\n");
Print("l2",tempL2,"\n");
#a:=b;

##	
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
	Print([m11,M11,m12,M12,m21,M21,m22,M22],"\n");
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
	elif [m11,m12] in tempL1 and [M11,M12] in tempL1 then 	
		Print("ccdcdcdcd\n");  
		c:=Sqrt((M11-m11)^2+(M12-m12)^2);
		vec:=([M11,M12]-[m11,m12]); 
		C1:=[m11,m12]+1/4*vec;
		C2:=[m11,m12]+3/4*vec;
		ab1:=SolutionMat([[m21,M21],[1.,1.]],[C1[1],C2[1]]);
		ab2:=SolutionMat([[m22,M22],[1.,1.]],[C1[2],C2[2]]);
		temp2:=List(tempL2,g->[ab1[1]*g[1]+ab1[2],ab2[1]*g[2]+ab2[2]]);

	elif not [m11,m12] in tempL1 and not [M11,M12] in tempL1 then
		#else
				Print("ccccc\n");
		temp:=Filtered(tempL1,g->g[1]=m11);
		temp1:=Minimum(List(temp,g->g[2]));
		temp:=Filtered(tempL1,g->g[1]=M11);
		temp2:=Minimum(List(temp,g->g[2]));
		m2:=Minimum([temp1,temp2]);
##		
		temp:=Filtered(tempL1,g->g[2]=m12);
		temp1:=Minimum(List(temp,g->g[1]));
		temp:=Filtered(tempL1,g->g[2]=M12);
		temp2:=Minimum(List(temp,g->g[1]));
		m1:=Minimum([temp1,temp2]);		
##
		temp:=Filtered(tempL1,g->g[1]=m11);
		temp1:=Maximum(List(temp,g->g[2]));
		temp:=Filtered(tempL1,g->g[1]=M11);
		temp2:=Maximum(List(temp,g->g[2]));
		M1:=Maximum([temp1,temp2]);
##		
		temp:=Filtered(tempL1,g->g[2]=m12);
		temp1:=Maximum(List(temp,g->g[1]));
		temp:=Filtered(tempL1,g->g[2]=M12);
		temp2:=Maximum(List(temp,g->g[1]));
		M2:=Maximum([temp1,temp2]);		
		c:=Sqrt((M1-m1)^2+(M2-m2)^2);  
		Print("here",m1," ",m2," ",M1," ",M2);
		temp2:=List(tempL2,g->[m1,m2]+[Sqrt(c^2/32.),Sqrt(c^2/32.)]+ 
				[g[1]*Sqrt(c^2/8)/(M1-m1),g[2]*Sqrt(c^2/8)/(M2-m2)]);
##
	else
			c:=Sqrt((M11-m11)^2+(M12-m12)^2); 
			vec:=[M21,M22]-[m21,m22];
			temp2:=List(tempL2,g->[m11,m12]+[Sqrt(c^2/32.),Sqrt(c^2/32.)]+ 
				[g[1]*vec[1],g[2]*vec[2]]);
	fi;
	return temp2;	
end;

#nextactive:=function(S,nf,act,FP)
##	local v,nextvert,temp,g,nextact;
	
#	v:=Intersection(NeighbourFacesOfFace(S,nf),act)[1];
#	nextvert:=0;
#	temp:=List(act,g->FP[g]);
#	while nextvert=0 do	
#		if FP[v][1]=Minimum(List(temp,g->g[1])) then
#			temp1:=Filtered(temp,g->g[1]=FP[v]);
#			temp1:=Filtered(temp1,g->g[2]>FP[v][2]);
#			nextact:=Position(FP,[v]);
#		fi;	
#	od;
#end;
#newUmbrellas:=function(umb,vis)
#	local g , fac;
#
#	fac:=Union(umb); 
#	tempL:=[];
#	for g in fac do 
#		temp:=Filtered(umb, h->g in h);
##		temp:=Filtered(umb,h->Intersection(h,vis)=[]);	
#		if Length(temp)>1 then 
#			Add(temp,g);
##		fi;
#	od;
#	return Filtered(umb,g->Intersection(g,temp)=[]);
#end;
correctumb:=function(S,Umb,act,vis)
	local temp,tempact,tempL,temp1,temp2,g,i,tempumb;
	tempact:=ShallowCopy(act);
	Append(tempact,act);
	tempL:=[];
	temp1:=[[]];
	tempumb:=Umb;
	l:=Length(act);
	for i in [1..l-1] do
		nf:=Difference(NeighbourFacesOfFace(S,act[i]),vis)[1];
		Add(temp1,[tempact[i],tempact[i+1],nf]);
	od;
	Print("#############################################################\n");
	Print("temp1",temp1,"\n");
	for i in [1 .. l] do 
		nf:=Difference(NeighbourFacesOfFace(S,act[i]),vis)[1];
		Print([tempact[i],tempact[i+1],nf]," ",temp1[i],"\n");
		temp2:=Filtered(tempumb,g->IsSubset(g,[tempact[i],tempact[i+1],nf]));
		temp2:=Filtered(temp2,g->Length(Intersection(g,temp1[i]))<2);
		Append(tempL,temp2);
	od;
	Print("#############################################################\n");
	return tempL;
end;

lasttry1:=function(S)
	local NumOfFac,temppos2,FacPos,VertOfMaxUmb,t1,t2,t3,MaxUmbLen,p,i,Uv,d,D,temp,
tempvisited,tempFacPos,h,templist,nf,vf,u,ed,tempUmbrellas,g,lent,j,k,active1,
Umbrellas,tempm ,mt,Mt,t,temp1,m,Umbrellas1,M,tvis,currUmb,tumb,active,visited,
mhori,Mhori,mverti,Mverti,horim1,horim2,horiM1,horiM2,vertim1,vertim2,vertiM1,vertiM2,mt1,mt2,Mt1,Mt2;
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
				IsSubset(visited,NeighbourFacesOfFace(S,g)));
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
######################################################
		tvis:=[[],[],[],[]];
		tumb:=[[],[],[],[]];
#######################################################
##new
		lent:=[0,0,0,0,0,0,0,0];
##1
	if not Set([horim1,horiM1])=[-1.] then
		temp:=Filtered(active,g->tempFacPos[g][1]=mverti and tempFacPos[g][2]>=horim1 and tempFacPos[g][2]<=horiM1); 
		Print(temp,"\n");
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
		Append(tumb[1],t);		
		t:=Difference(Union(t),tempvisited);
			Print("#11 temp ",temp,"\n");
			Print("#11 t",t,"\n");
		#Add(lent,Length(t));	
		#if not Length(t)=1 then
		#	Append(temppos2,List([0..Length(t)-1],g->
		#			     [0.,g/(Length(t)-1)/1.]));	
			lent[1]:=Length(t);	
		#fi;	
 		Append(tvis[1],t);
		
	fi;

		if not [mverti,Mhori] in List(active,g->tempFacPos[g]) then 
	if not -1. in Set([horiM1,vertim1]) then		
			temp:=Union(
			Filtered(active,g->tempFacPos[g][1]=mverti and tempFacPos[g][2]>=horiM1),
			Filtered(active,g->tempFacPos[g][2]=Mhori and tempFacPos[g][1]<=vertim1)		
			); 
			Print(temp,"\n");
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			#Print("t" ,t,"\n");
			Print("#12 temp ",temp,"\n");
			Print("#12 t",t,"\n");		
			Append(tumb[1],t);		
			t:=Difference(Union(t),tempvisited);	
			#lent[1]:=lent[1]+Length(t);			
			#if not Length(t)=1 then
			#	Append(temppos2,List([0..Length(t)-1],g->
			#		     [0.,g/(Length(t)-1)/1.]));		
				lent[2]:=Length(t);			
			#fi;	 		
			Append(tvis[1],t);
	fi;		
		fi;
#2
	if not Set([vertim1,vertiM1])=[-1.] then
		temp:=Filtered(active,g->tempFacPos[g][2]=Mhori and tempFacPos[g][1]>=vertim1 and tempFacPos[g][1]<=vertiM1); 
		#if not Length(temp)=1 then		
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
		Append(tumb[2],t);		
		t:=Difference(Union(t),tempvisited);
			Print("#21 temp ",temp,"\n");
			Print("#21 t",t,"\n");	
		#if not Length(t)=1 then
		#	Append(temppos2,List([0..Length(t)-1],g->
		#		     [g/(Length(t)-1)/1.,1.]));		
			lent[3]:=Length(t);
					
		#fi;			
		Append(tvis[2],t);
	fi;
		if not [Mverti,Mhori] in List(active,g->tempFacPos[g]) then
	if not -1. in Set([horiM2,vertiM1]) then	
			temp:=Union(
			Filtered(active,g->tempFacPos[g][1]=Mverti and tempFacPos[g][2]>=horiM2),
			Filtered(active,g->tempFacPos[g][2]=Mhori and tempFacPos[g][1]>=vertiM1)		
			); 
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			Append(tumb[2],t);		
			t:=Difference(Union(t),tempvisited);	
			Print("#22 temp ",temp,"\n");
			Print("#22 t",t,"\n");
		#	if not Length(t)=1 then
		#		Append(temppos2,List([0..Length(t)-1],g->
		#				     [g/(Length(t)-1)/1.,1.]));		
				lent[4]:=Length(t);			
		#	fi;	
 			Append(tvis[2],t);
	fi;
		fi;

#3
	if not Set([horim2,horiM2])=[-1.] then
		temp:=Filtered(active,g->tempFacPos[g][1]=Mverti and tempFacPos[g][2]>=horim2 and tempFacPos[g][2]<=horiM2); 
		#if not Length(temp)=1 then 
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			Append(tumb[3],t);		
			t:=Difference(Union(t),tempvisited);
			Print("#31 temp ",temp,"\n");
			Print("#31 t",t,"\n");	
			#Add(lent,Length(t));
		#	if not Length(t)=1 then
		#		Append(temppos2,List([0..Length(t)-1],g->
		#			     [1.,g/(Length(t)-1)/1.]));		
				lent[5]:=Length(t);			
		#	fi;	
			Append(tvis[3],t);
	fi;
		if not [Mverti,mhori] in List(active,g->tempFacPos[g]) then
	if not -1. in Set([horim2,vertiM2]) then	
			temp:=Intersection(active,tempvisited);	
			temp:=Union(
			Filtered(active,g->tempFacPos[g][1]=Mverti and tempFacPos[g][2]<=horim2),
			Filtered(active,g->tempFacPos[g][2]=mhori and tempFacPos[g][1]>=vertiM2)		
			); 
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			Append(tumb[3],t);		
			t:=Difference(Union(t),tempvisited);
			Print("#32 temp ",temp,"\n");
			Print("#32 t",t,"\n");
			#lent[3]:=lent[3]+Length(t);
		#	if not Length(t)=1 then
		#		Append(temppos2,List([0..Length(t)-1],g->
		#			     [1.,g/(Length(t)-1)/1.]));		
				lent[6]:=Length(t);
		#	fi;	
 			Append(tvis[3],t);
	fi;
		fi;
#4	
	if not Set([vertim2,vertiM2])=[-1.] then	
		temp:=Filtered(active,g->tempFacPos[g][2]=mhori and tempFacPos[g][1]>=vertim2 and tempFacPos[g][1]<=vertiM2); 
		#if not Length(temp)=1 then 		
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			Append(tumb[4],t);		
			t:=Difference(Union(t),tempvisited);	
			#Add(lent,Length(t));
			Print("#41 temp ",temp,"\n");
			Print("#41 t",t,"\n");
		#	if not Length(t)=1 then
		#		Append(temppos2,List([0..Length(t)-1],g->
		#			     [g/(Length(t)-1)/1.,0.]));		
				lent[7]:=Length(t);
		#	fi;	
 			Append(tvis[4],t);
	fi;
		if not [mverti,mhori] in List(active,g->tempFacPos[g]) then
	if not -1. in Set([horim1,vertim2]) then ###	
			temp:=Union(
			Filtered(active,g->tempFacPos[g][1]=mverti and tempFacPos[g][2]<=horim1),
			Filtered(active,g->tempFacPos[g][2]=mhori and tempFacPos[g][1]<=vertim2)		
			); 
			Print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\n");
			t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>1);
			Print("#42 temp ",temp,"\n");
			Print("#42 t",t,"\n");
			Append(tumb[4],t);		
			t:=Difference(Union(t),tempvisited);	
			#lent[4]:=lent[4]+Length(t);
		#	if not Length(t)=1 then
		#		Append(temppos2,List([0..Length(t)-1],g->
		#			     [g/(Length(t)-1)/1.,0.]));		
				lent[8]:=Length(t);
		#	fi; 		
			Append(tvis[4],t);
	fi;	
		fi;
		Print("ljfsltvis",tvis,"\n");
#####################################
		#temppos2:=Set(temppos2);
		Print("lent ",lent, "\n");
		lent:=newlength(lent);
		Print("lent ",lent, "\n");
		temppos2:=trynewvert(lent); #new
Print("newtemppos2before", temppos2,"\n");
		temppos2:=Set(TC(Set(tempFacPos),temppos2));
Print("newtemppos2", temppos2,"\n");
		mt1:=Minimum(List(temppos2,g->g[1]));
		Mt1:=Maximum(List(temppos2,g->g[1]));

		mt2:=Minimum(List(temppos2,g->g[2]));
		Mt2:=Maximum(List(temppos2,g->g[2]));
#################################new 
		if not Filtered(active,g->tempFacPos[g][1]=mverti)=[] then
			vf:=Position(tempFacPos,[mverti,horim1]);
			m:=Minimum(List(Filtered(temppos2,g->g[1]=mt1),g-> g[2]));
			temp:=[mt1,m];	
			temppos2:=makelist(temppos2,temp);
			Print("a ",[mverti,horim1],"\n");
			temp:=makelist(List(active,g->tempFacPos[g]),[mverti,horim1]);
			active:=List(temp,g->Position(tempFacPos,g));
			temp:=[mt1,m];
		elif not Filtered(active,g->tempFacPos[g][2]=Mhori)=[] then
			vf:=Position(tempFacPos,[vertim1,Mhori]);
			m:=Minimum(List(Filtered(temppos2,g->g[2]=Mt2),g-> g[1]));
			temp:=[m,Mt2];
			Print("b ",[vertim1,Mhori],"\n");
			temppos2:=makelist(temppos2,temp);
			temp:=makelist(List(active,g->tempFacPos[g]),[vertim1,Mhori]);
			active:=List(temp,g->Position(tempFacPos,g));
			temp:=[m,Mt2];
		elif not Filtered(active,g->tempFacPos[g][1]=Mverti)=[] then
			vf:=Position(tempFacPos,[Mverti,horiM2]);
			m:=Maximum(List(Filtered(temppos2,g->g[1]=Mt1),g-> g[2]));
			temp:=[Mt1,m];
			Print("c ",[Mverti,horiM2],"\n");
			temppos2:=makelist(temppos2,temp);
			temp:=makelist(List(active,g->tempFacPos[g]),[Mverti,horiM2]);
			active:=List(temp,g->Position(tempFacPos,g));
			temp:=[Mt1,m];
		elif not Filtered(active,g->tempFacPos[g][2]=mhori)=[] then
			vf:=Position(tempFacPos,[vertiM2,mhori]);
			m:=Maximum(List(Filtered(temppos2,g->g[2]=mt2),g-> g[1]));
			temp:=[m,mt2];
			Print("d ",[vertiM2,mhori],"\n");
			temppos2:=makelist(temppos2,temp);
			temp:=makelist(List(active,g->tempFacPos[g]),[vertiM2,mhori]);
			active:=List(temp,g->Position(tempFacPos,g));		
			temp:=[m,mt2];
		fi;
Print("tempumbold",tempUmbrellas,"\n");
		tempUmbrellas:=correctumb(S,tempUmbrellas,active, Union(visited,tempvisited));
		Print("tempumbnew",tempUmbrellas,"\n");
################################
		nf:=Difference(NeighbourFacesOfFace(S,vf),visited)[1];		
		tempFacPos[nf]:=temp;
		Print("neighbour is ",nf ,"\n");
		#temppos2:=Difference(temppos2,[temp]);
		Add(tempvisited,nf);

##
		for g in [1..Length(tvis)] do 
			tvis[g]:=Difference(tvis[g],[nf]);
		od;	
		tumb:=Union(tumb);
		Print("tumb ",tumb,"\n");
		newtempl:=[];
		j:=2;
		for i in [1..4] do
			Print("start for -----",i,"-----\n");
			Print("tvisfor ",tvis,"\n");
			
			#tvis[i]:=Difference(tvis[i],[nf]);
			Print("tvis ",tvis[i],"\n");
			while not tvis[i]=[] do
				Print("-------------start----------------\n");
				Print("current nf is ",nf,"\n");

				currUmb:=Filtered(tumb,g->nf in g and not IsSubset(tempvisited,g) and not Intersection(tvis[i],g)=[]);	
				t:=false;
				if currUmb=[] then
k:=2;
while Difference(NeighbourFacesOfFace(S,active[k]),Union(tempvisited,visited))=[] do
	k:=k+1;
od;
nf:=Difference(NeighbourFacesOfFace(S,active[k]),Union(tempvisited,visited))[1];
Print("!!!neighbournew is", nf, "\n");
currUmb:=Filtered(tumb,g->nf in g and not IsSubset(tempvisited,g))[1];
	Print("if curr",currUmb,"\n");
				Print("normal currUmb",currUmb,"\n");
				Print("neighbour is ",nf ,"\n");
				Print("tempFacPos[",nf,"]=",temppos2[j],"\n");
				tempFacPos[nf]:=temppos2[j];
				j:=j+1;				
				Add(tempvisited,nf);
				for g in [1..Length(tvis)] do 
					tvis[g]:=Difference(tvis[g],[nf]);
				od;
				else
					currUmb:=currUmb[1];
				fi;			
				Print("tempvisited",tempvisited,"\n");
				if not nf=nn(nf,currUmb,Union(tempvisited,visited),tvis[i]) and not tvis[i]=[] then
				Print("if\n");
				nf:=nn(nf,currUmb,Union(tempvisited,visited),tvis[i]);

				Print("normal currUmb",currUmb,"\n");
				Print("neighbour is ",nf ,"\n");
				Print("tempFacPos[",nf,"]=",temppos2[j],"\n");
				tempFacPos[nf]:=temppos2[j];
				j:=j+1;				
				Add(tempvisited,nf);
				for g in [1..Length(tvis)] do 
					tvis[g]:=Difference(tvis[g],[nf]);
				od;			
				elif nf=nn(nf,currUmb,Union(tempvisited,visited),tvis[i]) and not tvis[i]=[] then 
k:=2;
while Difference(NeighbourFacesOfFace(S,active[k]),Union(tempvisited,visited))=[] do
	k:=k+1;
od;
nf:=Difference(NeighbourFacesOfFace(S,active[k]),Union(tempvisited,visited))[1];
				Print("normal currUmb",currUmb,"\n");
				Print("neighbour is ",nf ,"\n");
				Print("tempFacPos[",nf,"]=",temppos2[j],"\n");
				tempFacPos[nf]:=temppos2[j];
				j:=j+1;				
				Add(tempvisited,nf);
				for g in [1..Length(tvis)] do 
					tvis[g]:=Difference(tvis[g],[nf]);
				od;			
			fi;

			od;
		od;
###############################################new
#	Append(active1,active[1]); 
#	for in [Length(active1)] do 
#		tumb:=Filtered(tempUmbrellas,g->IsSubset(g,[active1[1],active1[2]]))[1];
#		tvis:=Difference(tumb,tempvisited);
#	od;
##############################################
		Umbrellas:=Filtered(Umbrellas,g-> not IsSubset(tempvisited,g) );
Print("end-----------------\n",
			active,"\n",
			tempvisited,"\n",
			visited,"\n");
		for g in Difference(tempvisited,visited) do
			FacPos[g]:=tempFacPos[g];
		od;
		temp:=visited;
		tempvisited:=Difference(tempvisited,visited);
		visited:=Union(tempvisited,visited);
		tempFacPos:=cop(tempvisited,FacPos);
		Print("endtempvisited ",tempvisited,"\n");
		Print("active ",active,"\n");
	
		temp:=Difference(Faces(S),visited);
		if Length(temp)=1 then 
			FacPos[temp[1]]:=[mverti,mhori]+1/2*([Mverti,Mhori]-[mverti,mhori]);		
			Umbrellas:=[];
		fi;
	od;

	return FacPos;


end;

EdgesOfUmbrella:=function(L)
	local i,l;	
	l:=[]; 
	for i in [1..Length(L)-1] do
		Add(l,[L[i],L[i+1]]);
	od;
	Add(l,[L[Length(L)],L[1]]);
	return l;
end;

FacePositionsInFacegraph:=function(n)
	local d,D,temp,i;
	temp:=[];
	if n=1 then 
		return [[1.,1.]];
	elif n=2 then
		return [[0.,4.],[4.,4.]];
	elif n=3 then 
		return [[0.,4.],[4.,4.],[4.,0.]];	
	elif n mod 4=0 then
		d:=n/4;	
		D:=n/1.;
		for i in [0..d-1] do
			Add(temp,[i*4.,D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4]);
		od;
		for i in [0..d-1] do
			Add(temp,[D-i*4,0.]);
		od;
		for i in [0..d-1] do
			Add(temp,[0.,i*4.]);
		od;
	elif n mod 4=1 then
		d:=(n-1)/4;
		D:=(n-1.);
		for i in [0..d] do
			Add(temp,[i*D/(d+1.),D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4.]);
		od;
		for i in [0..d-1] do
			Add(temp,[D-i*4.,0.]);
		od;
		for i in [0..d-1] do
			Add(temp,[0.,i*4.]);
		od;
	elif n mod 4=2 then
		d:=(n-2)/4;
		D:=n-2.;
		for i in [0..d] do
			Add(temp,[i*D/(d+1.),D]);
		od;
		for i in [0..d-1] do
			Add(temp,[D,D-i*4.]);
		od;
		for i in [0..d] do
			Add(temp,[D-i*D/(d+1.),0.]);
		od;
		for i in [0..d-1] do
			Add(temp,[0.,i*4.]);
		od;
	elif n mod 4=3 then	 
		d:=(n-3)/4;
		D:=n-3.;
		for i in [0..d] do
			Add(temp,[i*D/(d+1.),D]);
		od;
		for i in [0..d] do
			Add(temp,[D,D-i*D/(d+1.)]);
		od;
		for i in [0..d] do
			Add(temp,[D-i*D/(d+1.),0.]);
		od;
		for i in [0..d-1] do
			Add(temp,[0.,i*D/4.]);
		od;	
	fi;
	return temp;
end;

TransformCoordinates:=function(L1,L2)
	local m1,m2,M1,M2,t1,t2,c,temp1,temp2,g;
	
	M1:=Maximum(List(L1,g->g[1]));
	M2:=Maximum(List(L2,g->g[1]));
	m1:=Minimum(List(L1,g->g[1]));
	m2:=Minimum(List(L2,g->g[1]));	
	Print("tc ",M1," ",M2," ",m1," ",m2,"\n");
#	if t1[1]>12. then
#		temp1:=List(L1,g->[g[1]*12/t1[1],g[1]*12/t1[1]]);

#	else 
		temp1:=L1;
#	fi; 
	c:=Sqrt((M1-m1)^2+(M1-m1)^2);  
	#Print(" c=",c," t1=",t1);
	temp2:=List(L2,g->[m1,m1]+[Sqrt(c^2/32.),Sqrt(c^2/32.)]+ [g[1]*Sqrt(c^2/8)/(M2-m2),g[2]*Sqrt(c^2/8)/(M2-m2)]);
	return [temp1,temp2];
end;

testUmb:=function(S,vis,Umb)
	local temp,g,u;
	temp:=[];
	for u in Umb do 
		for g in FacesOfEdges(S) do 
			if IsSubset(Union(vis,Umb),g) and Length(Intersection(vis,g))>1 and Length(Intersection(u,g))>1 then 
				Add(temp,u); 
			fi;
		od;
	od;
	return Set(temp);
end;


l:=function(S,vis,umb)
	local temp1,temp2,i,t1,t2;
	temp1:=umb;	
	t1:=1;
	for i in [1..Length(umb)] do 
		temp1[Length(temp1)+i]:=umb[i]; 
	od;
	while not(temp1[t1] in vis and not temp1[t1+1] in vis)  do
		t1:=t1+1;
	od;
	t2:=t1;
	while not(not(temp1[t1] in vis) and temp1[t1+1] in vis)  do
		t1:=t1+1;
	od;
	return List([t1..t2],i -> temp1[i]);	
end;


########
	########################
				################################
				
lasttry:=function(S)
	local NumOfFac,temppos1,temppos2,FacPos,VertOfMaxUmb,t1,t2,t3,MaxUmbLen,p,i,Uv,d,D,temp,
tempvisited,tempFacPos,h,templist,nf,vf,u,ed,tempUmbrellas,g,
Umbrellas,tempm ,mt,Mt,t,temp1,m,Umbrellas1,M,tvis,currUmb,tumb	;
	FacPos:=[];	
	MaxUmbLen:=Maximum(FaceDegreesOfVertices(S));
	VertOfMaxUmb:=Position(FaceDegreesOfVertices(S),MaxUmbLen);
       	Uv:=UmbrellaPathOfVertex(S,VertOfMaxUmb);
	Uv:=ShallowCopy(FacesAsList(Uv)); 
	Umbrellas:=UmbrellaPathsOfVertices(S);
	Umbrellas:=List(Umbrellas,g->ShallowCopy(FacesAsList(g)));
	temppos1:=FacePositionsInFacegraph(MaxUmbLen);
	i:=1;
	for g in Uv do 
		FacPos[g]:=temppos1[i];
		i:=i+1;
	od;
	tempFacPos:=FacPos;
	visited:=Set(Uv);
	tempvisited:=Set(Uv);
	temppos2:=[];
	while not Umbrellas=[] do
		tempUmbrellas:=Filtered(Umbrellas,g->not Intersection(tempvisited,g)=[]);
		M:=Maximum(List(tempFacPos,g->g[1]));
		m:=Minimum(List(tempFacPos,g->g[1]));		
		#tempvert:=Union(tempUmbrellas);
		tvis:=[];
		tumb:=[];
		temp:=Filtered(tempvisited,g->tempFacPos[g][1]=m);
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>=2 and not  
		IsSubset(tempvisited,g));
		Add(tumb,t);		
		t:=Difference(Union(t),temp);	
		
		if not Length(t)=1 then
			Append(temppos2,List([0..Length(t)-1],g->[0.,g/(Length(t)-1)/1.]));		
		fi;
#####################	
		tvis:=[t];
		#Print("tvis ", tvis,"\n");
	
		temp:=Filtered(tempvisited,g->tempFacPos[g][2]=M);		
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>=2 and not IsSubset(tempvisited,g));
		Add(tumb,t);	
		t:=Difference(Union(t),temp);	
		if not Length(t)=1 then
			Print(Length(t),"\n");
			Append(temppos2,List([0..Length(t)-1],g->[g/(Length(t)-1)/1.,1.]));
		fi;
		Add(tvis,t);
		#Print("tvis ", tvis,"\n");
		temp:=Filtered(tempvisited,g->tempFacPos[g][1]=M/1.);
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>=2 and not IsSubset(tempvisited,g));
		Add(tumb,t);		
		t:=Difference(Union(t),temp);	
		if not Length(t)=1 then	
			Append(temppos2,List([0..Length(t)-1],g->[1.,g/(Length(t)-1)/1.]));	
		fi;
		Add(tvis,t);
		#Print("tvis ", tvis,"\n");
		temp:=Filtered(tempvisited,g->tempFacPos[g][2]=m/1.);
		t:=Filtered(tempUmbrellas,g->Length(Intersection(temp,g))>=2 and not IsSubset(tempvisited,g));	
		Add(tumb,t);	
		t:=Difference(Union(t),temp);
		if not Length(t)=1 then
			Append(temppos2,List([0..Length(t)-1],g->[g/(Length(t)-1)/1.,0.]));		
		fi;
		Add(tvis,t);
		#Print("tvis ", tvis,"\n");
################################	
		temppos2:=Set(temppos2);
		temppos2:=Set(TransformCoordinates(Set(tempFacPos),temppos2)[2]);
		mt:=Minimum(List(temppos2,g->g[1]));
		Mt:=Maximum(List(temppos2,g->g[1]));
		Print("temppos",temppos2,"\n");
#################################
		Print("-----------------------------\n");
		Print(tvis,"\n");
		Print("-----------------------------\n");		
		vf:=Position(tempFacPos,[m,m]);
		nf:=Difference(NeighbourFacesOfFace(S,vf),tempvisited)[1];
		tempFacPos[nf]:=[mt,mt];
		temppos2:=Difference(temppos2,[[mt/1.,mt/1.]]);
		Add(tempvisited,nf);
		tvis[1]:=Difference(tvis[1],[nf]);
		tvis[Length(tvis)]:=Difference(tvis[Length(tvis)],[nf]);
		p:=[[1,mt],[2,Mt],[1,Mt],[2,mt]];
		Print("-----------------------------\n");
		Print(tvis,"\n");
		Print("-----------------------------\n");
		Print(" visited ",visited,"\n");
		#####
		newtempl:=[];
#		for i in [1..4] do
#		tempm:=List(t,g->g[3-p[i][1]]);
#		if i=1 or i=2 then 
#					#tempm:=List(t,g->g[3-p[i][1]]);
#					while not tempm=[] do 
#						tempm:=Minimum(tempm);
#						tempm:=Filtered(t,g->g[3-p[i][1]]=tempm);
#						Add(newtempl,tempm[1]);
#						temppos2:=Difference(temppos2,tempm);
#					od;	
#				else 
#					while not tempm=[] do 
#						tempm:=Maximum(tempm);
#						tempm:=Filtered(t,g->g[3-p[i][1]]=tempm);
#						Add(newtempl,tempm[1]);
#						temppos2:=Difference(temppos2,tempm);
#					od;
#				fi;

#		od;
#

		for i in [1..4] do
			tvis[i]:=Difference(tvis[i],[nf]);
			Print("tvis[",i,"] ",tvis[i],"\n");
			Print(tvis,"\n");
			Print("temppos2=",temppos2,"\n");
			Print("p",[i],"=",p[i],"\n");
			while not tvis[i]=[] do 
				Print("-------------start----------------\n");
				currUmb:=Filtered(tumb[i],g->nf in g and not IsSubset(Union(tempvisited,visited),g))[1];
				nf:=nn(nf,currUmb,Union(tempvisited,visited),tvis[i]);
				Print("neighbour is ",nf ,"\n");
				t:=Filtered(temppos2,g->g[p[i][1]]=p[i][2]);
				Print("t=",t,"\n");
				if i=1 or i=2 then 
					tempm:=Minimum(List(t,g->g[3-p[i][1]]));
					tempm:=Filtered(t,g->g[3-p[i][1]]=tempm);
				else 
					tempm:=Maximum(List(t,g->g[3-p[i][1]]));
					tempm:=Filtered(t,g->g[3-p[i][1]]=tempm);
				fi;
				Print(tempm,"\n");
				tempFacPos[nf]:=tempm[1];
				temppos2:=Difference(temppos2,tempm);
				Add(tempvisited,nf);
				tvis[i]:=Difference(tvis[i],[nf]);
				Print("-------------finish----------------\n");
			od;
		od;
		#visited:=Union(visited,tempvisited);
		#tempvisited1:=Filtered(tempvisited,g->not IsSubset(visited,NeighbourFacesOfFace(S,g))
		Umbrellas:=Filtered(Umbrellas,g->Intersection(tempvisited,g)=[]);
	od;

	return FacPos;


end;

nn:=function(x,umb,visited,current)
	local g,p,temp,i;
	temp:=ShallowCopy(umb);
	i:=1;
	p:=Length(umb);	
	
	for g in [1..p] do
		temp[p+g]:=temp[g];
		temp[2*p+g]:=temp[g];
	od;
	p:=Position(temp,x)+p; 
	#Print(umb," ",)
	#a:=m;
	if temp[p-1] in visited and temp[p+1] in current then 
		#while not temp[p+i] in current do 
		#	i:=i+1;		
		#od;	
		return temp[p+1];
	elif temp[p+1] in visited and temp[p-1] in current then
		#while not temp[p-i] in current do 
		#	i:=i+1;
		#od;	
		return temp[p-1];
	else 
		return false;
	fi;
	
end;










