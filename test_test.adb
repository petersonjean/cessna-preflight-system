
   

   
--from the book Barnes - chapter 8 . Introduction...
 
with Ada.Numerics.Discrete_Random;   
package body test_test    with SPARK_Mode =>Off is
  package random_main is new Ada.Numerics.Discrete_Random (Result_Subtype =>Integer);
    
    G: random_main.Generator; 
   function Random_Number  return Integer is 
   begin
     return  random_main.Random(G);  
   end Random_Number;
begin 
  random_main.Reset(G); 
end test_test;
