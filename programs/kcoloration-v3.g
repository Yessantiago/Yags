lista:= [[1,2], [2,3],[3,6], [6,8],[8,7], [7,9],[7,5],[7,4],[4,1],[5,10],[5,2],[5,4],[5,6],[9,4]];
g:=GraphByEdges(lista);

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

GG:=function(n,k) 
   local edgs;
   edgs:=Cartesian([n],[2..n-2]);
   edgs:=Union(edgs,[[1,n-1],[n-1,n]]);
   return GraphByEdges(edgs);
end;