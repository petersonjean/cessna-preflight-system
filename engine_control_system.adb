pragma SPARK_Mode (On);


with AS_IO_Wrapper;  use AS_IO_Wrapper;   
--  with Ada.Numerics.Discrete_Random;
with Engine_Control_System.Random;  

 
package body Engine_Control_System 
is   
    

   procedure Start_Engine is
      
   begin
      AS_Put_Line("test000"); 
   end Start_Engine;
      
   procedure Read_Engine_Data(T : in engine_sensor_type ) is

      --  simulator: Float ;
     
      --  subtype  simulator is Integer range 0.. 1; -- randomly simulate
      --  package Random_Engine_Float_Data     is  new  Ada.Numerics.Discrete_Random(Simulator) ;
      --  --use Random_Engine_Float_Data;
      --  G: Random_Engine_Float_Data.Generator  ;
      --Package test is new Engine_Control_System.Random;
      
      Value : Integer;  
   begin 
      -- Random_Engine_Float_Data.Reset(G);
      case T  is  --  sensor request
         when ignition =>   AS_Put_Line("Is ignition on ?"); 
         when fuelvalve =>   AS_Put_Line("Is fuel valve on ?"); 
         when fuelvolume =>   AS_Put_Line("read fuel tank volume "); 
         when Mixture =>   AS_Put_Line("genrating Mixture data"); 
         when rpm =>   AS_Put_Line("new rpm"); 
         when throttle =>   AS_Put_Line("setting new throttle"); 
         when starter =>   AS_Put_Line("Is Electric Starter on ?");  
         when starterRuntime =>   AS_Put_Line("How long stater has been running for ?"); 
         when temperature =>   AS_Put_Line("temperature as read from engine sensor?"); 
         when Carburetor_Heat =>   AS_Put_Line("reading carburetor Heat sensor?");  
         when OilPressure =>   AS_Put_Line("reading oil Pressure?"); 
         when FuelPressure =>   AS_Put_Line("Fuel Pressure?"); 
         when StatusEngineSystem =>   AS_Put_Line(""); 
            
 
      end case; 

      
      case T  is  --  sensor request
         when ignition | fuelvalve |starter | Carburetor_Heat =>   
            loop
               AS_Get( Value,"Please type in integer 0 or 1");
               exit when Value in   0..1;
               AS_Put("Please type in  0 or 1 for sensor ");
               AS_Put_Line("");
            end loop;   
         when fuelvolume | rpm =>  
            -- Start the generator in a unique state in each run
            Value :=  Random.Random_Number;
            
               --Value := Value * Maximum_Fuel_Capacity + 1; --new simulation value for fuel volume or rpm
            --Value := 2500;
                     AS_Put("Testing" &  engine_sensor_type'Image( T) & " random for :" & Integer'Image(Value ));
              
            --  
         when mixture =>  
            -- Start the generator in a unique state in each run
            --Value :=  test.Random_Number * 18 + 1; --new simulation value for mixture
            Value := 11;
         when throttle =>  
            loop
               AS_Get( Value,"Please type in integer 0 or 2");
               exit when Value in   0..2;
               AS_Put("Please type in  0 or 1 or 2 for sensor ");
               AS_Put_Line("");
            end loop; 
         when starterRuntime =>   
            loop
               AS_Get( Value,"Please type in number of seconds from 0 or 65"); 
               exit when Value in   0..65;
               AS_Put("Please type in integer second value ");
               AS_Put_Line("");
            end loop; 
         when temperature =>   
            loop
               AS_Get( Value,"Please type in number of seconds from 0 or 65"); 
               exit when  Value > 0  and Value <  Maximum_Temperature_Possible;
               AS_Put("Please type in valid sensor temperature  value ");
               AS_Put_Line("");
            end loop; 
         when OilPressure =>    
              loop
               AS_Get( Value,"Please type in number of PSI from 0 or 100 for Oil pressure"); 
               exit when  Value > 0  and Value <  100;
               AS_Put("Please type in valid Oil pressure  value ");
               AS_Put_Line("");
            end loop; 
         when FuelPressure =>    
            null;
         when StatusEngineSystem =>      
            null;
      end case; 
      
      case T  is  --  sensor request
         when ignition =>  Engine.Ignition := sensor_value(Value);
         when fuelvalve =>   Engine.Fuel_Valve := sensor_value(Value);
         when fuelvolume =>   Engine.Fuel_Volume := Value; 
         when rpm =>    Engine.Rpm := Value;
         when throttle =>   Engine.Throttle := Value; 
         when mixture =>   Engine.Mixture := Value; 
         when starter =>   Engine.Electric_Starter := sensor_value(Value);
         when starterRuntime =>  Engine.Electric_Starter_Running_Time := Value;
         when temperature =>   Engine.Temperature :=  Value;
         when Carburetor_Heat =>  Engine.Carburetor_Heat := sensor_value(Value);  
         when OilPressure => Engine_Pressure_System.Oil_Pressure := Value; 
         when FuelPressure =>   null; 
         when StatusEngineSystem =>   null; 
            
      end case;
     
  

   end Read_Engine_Data;
   
   function Status_Engine_System_To_String (Engine   : Status_Engine_System_Type) return String is
   begin
      case Engine is
      when Activated =>
         return "good ";
      when Not_Activated =>
         return " badly";  
      end case;
   end Status_Engine_System_To_String;
	
   procedure Print_Engine_Status(T: in engine_sensor_type) is
   begin 
      if ( T  = StatusEngineSystem )then
         AS_Put("Engine  is running ");
         AS_Put_Line(Status_Engine_System_To_String(Engine.Status_Engine_System)); 
      elsif( t = ignition) then
          AS_Put("Engine  ignitison ");
         AS_Put_Line(Status_Engine_System_To_String(Engine.Ignition_System)); 
      
       
      end if;
       
   end Print_Engine_Status;


   procedure Monitor_Engine_System(T: in engine_sensor_type; Status_Door_System: in Status_System_Type ) is
   begin
      
      case T  is  --  sensor request
         when ignition =>   
            --todo: add check for position light and beacon ligt
            --todo: add check for brake
            --todo: add check from door and seat system
            --todo add check for radio turn off
            --add check engine starter on
            -- todo : add carburateor heat check to off
            --todo: add throttle check : to 1 in medium
            
            if(Engine.Ignition = 1 and  Engine.Fuel_Valve = 1 and Status_Door_System.Value_Measured = 1) then
               Engine.Ignition_System := Activated;
            else Engine.Ignition_System := Not_Activated;
            end if;
            AS_Put(Integer(Status_Door_System.Value_Measured));
            --when fuelvalve =>   AS_Put_Line("Is fuel valve on ?"); 
         when fuelvolume =>  
            if(Engine.Fuel_Volume < Maximum_Fuel_Capacity and Engine.Fuel_Volume > Minimum_Fuel_Capacity) then
               Engine.Fuel_Status := High;
            else  Engine.Fuel_status := Low;
            end if;
         when mixture =>  
            if(Engine.Mixture >= 6 and Engine.Mixture <= 12)  then
               Engine.Mixture_Status := Rich;
            elsif (Engine.Mixture > 12 and Engine.Mixture <= 18) then
               Engine.Mixture_Status := Lean;
            else
               Engine.Mixture_Status := Poor;
            end if;
         when fuelvalve =>  null;
         when starter =>  null;
         when throttle => null ;
         when temperature =>  null;
         when Carburetor_Heat =>  null;
               
         when starterRuntime =>
            if (Engine.Electric_Starter_Running_Time > 60 ) then
               Engine.Electric_Starter :=0;
               Engine.Electric_Starter_Running_Time:= 0;
            end if;
         when OilPressure =>
            if (Engine.Rpm >= 1000 and  Engine_Pressure_System.Oil_Pressure >= 25 and Engine.Fuel_Status = High) then
               Engine_Pressure_System.Oil_Pressure_Condition := Good;
            else 
               Engine_Pressure_System.Oil_Pressure_Condition := Bad;
            end if;
         when FuelPressure => null ;  
         when StatusEngineSystem => 
            
            if (Engine.Ignition_System = Activated  and  Engine_Pressure_System.Oil_Pressure_Condition = Good and Engine.Fuel_Status = High) then
               Engine.Status_Engine_System := Activated;
            else 
               Engine.Status_Engine_System := Not_Activated;
            end if;
         when rpm =>  null;
          
      end case;  
      --  Put_Line(Integer'Image( Engine.Rpm));
      --  Put_Line(Integer'Image( Engine_Pressure_System.Oil_Pressure));
      --   Put_Line(Status_Engine_System_Type'Image( Engine.Ignition_System));
      --  Put_Line(Status_Fuel_Type'Image( Engine.Fuel_Status));
      --  Put_Line(General_Condition'Image(Engine_Pressure_System.Oil_Pressure_Condition));
   end Monitor_Engine_System;


   procedure Init_Engine is
   begin
      AS_Init_Standard_Input; 
      AS_Init_Standard_Output;
      Engine := (
                 Ignition => 0,
                 Fuel_Valve  => 0,
                 Fuel_volume =>0,
                 mixture => 0,
                 Rpm => 0,
                 Throttle => 0,
                 Electric_Starter => 0,
                 Electric_Starter_Running_Time => 0,
                 Status_Engine_System => Not_Activated,
                 Temperature => 0,
                 Carburetor_Heat=> 0,
                 Ignition_System => Not_Activated,
                 Fuel_Status => Low,
                 Mixture_Status => Poor);
      Engine_Pressure_System := (
                                 Oil_Pressure => 0,
                                 Fuel_Pressure => 0,
                                 Oil_Pressure_Condition => Bad,
                                 Fuel_Pressure_Condition => Bad);
       
   end Init_Engine;
   
   
end Engine_Control_System;


