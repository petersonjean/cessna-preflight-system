pragma SPARK_Mode (On);
  

package General_System is
   
   type General_Condition is (Good, Bad);
   -- enum value for sensors input value
   type sensor_value  is new Integer range 0 .. 1;
   type Brake_System_Type  is 
      record
         Status: sensor_value;
         
      end record;
   
   --Status of radio equipment
   type Radio_System_Type is 
      record
         Status: sensor_value;
      end record;
   
   
   --Status of electrical  equipment

   type Electrical_System_type is
      record 
         status: sensor_value;  -- 1 : key switch on
         ammeter: Float;   -- show current draw
      end record;
      
   -- position light always on prior engine
   type Light_System_type is
      record
         beacon: sensor_value;
         position: sensor_value;
      end record;
   --Altimeter for altitude 
   type Instrument_Type is 
      record
         Value : Integer; -- in feet
         Instrument: General_Condition;
      end record;
   type Flap_System_type is
      record
         Flap_Left: sensor_value;
         Flap_Right: sensor_value;
         Status_Flap : General_Condition;
      end record; 
   -- Status door and seat System are  global variables determining the status of door and pilot seat systems
         
   Altimeter : Instrument_Type;
   Airspeed: Instrument_Type;
   ADF_System: Instrument_Type; -- bnackup direction finder
   Transponder_System: Instrument_type; --sending airecrat altitude and poistion to ATC tower, safety critical.
   Yoke_System:sensor_value;
   Light_System:  Light_System_type;
   Brake: Brake_System_Type;
   Circuit_Breaker: Electrical_System_type;
   Flaps: Flap_System_type;
   
   
   procedure Print_Status;
end General_System;
