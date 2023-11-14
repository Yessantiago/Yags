LoadPackage("yags");

PreOrdena:=function(G) 
  local V,L,S,max,Pos,V1,i, pos;
  L:= [];pos:=0;
  V:=Vertices(G);#VertexDegees(G);

  SortBy(V,x-> VertexDegree(G,x));
  max:=VertexDegree(G,V[Length(V)]); #Obtiene el grado del vértice que está al final de la lista ordenada V. Este vértice tiene el grado máximo en el grafo.
  pos:= PositionProperty(V, x->VertexDegree(G,x)=max); #encuentra la posición del primer vértice en la lista V que tiene el grado máximo
  Add(L, Remove(V,pos));

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

maxcolors:=function(g,LC,order) 
  #g=graph, LC=list of colors, order=list of vertices already colored.
  #return a list of uncolored vertices that maximize the number 
  #of colors among their neighbors which are already colored.
  local LColored,LUncolored,LNumcolors,x,y,i,Lmax,LxColors,maxcolors;
  if order= [] then return Vertices(g); fi;
  LColored:=Set(order);
  maxcolors:=0;Lmax:=[];
  LUncolored:=Difference(Vertices(g),LColored);
  if LUncolored=[] then return []; fi;
  for x in LUncolored do 
    LxColors:=[];
    for i in [1..Length(order)] do
      y:=order[i];
      if IsEdge(g,[x,y]) then 
         AddSet(LxColors,LC[i]);
      fi;
    od;
    if Length(LxColors)=maxcolors then
      AddSet(Lmax,x);
    elif Length(LxColors)>maxcolors then
      maxcolors:=Length(LxColors);
      Lmax:=[x];
    fi;
  od;
  return Lmax;
end;

maxdegv:=function(g,LV) 
  #g=graph, LV=List of vertices.
  #returns the vertex with maximum degree among LV.
  local degs,maxdeg,pos,maxdegv;
  if LV=[] then return fail; fi; 
  degs:=List(LV,x->VertexDegree(g,x));
  maxdeg:=Maximum(degs);
  pos:=Position(degs,maxdeg);
  return LV[pos];
end;

optimum:=function(g,LC,order) 
  return maxdegv(g,maxcolors(g,LC,order));
end;

# Dynamic ordering.
# En cada momento en que hay que escoger un nuevo 
# vértice para colorear, escoger el "idóneo": 
#
# De entre los vértices no coloreados, escoger el vértice 
# que tenga más colores entre sus vecinos ya coloreados.
#
#
Kcoloration3:=function(g,k)
  local i,colors, L, PO,R,chk3,order; 
  
  chk3 := function(L,extra)
    local len,x, y,col,degs,maxdeg,newx;
    len := Length(L);
    order:=order{[1..len]};
    x:=order[len];
    col:=L[len];
    for i in [1..len-1] do
        y:=order[i];
        if IsEdge(g, [x,y]) and L[i] = L[len] then
            return false;
        fi;
    od;
    newx:=optimum(g,L,order);
    if newx<>fail then 
      Add(order,newx);
    fi;
    return true;
  end;
  
  colors:=[1..k]; 
  order:=[];
  L:=[];order:=[optimum(g,L,order)];
  Backtrack(L,colors,chk3, Order(g), []); 
  #L{PO}:=L;
  if L=[fail] then return fail; fi;
  R:=[];
  for i in [1..Length(L)] do
     R[order[i]]:=L[i];
  od;
  return R;
end;

#Tarea:
#1. Verificar exhaustivamente la corrección de Kcoloration3.
#2. Comparar tiempos de ejecución con las dos versiones anteriores.
#3. Tratar de encontrar ejemplos de gráficas que funciones mal en versión 2 y 
# funcionen bien en la versión 3.
#4. Optimizar el código de v3.

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

GGG:= function(k)
    local edgs1,edgs2,n,b;   
    b:= PathGraph(3);
    n:= Order(PathGraph(3));  
    edgs1:=Cartesian([1],[n+1..k+n]);
    edgs2:=Cartesian([n],[k+n+1..2*k+n]);
    edgs1:= Union(Edges(b), edgs1,edgs2);
   return GraphByEdges(edgs1);

end; 

GG1:=function(n) 
   local edgs;
   edgs:=Cartesian([2..n],[2..n-2]);
   edgs:=Union(edgs,[[1,n-1],[n-1,n]]);
   return GraphByEdges(edgs);
end;
Ejemplo1:=function(n,k) 
    local edgs,rest,bola;
    edgs:=Cartesian([1,n],[n-k+1..n-1]);
    rest:=Cartesian([2..n-k],Union([n-k+1..n-2],[n]));
    bola:=Cartesian([n-k+1..n-1],[n-k+1..n-1]);
    edgs:=Union(edgs,rest,bola);
    return GraphByEdges(edgs);
end;

# GG3:=function(n,k) 
#     local edgs,rest,bola,nuevos,g;
#     edgs:=Cartesian([1,n],[n-k+1..n-1]);
#     rest:=Cartesian([2..n-k],Union([n-k+1..n-2],[n]));
#     bola:=Cartesian([n-k+1..n-1],[n-k+1..n-1]);
#     edgs:=Union(edgs,rest,bola);
#     nuevos:=[n+1..2*n];
#     edgs:=Union(edgs,Cartesian([1..n-k],nuevos));
#     return GraphByEdges(edgs);
# end;

# GG4:=function(n,k) #example to prove kcoloration2 
#   local edgs, p1, p2, r;  
#   k:= k+1;
#   edgs:= PathGraph(k);
#   p1:= Cartesian([1],[k+1..n]);
#   r:= Cartesian([k+1..n],[2*n-k+1..(3*n-2*k-1)]);
#   p2:= Cartesian([k],[n+1..2*n-k]);
#   edgs:= Union(Edges(edgs),p1, p2, r);
#   return GraphByEdges(edgs);
# end; 

#2.Ordenamiento previo
Ejemplo2:= function(r,k)
   local A,B,C,D,edgs;
   A:=[1..r];
   B:=r+[1..r+1];
   C:=2*r+1+[1..k];
   D:=2*r+k+1+[1..k];
   edgs:=Cartesian(D,D);
   edgs:=Union(edgs,Cartesian(A,B));
   edgs:=Union(edgs,Cartesian(B,C));
   edgs:=Union(edgs,Cartesian(A{[2..r]},D{[2..k]}));
   edgs:=Union(edgs,Cartesian([1],D{[1..k-1]}));
   return GraphByEdges(edgs);
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
    local ini, fin, col1,col2,col3,t1,t2,t3; 

    ini:= NanosecondsSinceEpoch();
      col3:=Kcoloration3(g,k); #fast
    fin:=NanosecondsSinceEpoch(); 
    t3 := fin-ini; 
    Print("Kcoloration3 time: ",THumanTime(t3),"\n");

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
      #verificar mas.
      Print("Error inconsistent colorations:\n",col1,"\n",col2,"\n\n");
    fi;

    Print("t1/t3:", TruncateFloat(t1/t3),"\n");
    Print("t2/t3:", TruncateFloat(t2/t3),"\n");
end; 

