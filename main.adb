-- this is the executable file 
-- running the nuclear power system
--
-- it initialises the system
-- then runs for ever in a loop which
--   1) reads the temperature from console
--   2) monitors the cooling system so that the cooling
--      system is activated if the temperature is too high
--   3) prints out the status
-- 
--  the loop_invariant expresses that the system stays safe all the time.

pragma SPARK_Mode (On); 

with Door_Seat_System;
use Door_Seat_System;

with Engine_Control_System;
use Engine_Control_System;
procedure Main
is
   --  task My_Task;
   --  task body My_Task is
   --  begin
   --     for I in 0..  26  loop
   --        AS_Put_Line (I);
   --     end loop;
   --  end My_Task;
begin  
   
   Init_Door_Seat;
   Init_Engine;
  
   loop
      pragma Loop_Invariant ( Is_Door_Seat_Safe(Status_Door_System,door) and Is_Door_Seat_Safe(Status_Door_System,seat) and Is_Engine_Safe(Engine ,Engine_Pressure_System,Status_Door_System));
      Read_Sensor(door);
      Monitor_Door_Seat_System(door);
      Print_Sensor_Status(door); 
      
      Read_Sensor(seat);
      Monitor_Door_Seat_System(seat);
      Print_Sensor_Status(seat); 
      
      Read_Engine_Data(fuelvalve);
      Read_Engine_Data(starter);
      
      Read_Engine_Data(fuelvolume);
      Monitor_Engine_System(fuelvolume,Status_Door_System);
        
      Read_Engine_Data(mixture);
      Monitor_Engine_System(mixture,Status_Door_System);
      
      Read_Engine_Data(starterRuntime);
      
      
      Read_Engine_Data(ignition);
      Monitor_Engine_System(ignition, Status_Door_System);
      
      Read_Engine_Data(rpm);
      
      Read_Engine_Data(OilPressure);
      Monitor_Engine_System(OilPressure,Status_Door_System);
      
      Monitor_Engine_System(StatusEngineSystem, Status_Door_System);
      Print_Engine_Status(ignition);
      Print_Engine_Status(StatusEngineSystem);
   end loop;
         
      
end Main;
      

