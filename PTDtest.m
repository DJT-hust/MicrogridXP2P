PTD=zeros(6,6);
for ii=1:6
    for jj=1:6
        PTD(ii,jj)=CalculateOnePTD(ii,jj,PTDF);
    end
end
