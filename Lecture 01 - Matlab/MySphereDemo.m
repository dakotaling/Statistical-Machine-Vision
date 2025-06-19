[x,y,z] = sphere;
figure;
pause
for t=1:.1:5
   surf(x+t,y+t,z+t)
   axis square
   xlim([0,10]),ylim([0,10]), zlim([0,10])
   pause(.1)
end
%print(gcf,'-dtiffn','-r100',['demoSphere'])