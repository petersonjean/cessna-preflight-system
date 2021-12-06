pragma SPARK_Mode (On); 
with Door_Seat_System; use Door_Seat_System;
with SPARK.Text_IO;use  SPARK.Text_IO;  

--engine rpm status - indicates if power on or not.
--oil pressure
-- fuel pressure
--heat for cabin and 
--air quality  for mixture
--position light at night
 
package Engine_Control_System   
is 
  Maximum_Temperature_Possible : constant Integer := 1000;
   
   Maximum_Fuel_Capacity: constant Integer := 3000;
   Minimum_Fuel_Capacity: constant Integer := 500;  
   type General_Condition is (Good, Bad); 
   
   --data list types  : ignition , 2=> Pilot Seat
   type engine_sensor_type is 
     (ignition,
      fuelvalve,
      fuelvolume, 
      mixture,
      rpm,
      throttle, -- 3 modes: in full , out full, in medium
      starter, 
      starterRuntime,
      Carburetor_Heat,
        temperature,
      OilPressure,
      FuelPressure, 
      StatusEngineSystem);
   type Status_Engine_System_Type is (Activated, Not_Activated);
   type Status_Fuel_Type is (High, Low);
   type Status_Mixture_Type is (Poor,Rich, Lean); 
   type Engine_System_Type  is 
      record
         -- in general system power should be on
         Ignition: sensor_value;
         Fuel_Valve   : sensor_value;
         Fuel_Volume: Integer;
         Mixture: Integer; -- control fuel and oxygen mixture in engine chamber
         Rpm: Integer; -- number of time engine turn propeller
         Throttle: Integer; -- amount of fuel provided to engine
         Electric_Starter: sensor_value;
         Electric_Starter_Running_Time: Integer ; -- should not last more than 30 - 60seconds
         Temperature: Integer;
         Carburetor_Heat:sensor_value;
         Status_Engine_System : Status_Engine_System_Type;
         Ignition_System: Status_Engine_System_Type;
         Fuel_Status: Status_Fuel_Type;
         Mixture_Status: Status_Mixture_Type;
      end record;
   
   type Engine_Pressure_System_Type  is 
      record
         Oil_Pressure: Integer;
         Fuel_Pressure:Integer;
         Oil_Pressure_Condition: General_Condition;
         Fuel_Pressure_Condition: General_Condition;
      end record;
   
   -- Engine and Engine_Pressure_System are  global variables provide access to engine data and systems
   Engine : Engine_System_Type ;
   Engine_Pressure_System : Engine_Pressure_System_Type; 
   
   --get value from Engine and engine Pressure system
   procedure Read_Engine_Data(T : in engine_sensor_type ) with
     Global => (In_Out => (Standard_Output, Standard_Input,Engine, Engine_Pressure_System)),
     Depends => (Standard_Output => (Standard_Output,Standard_Input,T),
                 Standard_Input  => Standard_Input,  
                 Engine   => (Engine, Engine_Pressure_System,Standard_Input,T),
                 Engine_Pressure_System => ( Engine_Pressure_System, Standard_Input,T)
                )
   ;
   
   --used to run routine check on door and seat system and report to main system
   procedure Monitor_Engine_System(T: in engine_sensor_type; Status_Door_System: in Status_System_Type )  with
     Global  => (  
                   In_Out => (Engine_Pressure_System,Engine)),
     Depends => (Engine => (Engine,Engine_Pressure_System,T, Status_Door_System),
                 Engine_Pressure_System =>( Engine_Pressure_System,Engine,T)
              ),
     Post    => (Is_Engine_Safe(Engine ,Engine_Pressure_System,Status_Door_System));
   
   
   function  Status_Engine_System_To_String (Engine   : Status_Engine_System_Type)  return String;
      
   
   -- Print Status of engine
   procedure Print_Engine_Status(T: in engine_sensor_type) with
     Global => (In_Out => Standard_Output, 
                Input  => ( Engine)),
     Depends => (Standard_Output => (Standard_Output,Engine,T));
   
   -- Is_Engine_Safe check if overall engine procedure are running in safe states
   --used for verification for these sensors
   -- both conditions is important for this part of the system to be considered
   --safe as for this small plane, there should be a pilot onthe seat and door should be locked
   function Is_Engine_Safe (Status_Engine : Engine_System_Type; Status_Engine_Pressure : Engine_Pressure_System_Type; Status_Door_System:  Status_System_Type) return Boolean is
       
     ( ((Engine.Ignition = 1 and Status_Engine.Fuel_Valve = 1 and Status_Door_System.Status_Sensor_System = Activated and Status_Engine.Ignition_System = Activated) 
       or 
         Status_Engine.Ignition_System = Not_Activated )
       and
         ((Status_Engine.Mixture >= 6 and Status_Engine.Mixture <= 12  and   Status_Engine.Mixture_Status = Rich )
          or 
            ( Status_Engine.Mixture > 12 and Status_Engine.Mixture <= 18 and             Status_Engine.Mixture_Status = Lean)
          or 
            Status_Engine.Mixture_Status = Poor)
       and (
         (Status_Engine.Ignition_System = Activated  and  Status_Engine_Pressure.Oil_Pressure_Condition = Good and Status_Engine.Fuel_Status = High and
               Status_Engine.Status_Engine_System = Activated)
            or 
              Status_Engine.Status_Engine_System = Not_Activated
        )
         
      );
    
   -- intialisse door and pilot seat system sensors
   procedure Init_Engine with
     Global => (Proof_In => Status_Door_System,
                  Output => (Standard_Output,Standard_Input,Engine,Engine_Pressure_System)),
     Depends => ((Standard_Output,Standard_Input,Engine,Engine_Pressure_System) => null
                ),
     Post    => (Is_Engine_Safe(Engine ,Engine_Pressure_System,Status_Door_System));

   procedure Start_Engine;
   
end Engine_Control_System;
