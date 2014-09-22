clear all
close all
load ('Celegans.mat')
Nodes = length(Adj); %number of neurons,i.e. nodes
AdjOnes=Adj; %AdjOnes will be the correct adjacency matrix with only 1's & 0's
for row = 1:Nodes %checking cell values row-by-row
    for col = 1:Nodes %checking cell values column-by-column
        if Adj(row,col)>0 %if connection exists
            AdjOnes(row,col)=1;
        end
        if Adj(row,col) == 0 %if connection does not exist
            AdjOnes(row,col)=0; 
        end
    end
end

for StartNode=1:Nodes %calculating minimum path length from varying start node to all other nodes
    pathlength(StartNode,:) = dijkstra(AdjOnes,StartNode); %'pathlength' is a matrix containing the pathlength from any node to another
end

TF=isinf(pathlength); %TF: a matrix containing 1's wherever the pathlength is Inf and otherwise 0

i=0; %counting the number of cols/rows that have an inifinite pathlength, i.e. are not connected to the  rest of the network
for col = 1:Nodes
    if TF(1,col)==1 %need to check only the first column if a node is connected to other nodes
        i = i+1; % counting up the amount of unconnected nodes
        Infcols(i) = col; %infocols contains the index of the columns/neurons that are not connected to the rest of the network
    end
end
pathlengthCleaned=pathlength; %pathlengthCleaned will contain only the connected nodes
pathlengthCleaned(Infcols,:) = []; %removing the unconnected columns/nodes 
pathlengthCleaned(:,Infcols) = []; %removing the unconnected rows/nodes 
AdjOnesCleaned=AdjOnes; %'AdjOnesCleaned will contain only 1's & 0's and only nodes connected to the rest of the network 
AdjOnesCleaned(Infcols,:)=[]; %removing the unconnected columns/nodes
AdjOnesCleaned(:,Infcols)=[]; %removing the unconnected rows/nodes

spy(AdjOnesCleaned) %visualising the cleaned adjacency matrix
title('C. Elegans neural network adjacency matrix visualisation')
 
Uppertriangular=triu(AdjOnesCleaned); %number of ones in the (upper)triangular matrix is the number of links in the network
NodesCleaned=Nodes-length(Infcols); %Number of nodes in the "cleaned" network
Links=0; %initializing value of 'Links'
for row = 1:NodesCleaned %checking cell values row-by-row
    MeanRows(row) = mean(pathlengthCleaned(row,:)); %calculating the mean path length from one node to all nodes
    for col = 1:NodesCleaned %checking cell values column-by-column
        if Uppertriangular(row,col)==1 %checking for the link from one node to another
            Links=Links+1; %counting the number of links
        end
    end
end

NetworkDiameter = mean(MeanRows); %calculating the mean of the mean path length from one node to all nodes, i.e the network diameter