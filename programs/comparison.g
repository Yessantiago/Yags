PreOrdena:=function(G) 
  local V,L,S,max,Pos,V1,i, pos;
  L:= [];pos:=0;
  V:=Vertices(G);#VertexDegees(G);

  SortBy(V,x-> VertexDegree(G,x));
  Add(L,Remove(V));

  for i in [2..Order(G)] do 
    S:=List(V,x-> Length(Intersection(L,Adjacency(G,x))));
    max:=Maximum(S);
    Pos:=Positions(S,max);
    V1:=V{Pos};
    S:=List(V1,x->VertexDegree(G,x));
    max:=Maximum(S);
    pos:=Position(S,max);
    #pos:=Position(V,V1[pos]);
    pos:=Pos[pos];
    Add(L,Remove(V,pos));
  od;
  return L;
end;

chk := function(L, Extra)
    local g, O, x, y;
    g := Extra[1]; # Grafica
    O := Extra[2]; # Lista ordenada

    if L = [] then return true; fi;
    x := Length(L);
    for y in [1..x-1] do
        if IsEdge(g, [O[x], O[y]]) and L[x] = L[y] then
            return false;
        fi;
    od;

    return true;
end;

#Static ordering.
Kcoloration2:=function(g,k)
  local i,colors, L, PO,R,Extra; 
  colors:=[1..k]; 
  L:=[];
  PO:=PreOrdena(g);
  Extra:=[g,PO];
    
  Backtrack(L,colors,chk, Order(g), Extra); 
  #L{PO}:=L;
  if L=[fail] then return fail; fi;
  R:=[];
  for i in [1..Length(L)] do
     R[PO[i]]:=L[i];
  od;
  return R;
end;

############################

chk1:=function(L,g)
    local x,y;
    if L=[] then return true; fi;
        x:=Length(L);
    for y in [1..x-1] do
        if IsEdge(g,[x,y]) and L[x]=L[y] then
            return false;
        fi;
    od;

    return true;
end;

#Plain backtrack.
Kcoloration1:=function(g,k)
    local colors,L; 
    colors:=[1..k]; 
    L:=[];

    return Backtrack(L,colors,chk1, Order(g), g); 
    if L=[fail] then return fail; fi;
    
end;



#############################

####Graficas
GG:=function(n,k) 
   local edgs;
   edgs:=Cartesian([n],[2..n-2]);
   edgs:=Union(edgs,[[1,n-1],[n-1,n]]);
   return GraphByEdges(edgs);
end;

GG1:=function(n) 
   local edgs;
   edgs:=Cartesian([2..n],[2..n-2]);
   edgs:=Union(edgs,[[1,n-1],[n-1,n]]);
   return GraphByEdges(edgs);
end;


GG2:=function(n,k) 
    local edgs,rest,bola;
    edgs:=Cartesian([1,n],[n-k+1..n-1]);
    rest:=Cartesian([2..n-k],Union([n-k+1..n-2],[n]));
    bola:=Cartesian([n-k+1..n-1],[n-k+1..n-1]);
    edgs:=Union(edgs,rest,bola);
    return GraphByEdges(edgs);
end;

GGG:= function(k)
    local edgs1,edgs2,n,b;   
    b:= PathGraph(3);
    n:= Order(PathGraph(3));  
    edgs1:=Cartesian([1],[n+1..k+n]);
    edgs2:=Cartesian([n],[k+n+1..2*k+n]);
    edgs1:= Union(Edges(b), edgs1,edgs2);
   return GraphByEdges(edgs1);

end; 

#############################
##############################################
#Truncate to tree significan digits.
#String may contain units like " ms", " years".
#The space before the unis is required.
TruncateFloat:=function(str)
  local len,posexp,pospoint,posspace,str1,str2,str3,count,i;
  if IsRat(str) then str:=Float(str); fi;
  if IsFloat(str) then str:=String(str); fi;
  if str="--" then return str; fi;
  len:=Length(str);
  pospoint:=Position(str,'.');
  posexp:=Position(str,'e');
  if posexp=fail then posexp:=len+1; fi;
  posspace:=Position(str,' ');
  if posspace=fail then posspace:=len+1; fi;
  posexp:=Minimum(posexp,posspace);
  str1:=str{[1..pospoint]};
  str2:=str{[pospoint+1..posexp-1]};
  str3:=str{[posexp..len]};
  if str1="0." then
    count:=0;
    for i in [1..Length(str2)] do 
      if str2[i] in "123456789" then count:=count+1; fi;
      if count>=3 then break; fi;
    od;
    if count>=3 then 
      str2:=str2{[1..i]};
    fi;
    return Concatenation(str1,str2,str3);
  else
    count:=Length(str1)-1;
    return Concatenation(str1,str2{[1..Minimum(3-count,Length(str2))]},str3);    
  fi;
end;

HumanTime:=function(time) #time in nanoseconds 
  local scales, units, n, i;
  if IsString(time) then return time; fi;
  if IsInt(time) then time:=Float(time); fi;
  scales:=[10.^3,10.^3,10.^3,60.,60.,24.,30.,365./30.];
  units:=["ns","µs","ms","s","min","h","days","months","years"];
  n:=Length(scales);
  for i in [1..n] do 
    if time<scales[i] then
      return Concatenation(String(time)," ",units[i]);
    else
      time:=time/scales[i];
    fi;
  od;
  return Concatenation(String(time)," ",units[n+1]);    
end;

THumanTime:=function(time) #time in nanoseconds 
  return TruncateFloat(HumanTime(time));  
end;

#########################################
Comparison:= function(g,k)
    local ini, fin, col1,col2,t1,t2; 

    ini:= NanosecondsSinceEpoch();
      col2:=Kcoloration2(g,k); #fast
    fin:=NanosecondsSinceEpoch(); 
    t2 := fin-ini; 
    Print("Kcoloration2 time: ",THumanTime(t2),"\n");

    ini:= NanosecondsSinceEpoch();
      col1:=Kcoloration1(g,k); #slow
    fin:=NanosecondsSinceEpoch(); 
    t1 := fin-ini;  
    Print("Kcoloration1 time: ",THumanTime(t1),"\n");
    
    if col1=fail and col2<>fail or col1<>fail and col2 = fail then 
      Print("Error inconsistent colorations:\n",col1,"\n",col2,"\n\n");
    fi;

    Print("t1/t2:", TruncateFloat(t1/t2));
end; 
