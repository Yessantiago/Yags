#lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
lista := [[1,2],[2,3], [3,4], [4,9], [9,5],
[5,8],[5,6], [6,2], [6,7], [8,7],[7,1], [10,11],
[11,13],[13,14],[14,15],[15,16], [16,13],[13,12], 
[12,10],[17,18],[18,19]];
g:=GraphByEdges(lista);

#g:=PathGraph(5);
#L:= Lista de colores, dada por el usuario


# Da como resultado el adyacente con mayores vertices 
MaxAdj := function(g)
    local x,v,max;
    v := Vertices(g);

    max:= v[1]; #Al comienzo el primer vertice es el maximo con adyacentes
    for x in v do 
        #compara el max con los adyacentes del siguiente
        if (x+1 <= Length(v)) then
            if (Length(Adjacency(g,max)) < Length(Adjacency(g,x+1))) then
                max:= v[x+1];
            fi;
        fi; 
    od; 
    return max; 
end;


Kcoloration:=function(g,k)
    local colors,v,a; 
    colors:=[1..k]; 
    v := Vertices(g);
    a:=[];

    # Lista iterativa de los que tienen mayor a menor adyacente L:=[13,] luego sacar adyacentes de 13, 
    # y así hasta tener la lista 

    for x in v do 
        Add(a,MaxAdj(g)); 
        Print(a,"\n");

    od; 


end;
