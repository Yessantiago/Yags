lista:=[[1,2],[2,3],[3,4],[4,1],[4,2]];
g:=GraphByEdges(lista);
#g:=PathGraph(5);;

#L:= Lista de colores, dada por el usuario

L:=[1,2,3]; 

chk:=function(L,g)
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

Kcoloration:=function(g,k)
    local colors; 
    colors:=[1..k]; 
    
    if BacktrackBag(colors,chk, Order(g), g) <> [] then 
        return true;
    else 
        return false; 
    fi; 

end;
