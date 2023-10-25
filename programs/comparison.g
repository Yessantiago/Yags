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

Kcoloration:=function(g,k)
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

Kcoloration2:=function(g,k)
    local colors,L; 
    colors:=[1..k]; 
    L:=[];

    return Backtrack(L,colors,chk1, Order(g), g); 
    if L=[fail] then return fail; fi;
    
end;



#############################


Comparison:= function(g,k)
    local ini, fin, t1,t2; 

    ini:= NanosecondsSinceEpoch();
    Print("Kcoloration:: ",Kcoloration(g,k),"\n");
    fin:=NanosecondsSinceEpoch(); 

    t1 := fin-ini; 

    Print("  Kcoloration: ",t1," ns\n");

    ini:= NanosecondsSinceEpoch();
    Print("Kcoloration2:: ",Kcoloration2(g,k),"\n");
    fin:=NanosecondsSinceEpoch(); 

    t2 := fin-ini;  
    Print("  Kcoloration2: ",t2," ns\n\n");

    if t1 < t2 then
        Print(" Kcoloration(t) < Kcoloration2(t) \n");
    elif t1 > t2 then
        Print("  Kcoloration(t) > Kcoloration2(t) \n");

    else
        Print("  Kcoloration(t) = Kcoloration2(t) \n");
    fi;

end; 

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
    local edgs,rest;
    edgs:=Cartesian([1,n],[n-k+1..n-1]);
    rest:=Cartesian([2..n-k],[n-k+1..n-1]);
    edgs:=Union(edgs,rest);
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