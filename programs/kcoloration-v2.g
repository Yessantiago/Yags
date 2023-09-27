#lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
[5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
[11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
[12,10],[17,18],[18,19]];
g:=GraphByEdges(lista);


#Devuelve una lista ordenada de los vertices 
# con mayores adyacentes a menores
ListMaxAdj := function(g) #Regresa 
    local ListaOrd, ListMaj, v; 
    v := Vertices(g);

    ListMaj := List(v, x -> VertexDegree(g,x));  
    SortParallel(ListMaj,v); 
    
    ListaOrd:= Reversed(v);
    
    return ListaOrd;

end; 

 

Kcoloration:=function(g,k)
    local colors,v,ListMaj; 
    colors:=[1..k]; 
    
    Print(ListMaxAdj(g));

end;
