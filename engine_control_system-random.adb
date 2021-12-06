
   
--from the book Barnes - chapter 8 . Introduction...

with Ada.Numerics.Discrete_Random;  

--with Ada.Numerics.Float_Random;
package body Engine_Control_System.Random with SPARK_Mode =>Off  is
  subtype  simulator is Integer range 0.. 3000; -- randomly simulate
   package random_main is new Ada.Numerics.Discrete_Random (Result_Subtype =>simulator);
    
   G: random_main.Generator;
   function Random_Number return Integer is
     
   begin 
     return  random_main.Random(Gen => G);  
   end Random_Number;
begin 
 random_main.Reset(Gen => G); 
 
end Engine_Control_System.Random;
