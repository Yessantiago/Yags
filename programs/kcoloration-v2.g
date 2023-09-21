#lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
[5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
[11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
[12,10],[17,18],[18,19]];
g:=GraphByEdges(lista);

#g:=PathGraph(5);

#Devuelve el vertice con mayores adyacentes
MaxAdj := function(ady)
    local x, mayor,v;
    mayor:=0;  

    for x in [1..Length(ady)] do           
        if (IsBound(ady[x]))then 
            if (Length(ady[x]) > mayor)then 
                mayor:= Length(ady[x]);
                v:= Position(ady,ady[x]);
            fi;
        fi; 
    od; 
    return v;
end; 

#Devuelve una lista ordenada de los vertices 
# con mayores adyacentes a menores
ListMaxAdj := function(g) #Regresa 
    local LAdy,mayor, ListaOrd; 
   
    LAdy:= Adjacencies(g);
    ListaOrd:=[];
    
    while (LAdy <> []) do
        mayor:= MaxAdj(LAdy); 
        Add(ListaOrd, mayor);
        Unbind(LAdy[mayor]); 
    od; 

    return ListaOrd;

end; 

 

Kcoloration:=function(g,k)
    local colors,v,a,x; 
    colors:=[1..k]; 
    v := Vertices(g);
    a:=[];

    Print(ListMaxAdj(g)); 


end;
