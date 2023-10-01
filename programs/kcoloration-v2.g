#lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
# lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
# [5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
# [11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
# [12,10],[17,18],[18,19]];


lista:= [[1,2], [2,3],[3,6], [6,8],[8,7], [7,9],[7,5],[7,4],[4,1],[5,10],[5,2],[5,4],[5,6],[9,4]];
g:=GraphByEdges(lista);

#Devuelve el elemento de mayor grado de una lista de una grafica 
VertexMaxDegree := function(g,v) #Cambiar de darle una función g a una lista 
    local ListaOrd, ListMaj; 

    ListMaj := List(v, x -> VertexDegree(g,x));
    SortParallel(ListMaj,v); 
    ListaOrd:= Reversed(v);

   return ListaOrd[1];

end; 


FirstOrder:= function(g)
    local v, L, CurrentV;
    v:= Vertices(g); 
    L:=[];
    
    Add(L,VertexMaxDegree(g, v)); #Agrega el de mayor grado a la lista L 
    Remove(v, Position(v,Last(L))); #Quita el elemento de v que se agrego a L 
    
    while v <> [] do
        CurrentV:= Adjacency(g,Last(L)); #Adyacentes del vertice actual 
        CurrentV:= Difference(CurrentV, L); #Quita la diferencia

        if CurrentV = [] then
            Add(L,Last(v));
            Remove(v, Position(v,Last(L))); #Quita el elemento de v que se agrego a L 
        else 
            Add(L,VertexMaxDegree(g, v)); #Agrega el de mayor grado a la lista L
            Remove(v, Position(v,Last(L))); #Quita el vertice que se acaba de agregar a L 
        fi;         

    od; 

    return L; 
end;

Opts:= function(L, Extra) 

end;

Kcoloration:=function(g,k)
    local colors,v, L, Extra; 
    colors:=[1..k]; 

    Extra:=[g,FirstOrder(g), colors];
    Backtrack(L,Opts,Chk,Order(g),Extra);
    
end;
