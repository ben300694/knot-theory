
# n degree of the cover
# g number of generators of group 

g=8
n=5
S=SymmetricGroup(5)

F=FreeGroup(g)
#Free group with generators x0,x1,...,x(g-1)


#homomorphism rho sends the generator xi to rho[i]
#rho=['(1,2)','(1,2)','(1,3)','(1,3)','(1,3)','(1,3)','(1,3)','(1,3)']
rho=['(1,2)','(1,2)','(1,2,3)','(1,2,3)','(1,2,3)','(1,2,3)','(1,4,5)','(1,4,5)']
#vertices p1,p2,p3,... note indexing starts at 1 to match symmetric group

#there is an edge from pi to pj


reachable=[1]
remaining=[i for i in range(2,n+1)] #vertices remaining to be visited
print('remaining',remaining)
claw_relations={1:[]}


while len(remaining)>0:
    
    for current in reachable:
        print("current",current)
        reachable.remove(current)
                
        for j in range(g): #j is the subscript of x_j.  
            
            #Determine which vertices you can reach from current from each of the generators x_0,...,x_g-1
            endpoint=S(rho[j])(current) 
            
            #check if the endpoint vertex has been visited.  If not (i.e., if in remaining)...
            if( endpoint in remaining):
                print("endpoint",endpoint)
                remaining.remove(endpoint) #don't visit this vertex again           
               
                
                reachable.append(endpoint)
                
                #next concatenate corresponding variable with current claw relation
                previous_subword=claw_relations[current].copy()
                print('previous_subword',previous_subword)
                print('new generator to add to subword',[j,current])              
                claw_relations.update({endpoint: previous_subword})
                claw_relations[endpoint].append([j,current])
                
                print("remaining",remaining)
                print("reachable",reachable)
                print("claw_relations",claw_relations)
                
             
print("final claw relations",claw_relations)

    
